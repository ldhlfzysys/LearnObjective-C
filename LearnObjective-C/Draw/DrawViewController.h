//
//  DrawViewController.h
//  LearnObjective-C
//
//  Created by liudonghuan on 16/7/22.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, MYTESTOPTION) {
    
    MYTESTOPTIONOne = 1<<0,
    MYTESTOPTIONTwo = 1<<1,
    MYTESTOPTIONThree = 1<<2,
    MYTESTOPTIONFour = 1<<3,
};

@interface DrawView : UIView


@end

@interface DrawViewController : UIViewController

@end
