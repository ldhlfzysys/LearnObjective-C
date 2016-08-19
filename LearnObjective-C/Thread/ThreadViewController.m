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
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2"); // 任务2
    });
    NSLog(@"3"); // 任务3
    
}
@end
