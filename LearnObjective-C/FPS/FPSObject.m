//
//  FPSObject.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/8/19.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "FPSObject.h"
#import <QuartzCore/QuartzCore.h>



@interface FPSObject()
{
    //定时器
    CADisplayLink *linkTimer;
    
    //用于计算平均值的数组
    CFTimeInterval *fpsBuffer;
    //用于计算平均值的数组大小
    int fpsBufferSize;
    
    //计算一次fps的间隔
    int refreshSeconds;
    //计算一次fps间隔用的临时变量
    int refreshCounter;
    
    //用于记录上一次的时间戳
    CFTimeInterval lastTimeStamp;
    
    //
    NSInteger currentSeconds;
    NSInteger currentCount;
}
@end

@implementation FPSObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        linkTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        
        fpsBufferSize = 60;
        fpsBuffer = malloc(sizeof(CFTimeInterval)*fpsBufferSize);
        fpsBufferSize -= 1;
        refreshSeconds = 30;
        refreshCounter = 0;
        
        lastTimeStamp = CFAbsoluteTimeGetCurrent();
        //添加到当前runloop中
        [linkTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
    }
    return self;
}

/**
 * @brief 带字符串参数的方法.

 */
- (void)update:(CADisplayLink *)timer
{
//    for (int i = fpsBufferSize - 1; i > 0; i--) {
//        fpsBuffer[i] = fpsBuffer[i-1];
//    }
//    fpsBuffer[0] = timer.timestamp - lastTimeStamp;
//    lastTimeStamp = timer.timestamp;
//    
//    double maxTime = 0;
//    double averTimeSum = 0;
//    double averTime = 0;
//    
//    for (int i = 0; i < fpsBufferSize; i++)
//    {
//        maxTime = MAX(fpsBuffer[i],maxTime);
//        averTimeSum += fpsBuffer[i];
//    }
//    
//    averTime = averTimeSum / fpsBufferSize;
//    
//    refreshCounter ++;
//
//    if (refreshCounter%refreshSeconds == 0) {
//        refreshCounter = 0;
//        NSLog(@"current:%.1f---aver:%.1f",roundf(1.f/maxTime),round(1.f/averTime));
//        
//    }

    //按进入次数算
//    CFAbsoluteTime time1 = CFAbsoluteTimeGetCurrent();
//    
    NSInteger intStamp = timer.timestamp;
    if (intStamp == currentSeconds)
    {
        currentCount ++;
    }
    else
    {
        //第一次进入没记，所有最后结果+1
        NSLog(@"%ld",currentCount+1);
        currentCount = 0;
        currentSeconds = timer.timestamp;
    }
//
    
//    CFAbsoluteTime time2 = CFAbsoluteTimeGetCurrent();
//    NSLog(@"%f--%f",time1,time2);
    
    
    
    
}

@end
