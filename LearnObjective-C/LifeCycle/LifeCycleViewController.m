//
//  LifeCycleViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2021/10/9.
//  Copyright © 2021 Dwight. All rights reserved.
//

#import "LifeCycleViewController.h"

#define DLog NSLog(@"%@",NSStringFromSelector(_cmd));
@interface SingleViewController : UIViewController
@end

@implementation SingleViewController

-(void)loadView
{
    [super loadView];
    DLog
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    DLog
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DLog
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    DLog
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    DLog
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DLog
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    DLog
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    DLog
}

- (void)dealloc
{
    DLog
}

@end

static id e;

@implementation LifeCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *a = [[UIButton alloc] initWithFrame:CGRectMake(20, 90, 90, 50)];
    [a setTitle:@"打开视图" forState:UIControlStateNormal];
    [a setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [a addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:a];
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(140, 90, 90, 50)];
    [b setTitle:@"关闭视图" forState:UIControlStateNormal];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}

- (void)click
{
    SingleViewController *vc = [[SingleViewController alloc] init];
    vc.view.frame = CGRectMake(0, 150, 100, 100);
    e = vc;
    [self.view addSubview:vc.view];
}

- (void)close
{
    [self.view.subviews[2] removeFromSuperview];
}
@end


