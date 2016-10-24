//
//  HomeViewController.h
//  LearnObjective-C
//
//  Created by donghuan1 on 16/9/8.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderContext.h"

@interface HomeViewController : UITableViewController<HeaderContext>

@property (nonatomic,strong)HeaderContext *headerContext;

@end

