//
//  MainViewController.m
//  LearnObjective-C
//
//  Created by liudonghuan on 16/6/30.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController
-(instancetype)init
{
    if (self = [super init]) {
        mControllers = [NSArray arrayWithObjects:@"NSPredicate", nil];
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"LearnObjective-C";
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mControllers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = [mControllers objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString *viewControllerName = [[mControllers objectAtIndex:indexPath.row] mutableCopy];
    [viewControllerName insertString:@"Get" atIndex:0];
    [viewControllerName appendString:@"ViewController"];
    UIViewController *sessionVC = [[NSClassFromString(viewControllerName) alloc]init];
    [sessionVC setTitle:viewControllerName];
    [self.navigationController pushViewController:sessionVC animated:YES];
}
@end
