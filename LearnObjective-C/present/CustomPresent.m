//
//  CustomPresent.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/6.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import "CustomPresent.h"

@interface CustomPresent ()

@property (nonatomic, weak) UIViewController *vc;
/**手势方向*/
@property (nonatomic, assign) WBInteractiveTransitionGestureDirection direction;
/**手势类型*/
@property (nonatomic, assign) WBInteractiveTransitionType type;

@end

@implementation CustomPresent

+ (instancetype)interactiveTransitionWithTransitionType:(WBInteractiveTransitionType)type GestureDirection:(WBInteractiveTransitionGestureDirection)direction{
    return [[self alloc] initWithTransitionType:type GestureDirection:direction];
}

- (instancetype)initWithTransitionType:(WBInteractiveTransitionType)type GestureDirection:(WBInteractiveTransitionGestureDirection)direction{
    self = [super init];
    if (self) {
        _direction = direction;
        _type = type;
    }
    return self;
}

- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}

/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    //手势百分比
    CGFloat persent = 0;
    switch (_direction) {
        case WBInteractiveTransitionGestureDirectionLeft:{
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case WBInteractiveTransitionGestureDirectionRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case WBInteractiveTransitionGestureDirectionUp:{
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
        case WBInteractiveTransitionGestureDirectionDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //手势开始的时候标记手势状态，并开始相应的事件
            self.interation = YES;
            [self startGesture];
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self updateInteractiveTransition:persent];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            self.interation = NO;
            if (persent > 0.5) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

- (void)startGesture{
    switch (_type) {
        case WBInteractiveTransitionTypePresent:{
            if (_presentConifg) {
                _presentConifg();
            }
        }
            break;
            
        case WBInteractiveTransitionTypeDismiss:
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        case WBInteractiveTransitionTypePush:{
            if (_pushConifg) {
                _pushConifg();
            }
        }
            break;
        case WBInteractiveTransitionTypePop:
            [_vc.navigationController popViewControllerAnimated:YES];
            break;
    }
}
@end
