//
//  WBFPSManager.m
//  WBTool
//
//  Created by donghuan1 on 16/9/7.
//  Copyright © 2016年 Sina. All rights reserved.
//

#import "WBFPSManager.h"
#import "WBTDJSONKit.h"
#import "UIDevice+WBMHelper.h"
#import "WBTDReachability.h"
#import "NSDictionary+WBTKeyValue.h"
#import "WBAlertView.h"
#import "objc/runtime.h"

@class JDStatusBarView;
@interface JDStatusBarNotification : NSObject
+ (JDStatusBarView*)showWithStatus:(NSString *)status
                         styleName:(NSString*)styleName;
@end


@protocol WBNodeFakeProperty <NSObject>

- (NSString *)containerId;

@end

@interface WBFPSManager()
{
    CADisplayLink *fpsTimer;
    dispatch_queue_t fpsQueue;
    
    //WBFPSRecordRuleCard
    NSMutableArray *FPSResults;
    //WBFPSRecordRuleFeed
    NSMutableArray *mBlogs;
    
    //临时变量
    float *feedFPSBuffer;     //用于存储多个瞬时Fps值求平均值
    int feedFPSBufferSize;    //buffer的大小
    
    CFTimeInterval currentTimeStamp;    //存储上一次CADisplayLink进入的时间
    CFTimeInterval currentDuring;       //当前求得的耗时
    
    float currentFPSValue;    //当前求得的FPS值
    
    float currentFPSBufferValue;    //遍历buffer区是存储的临时变量
    NSInteger currentValidCount;    //记录遍历buffer区时的有效数据个数
    float currentFPSValueSum;    //记录当前遍历buffer后的FPS值总和，除currentValidCount求得平均值
    float currentAverageValue;   //记录求得的当前FPS值平均值
    NSMutableArray *classMaps;
}

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *tmpCachetype;

@property (nonatomic,weak)id currentVC;
@property (nonatomic,weak)id tmpCacheVC;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end

@implementation WBFPSManager

#pragma mark - LifeCycle

+ (WBFPSManager *)sharedManager
{
    static WBFPSManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WBFPSManager alloc]init];
    });
    return manager;
}

-(void)setPrecision:(NSUInteger)precision
{
    [self endRecord];
    _precision = precision;
    feedFPSBufferSize = ceil(60/_precision);
    feedFPSBuffer = nil;
    //缓存区，如果每秒1次，那么会取60次的平均值。
    feedFPSBuffer = malloc(sizeof(float)*feedFPSBufferSize);
    memset(feedFPSBuffer,0,feedFPSBufferSize*sizeof(int));
}

- (instancetype)init
{
    if (self = [super init]) {
        fpsQueue = dispatch_queue_create("com.sina.fps.serial", DISPATCH_QUEUE_SERIAL);

        //WBFPSRecordRuleFeed
        mBlogs = [[NSMutableArray alloc]initWithCapacity:10];
        FPSResults = [[NSMutableArray alloc]initWithCapacity:10];
        classMaps = [[NSMutableArray alloc]initWithCapacity:2];
//        self.type = @"feed";
        //精确度默认每秒1次
        self.precision = 2;
        _mainSwitch = NO;
        [self swizzledViewController];
        

    }
    return self;
}

-(void)setMainSwitch:(BOOL)mainSwitch
{
    if (_mainSwitch == mainSwitch) {
        return;
    }
    _mainSwitch = mainSwitch;
    
    if (!_mainSwitch)
    {
        [self endRecord];
    }
}

- (void)fpsViewDidAppear:(BOOL)animated
{
    [self fpsViewDidAppear:animated];
    [[WBFPSManager sharedManager] startRecordType:self];
}

- (void)fpsViewDidDisAppear:(BOOL)animated
{
    [self fpsViewDidDisAppear:animated];
}

- (void)fpsScrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self respondsToSelector:@selector(fpsScrollViewWillBeginDragging:)] && [self respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self fpsScrollViewWillBeginDragging:scrollView];
    }
    [WBFPSManager sharedManager].needRecording = YES;
}

- (void)fpsScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    if ([self respondsToSelector:@selector(fpsScrollViewDidEndDragging:willDecelerate:)] && [self respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self fpsScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    if (!decelerate) {
        [WBFPSManager sharedManager].needRecording = NO;
    }
}

- (void)setNeedRecording:(BOOL)needRecording
{
    _needRecording = needRecording;
}

- (void)fpsScrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    if ([self respondsToSelector:@selector(fpsScrollViewDidEndDecelerating:)] && [self respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self fpsScrollViewDidEndDecelerating:scrollView];
    }
    
    [WBFPSManager sharedManager].needRecording = NO;
}

- (void)recoverSwizzledMethod:(SEL)originSEL swizzled:(SEL)swizzlSEL Class:(Class)class
{
    Method originalMethod = class_getInstanceMethod(class, originSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzlSEL);
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
}

- (void)swizzledMethod:(SEL)originSEL swizzled:(SEL)swizzlSEL Class:(Class)class
{
    Method originalMethod = class_getInstanceMethod(class, originSEL);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzlSEL);
    BOOL didAddMethod = class_addMethod(class, originSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod)//本身没有
    {
        IMP originalIMP = method_getImplementation(originalMethod);
        BOOL didAddSwizz = class_addMethod(class, swizzlSEL, originalIMP, method_getTypeEncoding(originalMethod));
    }
    else
    {
        class_addMethod(class, swizzlSEL, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        Method cSwizzledMethod = class_getInstanceMethod(class, swizzlSEL);
        method_exchangeImplementations(originalMethod, cSwizzledMethod);
    }

}

- (void)swizzledViewController
{
    [self swizzledMethod:@selector(viewDidAppear:) swizzled:@selector(fpsViewDidAppear:) Class:NSClassFromString(@"WBTableViewController")];
    [self swizzledMethod:@selector(viewDidDisAppear:) swizzled:@selector(fpsViewDidDisAppear:) Class:NSClassFromString(@"WBTableViewController")];
}


- (void)swizzledScrollView
{
    [self swizzledMethod:@selector(scrollViewWillBeginDragging:) swizzled:@selector(fpsScrollViewWillBeginDragging:) Class:[_currentVC class]];
    [self swizzledMethod:@selector(scrollViewDidEndDragging:willDecelerate:) swizzled:@selector(fpsScrollViewDidEndDragging:willDecelerate:) Class:[_currentVC class]];
    [self swizzledMethod:@selector(scrollViewDidEndDecelerating:) swizzled:@selector(fpsScrollViewDidEndDecelerating:) Class:[_currentVC class]];
}

- (void)startRecordType:(id)type_;
{
    if (!self.mainSwitch) {
        return;
    }
    
    _tmpCacheVC = type_;
    NSString *type = NSStringFromClass([type_ class]);
    _tmpCachetype = type;
    //干掉
    if ([type isEqualToString:@"HomeViewController"])//feed&card直接开启
    {
        [self activeTimer];
    }
    else if ([type isEqualToString:@"WBNodeDemoTableViewController"])
    {
        _tmpCachetype = [type_ performSelector:@selector(containerId)];
        if (_tmpCachetype.length == 0) {
            _tmpCachetype = type;
        }
        [self activeTimer];
    }
    else//等待输入后开启
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@%@",@"当前：",_tmpCachetype] message:@"可以输入别名如：评论列表" delegate:self cancelButtonTitle:@"不统计" otherButtonTitles:@"开始统计", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        UITextField *des = [alert textFieldAtIndex:0];
        des.placeholder = @"描述，如：评论列表";
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *typeFiled = [alertView textFieldAtIndex:0];
        if (typeFiled.text.length > 0) {
            _tmpCachetype = typeFiled.text;
        }
        [self activeTimer];
    }
}

- (void)activeTimer;
{
    //清理工作
    [self endRecord];
    self.needRecording = NO;
    
    //Swizzled工作
    NSString *type = NSStringFromClass([_tmpCacheVC class]);
    _currentVC = _tmpCacheVC;
    self.type = _tmpCachetype;

    
    if (![classMaps containsObject:[_tmpCacheVC class]]) {
        __block NSMutableArray *removeClasses = [[NSMutableArray alloc] initWithCapacity:2];
        [classMaps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isSubclassOfClass:[_tmpCacheVC class]] || [[_tmpCacheVC class] isSubclassOfClass:obj]) {
                [removeClasses addObject:obj];
                [self recoverSwizzledMethod:@selector(scrollViewWillBeginDragging:) swizzled:@selector(fpsScrollViewWillBeginDragging:) Class:obj];
                [self recoverSwizzledMethod:@selector(scrollViewDidEndDragging:willDecelerate:) swizzled:@selector(fpsScrollViewDidEndDragging:willDecelerate:) Class:obj];
                [self recoverSwizzledMethod:@selector(scrollViewDidEndDecelerating:) swizzled:@selector(fpsScrollViewDidEndDecelerating:) Class:obj];
            }
        }];
        [classMaps removeObjectsInArray:removeClasses];
        
        [self swizzledScrollView];
        [classMaps addObject:[_tmpCacheVC class]];
    }
    
    //计时器工作
    if ([self respondsToSelector:@selector(caculate:)])
    {
        fpsTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(caculate:)];
        [fpsTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

//提前结束
- (void)endRecord
{
    
    [fpsTimer invalidate];
    fpsTimer = nil;
    currentTimeStamp = 0;
    currentValidCount = 0;
    currentFPSValueSum = 0;
    memset(feedFPSBuffer,0,feedFPSBufferSize*sizeof(int));
    [FPSResults removeAllObjects];
}

#pragma mark - RecordRuleForCard
- (void)caculate:(CADisplayLink *)timer
{
    if (currentTimeStamp == 0)
    {
        currentTimeStamp = timer.timestamp;
        return;
    }
    currentDuring = timer.timestamp - currentTimeStamp;
    currentTimeStamp = timer.timestamp;
    currentFPSValue = 1.0/currentDuring;
    for (int i=feedFPSBufferSize - 1; i > 0; i--) {
        feedFPSBuffer[i]=feedFPSBuffer[i-1];
    }
    //最新的数据入到第一个位置
    feedFPSBuffer[0] = currentFPSValue;
    
    if (feedFPSBuffer[feedFPSBufferSize-1] > 0)
    {
        for (int i=0; i < feedFPSBufferSize; i++) {
            currentFPSBufferValue = feedFPSBuffer[i];
            if (currentFPSBufferValue > 0) {
                currentFPSValueSum += currentFPSBufferValue;
                currentValidCount ++;
            }
        }
        currentAverageValue = ceil(currentFPSValueSum/MAX(currentValidCount, 1));
        
        [self mergeFPSDatas:currentAverageValue TimeStamp:currentTimeStamp];
        currentValidCount = 0;
        currentFPSValueSum = 0;
        memset(feedFPSBuffer,0,feedFPSBufferSize*sizeof(int));
    }
}

- (void)mergeFPSDatas:(float)fps TimeStamp:(CFTimeInterval)time
{
    if (!_needRecording) {
        return;
    }
    
    int intfps = ceil(fps);
    NSUInteger fpsvalue = MIN(60, intfps);
    
     [FPSResults addObject:[NSNumber numberWithInteger:fpsvalue]];
    //记1分钟
    float persent = FPSResults.count/2;
    NSString *info = [NSString stringWithFormat:@"%@%@%@%.1f%@",@"name:",self.type,@";progress:",persent,@"%"];
    [JDStatusBarNotification showWithStatus:info styleName:@"JDStatusBarStyleDark"];
    if (FPSResults.count > 100*_precision)
    {
        __block NSArray *uploadArr = [NSArray arrayWithArray:FPSResults];
        __block NSMutableDictionary *mergeDict = [NSMutableDictionary dictionary];
        [mergeDict setObject:uploadArr forKey:@"fpsvalue"];
        [self endRecord];
        [WBAlertView alertWithTitle:@"是否上传fps统计" message:@"取消将清空当前数据" cancelTitle:@"取消" okTitle:@"上传" cancel:^{
            
        } complete:^{
            dispatch_async(fpsQueue, ^{
                NSString *path = @"http://15j90104t3.iok.la/UploadVCFPSFile.php";
                if ([self.type isEqualToString:@"HomeViewController"])
                {
                    path = @"http://15j90104t3.iok.la/UploadFPSFile.php";
                }
                else if ([self.type containsString:@"card"])
                {
                    path = @"http://15j90104t3.iok.la/UploadCardFPSFile.php";
                }
                else if(self.type.length > 0)
                {
                    path = @"http://15j90104t3.iok.la/UploadVCFPSFile.php";
                }
                [self uploadData:[mergeDict WBTD_JSONData] Path:path Parameter:nil];
            });
        }];
        
    }
    //启动一次统计一次
}

- (void)recordMBlogs:(NSString *)statusId Trend:(BOOL)isTrend
{
    //只存储10个
    if (isTrend) {
        statusId = [NSString stringWithFormat:@"%@%@",statusId,@"(Trend)"];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:statusId,@"statusId",[NSNumber numberWithDouble:currentTimeStamp],@"timeStamp", nil];
    if (mBlogs.count > 10) {
        [mBlogs removeLastObject];
    }
    [mBlogs insertObject:dict atIndex:0];
}



#pragma mark - Upload Methods

/**
 *
 *   上传数据到服务器
 @prama mData utf-8 json格式
 @prama path 上传路径
 @prama dict post参数
 * 会自带app版本，微博版本，设备型号，网络状态
 *
 */
- (void)uploadData:(NSData *)mData Path:(NSString *)path Parameter:(NSMutableDictionary *)dict;
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *iosV = [UIDevice currentDevice].systemVersion;
    NSString *deviceV = [UIDevice wbm_getDeviceModelName];
    NSString *netType = [self currentNetworkType];
    NSMutableDictionary *uploadDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [uploadDict wbt_setSafeObject:iosV forKey:@"ios_version"];
    [uploadDict wbt_setSafeObject:app_Version forKey:@"weibo_version"];
    [uploadDict wbt_setSafeObject:deviceV forKey:@"device_version"];
    [uploadDict wbt_setSafeObject:netType forKey:@"net_type"];
    [uploadDict wbt_setSafeObject:self.type forKey:@"type"];
    /**
     *  post的上传文件，不同于普通的数据上传，
     *  普通上传，只是将数据转换成二进制放置在请求体中，进行上传，有响应体得到结果。
     *  post上传，当上传文件是， 请求体中会多一部分东西， Content——Type，这是在请求体中必须要书写的，而且必须要书写正确，不能有一个标点符号的错误。负责就会请求不上去，或者出现请求的错误（无名的问题等）
     *  其中在post 请求体中加入的格式有{1、边界 2、参数 3、换行 4、具体数据 5、换行 6、边界 7、换行 8、对象 9、结束符}
     */
    NSURL *url = [NSURL URLWithString:path];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // 设置请求头数据 。  boundary：边界
    [request setValue:@"multipart/form-data; boundary=----WebKitFormBoundaryftnnT7s3iF7wV5q6" forHTTPHeaderField:@"Content-Type"];
    
    // 给请求体加入固定格式数据
    NSMutableData *data = [NSMutableData data];
    /*******************设置文件参数***********************/
    // 设置边界 注：必须和请求头数据设置的边界 一样， 前面多两个“-”；（字符串 转 data 数据）
    [data appendData:[@"------WebKitFormBoundaryftnnT7s3iF7wV5q6" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 设置传入数据的基本属性， 包括有 传入方式 data ，传入的类型（名称） ，传入的文件名， 。
    [data appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"parsertime.txt\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 设置 内容的类型  “文件类型/扩展名” MIME中的
    [data appendData:[@"Content-Type: text/html" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 加入数据内容
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //UIImage *image = [UIImage imageNamed:@"pause"];
    //NSData *imageData = UIImagePNGRepresentation(image);
    [data appendData:mData];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // 设置边界
    [data appendData:[@"------WebKitFormBoundaryftnnT7s3iF7wV5q6" dataUsingEncoding:NSUTF8StringEncoding]];
    [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    /******************非文件参数***************************/
    [uploadDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] && [obj isKindOfClass:[NSString class]])
        {
            // 内容设置 ， 设置传入的类型（名称）
            NSString *keyStr = [NSString stringWithFormat:@"%@%@%@",@"Content-Disposition: form-data; name=\"",key,@"\""];
            [data appendData:[keyStr dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            // 传入的名称username = lxl
            [data appendData:[obj dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            // 设置边界
            [data appendData:[@"------WebKitFormBoundaryftnnT7s3iF7wV5q6" dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }];
    
    request.HTTPBody = data;
    request.HTTPMethod = @"POST";
    
    [NSURLConnection sendAsynchronousRequest:request  queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
}

- (NSString*)currentNetworkType
{
    WBTDNetworkDetailStatus status = [[WBTDReachability sharedReachability] currentDetailReachabilityStatus];
    NSString* connectType = @"";
    switch (status) {
        case WBTDNetworkDetailStatusWifi:
            connectType = @"wifi";
            break;
        case WBTDNetworkDetailStatus4G:
            connectType = @"4g";
            break;
        case WBTDNetworkDetailStatus3G:
            connectType = @"3g";
            break;
        case WBTDNetworkDetailStatus2G:
            connectType = @"2g";
            break;
        case WBTDNetworkDetailStatusUnable:
            connectType = @"no";
            break;
        case WBTDNetworkDetailStatusWWAN:
        default:
            connectType = @"mobile";
            break;
    }
    return connectType;
}

@end
