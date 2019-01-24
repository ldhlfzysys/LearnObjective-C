//
//  NavigatorViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/12/12.
//  Copyright © 2018 Dwight. All rights reserved.
//

#import "NavigatorViewController.h"

@implementation WBXLaunchViewController
- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor yellowColor];
}
@end

@interface Module : NSObject
@end
@implementation Module

+ (NSString *)test{
    return NSStringFromSelector(@selector(test2:));
}

- (NSString *)test2:(NSString *)x{
    NSLog(@"aaa");
    return @"a";
}

@end

@interface NavigatorViewController ()

@end

@implementation NavigatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    Class currentClass = [Module class];
    SEL selector = @selector(test);
    IMP a = [Module methodForSelector:@selector(test)];
    NSString *method = nil;
    NSString *method2 = nil;
    method = ((NSString* (*)(id, SEL))[currentClass methodForSelector:selector])(currentClass, selector);
    method2 = ((NSString* (*)())[currentClass methodForSelector:selector])();
    NSLog(@"%@--%@",method,method2);
}


@end
