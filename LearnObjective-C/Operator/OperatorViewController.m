//
//  OperatorViewController.m
//  LearnObjective-C
//
//  Created by liudonghuan on 16/7/27.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "OperatorViewController.h"


typedef NS_OPTIONS(NSUInteger, OperatorTest) {
    OperatorTestOne   = 1 << 0,
    OperatorTestTwo   = 1 << 1,
    OperatorTestThree = 1 << 2,
    OperatorTestFour  = 1 << 3,
    OperatorTestFive  = 1 << 4,
    OperatorTestSix   = 1 << 5,
    OperatorTestSeven = 1 << 6,
};

@implementation OperatorViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    OperatorTest operator1 = OperatorTestOne;
    OperatorTest operator2 = OperatorTestTwo;

//    NSLog(@"%lu--%lu",(unsigned long)operator1,(unsigned long)operator2);
//    
//    NSLog(@"%d",! operator1);
//    NSLog(@"%lu",(unsigned long)~ operator1);
//    
//    NSLog(@"%d",! operator2);
//    NSLog(@"%lu",(unsigned long)~ operator2);
//    
//    NSLog(@"%d",! (operator1 & operator2))
//    
//    ;
//    NSLog(@"%lu",! operator1 & operator2);
//    
    NSLog(@"%lu",~ (operator1 & operator2));
    NSLog(@"%lu",~ operator1 & operator2);
    
    NSLog(@"%lu", operator1 & operator2);
    if (operator1 & operator2) {
        NSLog(@"yes1");
    }
    
    if (! operator1 & operator2) {
        NSLog(@"yes1");
    }
    
    
    if (~ operator1 & operator2) {
        NSLog(@"yes2");
    }

}

/*
 2016-07-27 14:05:24.480 LearnObjective-C[4789:4133700] 1--2
 2016-07-27 14:05:24.480 LearnObjective-C[4789:4133700] 0
 2016-07-27 14:05:24.481 LearnObjective-C[4789:4133700] 18446744073709551614
 2016-07-27 14:05:24.481 LearnObjective-C[4789:4133700] 0
 2016-07-27 14:05:24.481 LearnObjective-C[4789:4133700] 18446744073709551613
 2016-07-27 14:05:24.481 LearnObjective-C[4789:4133700] 1
 2016-07-27 14:05:24.481 LearnObjective-C[4789:4133700] 0
 2016-07-27 14:05:24.481 LearnObjective-C[4789:4133700] 18446744073709551615
 2016-07-27 14:05:24.482 LearnObjective-C[4789:4133700] 2
 2016-07-27 14:05:24.482 LearnObjective-C[4789:4133700] yes2
 */

@end

