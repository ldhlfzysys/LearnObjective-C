//
//  SemaphoreViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/9/21.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "SemaphoreViewController.h"

@interface SemaphoreViewController()
{
    dispatch_semaphore_t signal;
    
}

@end

@implementation SemaphoreViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        
        signal = dispatch_semaphore_create(1);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            while (1) {
                dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
                [self test:@"a"];
                dispatch_semaphore_signal(signal);
            }
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            while (1) {
                dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
                [self test:@"a"];
                dispatch_semaphore_signal(signal);
            }
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            while (1) {
                dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
                [self test:@"a"];
                dispatch_semaphore_signal(signal);
            }
        });

    }
    return self;
}

- (void)test:(NSString *)str
{
    sleep(2);
    NSLog(@"%p",&str);
}

- (void)releaseSignal
{
    dispatch_semaphore_signal(signal);
}

@end
