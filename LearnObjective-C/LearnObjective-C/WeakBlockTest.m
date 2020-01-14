//
//  WeakBlockTest.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2019/12/3.
//  Copyright © 2019 Dwight. All rights reserved.
//

#import "WeakBlockTest.h"

typedef void(^MyBlock)(void);

@interface MyObject ()
@property(nonatomic,weak)MyObject *a;

@end

@implementation MyObject

- (void)testEnter
{
    self.a = [[MyObject alloc] init];
    _a = [[MyObject alloc] init];
}

@end
