//
//  CoreTextViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/9/28.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "CoreTextViewController.h"
#import <CoreText/CoreText.h>

@interface TestView1 : UIView

@end

@implementation TestView1

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //图片绘制示例
    /*
    UIImage *img = [UIImage imageNamed:@"test.png"];
    UIImage *img2= [UIImage imageNamed:@"test1.png"];
    
    CGRect rect1 = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, img.size.width, img.size.height);
    CGRect rect2 = CGRectMake(0, -img.size.height, img2.size.width, img2.size.height);
    
    CGContextSaveGState(context);
    UIGraphicsBeginImageContextWithOptions(img.size, NO, [img scale]);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -img.size.height);
    CGContextDrawImage(context, rect1, img.CGImage);
    CGContextRestoreGState(context);
    
    
    CGContextSaveGState(context);
    UIGraphicsBeginImageContextWithOptions(img2.size, NO, [img2 scale]);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -img2.size.height);
    CGContextDrawImage(context, rect2, img2.CGImage);
    CGContextRestoreGState(context);
     */
    //图片绘制示例
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形的变换矩阵为不做图形变换
    CGContextScaleCTM(context, 1.0, -1.0);//缩放方法，x轴缩放系数为1，则不变，y轴缩放系数为-1，则相当于以x轴为轴旋转180度
    CGContextTranslateCTM(context, 0, -self.bounds.size.height);//平移方法，将画布向上平移一个屏幕高
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"测试富文本显示"];
    
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    CTFrameRef frameref = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(frameref, context);
}

@end

@interface TestView : UIView
{
    CTFrameRef kFrameRef;
    NSString *originStr;
}

@end

@implementation TestView
void RunDelegateDeallocCallback( void* refCon ){
    
}

CGFloat RunDelegateGetAscentCallback( void *refCon ){
//    NSString *imageName = (__bridge NSString *)refCon;
//    return [UIImage imageNamed:imageName].size.height;
    return 40;
}

CGFloat RunDelegateGetDescentCallback(void *refCon){
    return 0;
}

CGFloat RunDelegateGetWidthCallback(void *refCon){
//    NSString *imageName = (__bridge NSString *)refCon;
//    return [UIImage imageNamed:imageName].size.width;
    return 80;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //这四行代码只是简单测试drawRect中context的坐标系

    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形的变换矩阵为不做图形变换
    CGContextScaleCTM(context, 1.0, -1.0);//缩放方法，x轴缩放系数为1，则不变，y轴缩放系数为-1，则相当于以x轴为轴旋转180度
    CGContextTranslateCTM(context, 0, -self.bounds.size.height);//平移方法，将画布向上平移一个屏幕高
    
    
    
    originStr = @"测试富文本显示";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"测试富文本显示"];
    
    //为所有文本设置字体
    //[attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, [attributedString length])]; // 6.0+
    UIFont *font = [UIFont systemFontOfSize:24];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, [attributedString length])];
    
    //将“测试”两字字体颜色设置为蓝色
    //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 2)]; //6.0+
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:NSMakeRange(0, 2)];
    
    //将“富文本”三个字字体颜色设置为红色
    //[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, 3)]; //6.0+
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(2, 3)];
    
    
    //为图片设置CTRunDelegate,delegate决定留给图片的空间大小
    NSString *taobaoImageName = @"test.png";
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = RunDelegateDeallocCallback;
    imageCallbacks.getAscent = RunDelegateGetAscentCallback;
    imageCallbacks.getDescent = RunDelegateGetDescentCallback;
    imageCallbacks.getWidth = RunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks, (__bridge void * _Nullable)(taobaoImageName));
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@" "];//空格用于给图片留位置
    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
    CFRelease(runDelegate);
    
    [imageAttributedString addAttribute:@"imageName" value:taobaoImageName range:NSMakeRange(0, 1)];
    
    [attributedString insertAttributedString:imageAttributedString atIndex:1];
    
    CTFramesetterRef ctFramesetter = CTFramesetterCreateWithAttributedString((CFMutableAttributedStringRef)attributedString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
    CGPathAddRect(path, NULL, bounds);
    
    kFrameRef = CTFramesetterCreateFrame(ctFramesetter,CFRangeMake(0, 0), path, NULL);
    CTFrameDraw(kFrameRef, context);
    
    CFArrayRef lines = CTFrameGetLines(kFrameRef);
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(kFrameRef, CFRangeMake(0, 0), lineOrigins);
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            CGFloat runAscent;
            CGFloat runDescent;
            CGPoint lineOrigin = lineOrigins[i];
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            CGRect runRect;
            runRect.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
            
            runRect=CGRectMake(lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL), lineOrigin.y - runDescent, runRect.size.width, runAscent + runDescent);
            
            NSString *imageName = [attributes objectForKey:@"imageName"];
            //图片渲染逻辑
            if (imageName) {
                UIImage *image = [UIImage imageNamed:imageName];
                if (image) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = CGSizeMake(40, 40);
                    imageDrawRect.origin.x = runRect.origin.x + lineOrigin.x;
                    imageDrawRect.origin.y = lineOrigin.y;
                    [image drawInRect:imageDrawRect];
//                    CGContextDrawImage(context, imageDrawRect, image.CGImage);

                    
                }
            }
        }
    }
    
//    CFRelease(kFrameRef);
    CFRelease(path);
    CFRelease(ctFramesetter);
}

//点击事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //获取UITouch对象
    UITouch *touch = [touches anyObject];
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];
    NSLog(@"touch:%@",NSStringFromCGPoint(location));
    //获取每一行
    CFArrayRef lines = CTFrameGetLines(kFrameRef);
    CGPoint origins[CFArrayGetCount(lines)];
    //获取每行的原点坐标
    CTFrameGetLineOrigins(kFrameRef, CFRangeMake(0, 0), origins);
    CTLineRef line = NULL;
    CGPoint lineOrigin = CGPointZero;
    for (int i= 0; i < CFArrayGetCount(lines); i++)
    {
        CGPoint origin = origins[i];
        CGPathRef path = CTFrameGetPath(kFrameRef);
        //获取整个CTFrame的大小
        CGRect rect = CGPathGetBoundingBox(path);
//        NSLog(@"origin:%@",NSStringFromCGPoint(origin));
//        NSLog(@"rect:%@",NSStringFromCGRect(rect));
        
        //坐标转换，把每行的原点坐标转换为uiview的坐标体系
        CGFloat y = rect.origin.y + rect.size.height - origin.y;
//        NSLog(@"y:%f",y);
        //判断点击的位置处于那一行范围内
        if ((location.y <= y) && (location.x >= origin.x))
        {
            line = CFArrayGetValueAtIndex(lines, i);
            lineOrigin = origin;
            break;
        }
    }
    
    location.x -= lineOrigin.x;
    //获取点击位置所处的字符位置，就是相当于点击了第几个字符
    CFIndex index = CTLineGetStringIndexForPosition(line, location);
    NSLog(@"index:%ld",index);
    //判断点击的字符是否在需要处理点击事件的字符串范围内，这里是hard code了需要触发事件的字符串范围
    if (index>=1&&index<=10) {
//        NSLog(@"%@",[originStr substringWithRange:NSMakeRange(0, 6)]);
    }
    
}


@end

@interface CoreTextViewController ()

@end

@implementation CoreTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    TestView *test = [[TestView alloc]initWithFrame:CGRectMake(30, 100, 300, 300)];
    test.backgroundColor = [UIColor grayColor];
    [self.view addSubview:test];
    
    TestView1 *test1 = [[TestView1 alloc]initWithFrame:CGRectMake(30, 200, 300, 300)];
    test1.backgroundColor = [UIColor grayColor];
    test1.layer.masksToBounds = YES;
//    [self.view addSubview:test1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
