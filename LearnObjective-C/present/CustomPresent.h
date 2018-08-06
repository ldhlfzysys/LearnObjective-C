//
//  CustomPresent.h
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/6.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^GestureConifg)();

typedef NS_ENUM(NSUInteger, WBInteractiveTransitionGestureDirection) {//手势的方向
    WBInteractiveTransitionGestureDirectionLeft = 0,
    WBInteractiveTransitionGestureDirectionRight,
    WBInteractiveTransitionGestureDirectionUp,
    WBInteractiveTransitionGestureDirectionDown
};

typedef NS_ENUM(NSUInteger, WBInteractiveTransitionType) {//手势控制哪种转场
    WBInteractiveTransitionTypePresent = 0,
    WBInteractiveTransitionTypeDismiss,
    WBInteractiveTransitionTypePush,
    WBInteractiveTransitionTypePop,
};

@interface CustomPresent : UIPercentDrivenInteractiveTransition
/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;
/**促发手势present的时候的config，config中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg presentConifg;
/**促发手势push的时候的config，config中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg pushConifg;

//初始化方法

+ (instancetype)interactiveTransitionWithTransitionType:(WBInteractiveTransitionType)type GestureDirection:(WBInteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(WBInteractiveTransitionType)type GestureDirection:(WBInteractiveTransitionGestureDirection)direction;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;
@end
