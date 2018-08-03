//
//  ExternTest.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/7/3.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import "ExternTest.h"

@interface ExternTest()

@end

@implementation ExternTest

- (void)test;
{
    NSLog(@"extern test");
}
+ (void)mtest;
{
    NSLog(@"extern mtest");
}
@end

@implementation ExternTestSon

- (void)test;
{
    [super test];
}
+ (void)mtest;
{
    [super mtest];
}
@end


