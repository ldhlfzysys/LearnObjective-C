//
//  AsyncDrawViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/8/4.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "AsyncDrawViewController.h"

@implementation TestAsyncDrawView


-(BOOL)drawInRect:(CGRect)rect Context:(CGContextRef)context
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"异步来画这句话"];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, string.length)];
    [string drawInRect:CGRectMake(0, 0, 100, 50)];
    sleep(2);
    
    return YES;
}

@end

@implementation AsyncDrawViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    TestAsyncDrawView *view = [[TestAsyncDrawView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    view.backgroundColor = [UIColor grayColor];
    [cell addSubview:view];
    return cell;
}

@end
