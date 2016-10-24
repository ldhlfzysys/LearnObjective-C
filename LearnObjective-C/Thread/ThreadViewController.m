//
//  ThreadViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/8/9.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "ThreadViewController.h"

@implementation ThreadViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"1"); // 任务1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSLog(@"2"); // 任务2
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"3"); // 任务2
        });
    });
    NSLog(@"4"); // 任务3

}
@end
