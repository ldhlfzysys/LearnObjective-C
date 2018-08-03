//
//  ExternTest.h
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/7/3.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ExternTest : NSObject
- (void)test;
+ (void)mtest;
@end

@interface ExternTestSon : ExternTest
- (void)test;
+ (void)mtest;
@end
