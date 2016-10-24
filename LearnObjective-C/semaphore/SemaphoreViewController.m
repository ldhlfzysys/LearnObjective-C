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
    UIButton *signalButton;
}

@end

@implementation SemaphoreViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        signalButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 150, 100, 50)];
        signalButton.backgroundColor = [UIColor blueColor];
        [signalButton addTarget:self action:@selector(releaseSignal) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:signalButton];
        
        signal = dispatch_semaphore_create(1);
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            while (YES) {
                dispatch_semaphore_wait(signal, 500000*NSEC_PER_SEC);
                NSLog(@"click");
                
            }
        });
    }
    return self;
}

- (void)releaseSignal
{
    dispatch_semaphore_signal(signal);
}

@end
