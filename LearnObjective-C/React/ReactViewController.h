//
//  ReactViewController.h
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/3.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPresent.h"

@protocol WBPresentedOneControllerDelegate <NSObject>

- (void)presentedOneControllerPressedDissmiss;
- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent;

@end

@interface ReactViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic, assign) id<WBPresentedOneControllerDelegate> delegate;
@end
