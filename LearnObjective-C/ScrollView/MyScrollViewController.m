//
//  MyScrollViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/10/13.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "MyScrollViewController.h"
#import "NSPredicateViewController.h"



@interface MyScrollViewController ()

@end

@implementation MyScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:150  inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - scrollviewdelegate

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");
}

//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
//{
//    NSLog(@"scrollViewWillBeginDragging-decelerate-%@",scrollView.isDecelerating?@"yes":@"no");
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//{
//    NSLog(@"scrollViewDidEndDragging-decelerate-%@",decelerate?@"yes":@"no");
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
//{
//    NSLog(@"scrollViewWillBeginDecelerating-decelerate-%@",scrollView.isDecelerating?@"yes":@"no");
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
//{
//    NSLog(@"scrollViewDidEndDecelerating-decelerate-%@",scrollView.isDecelerating?@"yes":@"no");
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
//{
//    NSLog(@"scrollViewDidEndScrollingAnimation");
//}
//
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidScrollToTop");
//}

#pragma mark - tableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 300;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"display---%ld",(long)indexPath.row);
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"enddisplay---%ld",(long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyScrollViewController *test = [[MyScrollViewController alloc]init];
    [self.navigationController pushViewController:test animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    NSString *a = @"LearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorderLearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorderLearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorderLearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorderLearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorderLearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorderLearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorderLearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorderLearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorderLearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorderLearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorderLearnObjective-C(45807,0x103700580) malloc: recording malloc and VM allocation stacks to disk using standard recorder";
    
    for (int i = 0 ; i < 1000; i++) {
        [a boundingRectWithSize:CGSizeMake(100, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{} context:nil];
    }
    
    
    return cell;
}

@end
