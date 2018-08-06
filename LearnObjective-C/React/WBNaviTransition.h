//
//  WBNaviTransition.h
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/6.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WBPresentOneTransitionType) {
    WBPresentOneTransitionTypePresent = 0,
    WBPresentOneTransitionTypeDismiss
};

@interface WBNaviTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) WBPresentOneTransitionType type;
+ (instancetype)transitionWithTransitionType:(WBPresentOneTransitionType)type;
- (instancetype)initWithTransitionType:(WBPresentOneTransitionType)type;


@end
