//
//  HeaderContext.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/9/8.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "HeaderContext.h"
#import "ADBannaer.h"

@interface HeaderContext()
{
    CGFloat currentHeaderHeight;
    NSDictionary *subViews;
}

@end

@implementation HeaderContext

- (instancetype)initWithDelegate:(id)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}



//VC通知自己需要更新视图,询问所有子视图
- (void)update
{
    self.headerView.frame = CGRectMake(0, 0, 0, currentHeaderHeight);
    [self.delegate updateHeight:currentHeaderHeight];
}

- (void)registerView:(Class)className
{
    
}


@end

