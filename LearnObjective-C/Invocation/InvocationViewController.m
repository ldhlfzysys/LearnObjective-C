//
//  InvocationViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/12/12.
//  Copyright © 2018 Dwight. All rights reserved.
//

#import "InvocationViewController.h"

typedef void(^block1)(BOOL success,NSString *value);

@protocol TestProtocol <NSObject>

-(void)test;

@end

typedef struct example{
    id anObject;
    int anInt;
};

@interface InvocationViewController ()

@end

@implementation InvocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSMethodSignature *s1 = [self methodSignatureForSelector:@selector(boolMethod:)];
    NSMethodSignature *s2 = [self methodSignatureForSelector:@selector(stringMethod:)];
    NSMethodSignature *s3 = [self methodSignatureForSelector:@selector(block1Method)];
    NSMethodSignature *s4 = [self methodSignatureForSelector:@selector(objectMethod)];
    NSMethodSignature *s5 = [self methodSignatureForSelector:@selector(protocolMethod)];
    NSInvocation *v5 = [NSInvocation invocationWithMethodSignature:s5];
    id test;
    [v5 getReturnValue:&test];
    NSLog(@"aa");
}

- (id<TestProtocol>)protocolMethod
{
    return nil;
}

- (InvocationViewController *)objectMethod
{
    return nil;
}

- (BOOL)boolMethod:(BOOL)is
{
    return is;
}

- (NSString *)stringMethod:(NSString *)string
{
    return string;
}

- (block1)block1Method
{
    block1 b = ^(BOOL success,NSString *value){
        NSLog(@"block1--%@",value);
        
    };
    return b;
}


@end
