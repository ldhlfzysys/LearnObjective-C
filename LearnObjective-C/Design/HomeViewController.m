//
//  HomeViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/9/8.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "HomeViewController.h"
#import "ADBannaer.h"

@implementation HomeViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _headerContext = [[HeaderContext alloc]initWithDelegate:self];
        [_headerContext registerView:[ADBannaer class]];
        
        [self.view addSubview:self.headerContext.headerView];
        self.tableView.tableHeaderView = self.headerContext.headerView;
        
    }
    return self;
}

//VC在执行下拉刷新等其他操作，在这里通知HeaderContext要全更新内部的子view
- (void)refresh
{
    [self.headerContext update];
}

//HeaderContext发生更新后，在这里通知VC要更新高度
- (void)updateHeight:(CGFloat)height
{
    //headerView如果是作为table的HeaderView，reloadData
    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:self.headerContext.headerView];
    [self.tableView endUpdates];

}


@end
