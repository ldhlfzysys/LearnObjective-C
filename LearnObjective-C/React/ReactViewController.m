//
//  ReactViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/3.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import "ReactViewController.h"
#import <React/RCTView.h>
#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>
#import "WBNaviTransition.h"

@interface ReactViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) CustomPresent *interactiveDismiss;
@property (nonatomic, strong) CustomPresent *interactivePush;
@end

@implementation ReactViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)dismiss{
    if (_delegate && [_delegate respondsToSelector:@selector(presentedOneControllerPressedDissmiss)]) {
        [_delegate presentedOneControllerPressedDissmiss];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.interactiveDismiss = [CustomPresent interactiveTransitionWithTransitionType:WBInteractiveTransitionTypeDismiss GestureDirection:WBInteractiveTransitionGestureDirectionRight];
    [self.interactiveDismiss addPanGestureForViewController:self];
    
#if TARGET_IPHONE_SIMULATOR
    [[RCTBundleURLProvider sharedSettings] setJsLocation:@"localhost"];
#else
    [[RCTBundleURLProvider sharedSettings] setDefaults];
#endif
    NSURL *jsCodeLocation;
    jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index.ios" fallbackResource:nil];
    
    UIView *baseView = [[UIView alloc]initWithFrame:self.view.frame];
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation
                                                        moduleName:@"MyReactNativeApp"
                                                 initialProperties:nil
                                                     launchOptions:nil];
    rootView.frame = baseView.bounds;
    rootView.backgroundColor = [UIColor whiteColor];
    [baseView addSubview:rootView];

    
    
    
    [self.view addSubview:baseView];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [WBNaviTransition transitionWithTransitionType:WBPresentOneTransitionTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [WBNaviTransition transitionWithTransitionType:WBPresentOneTransitionTypeDismiss];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return _interactiveDismiss.interation ? _interactiveDismiss : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    CustomPresent *interactivePresent = [_delegate interactiveTransitionForPresent];
    return interactivePresent.interation ? interactivePresent : nil;
}


@end
