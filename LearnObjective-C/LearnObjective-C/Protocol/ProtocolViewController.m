//
//  ProtocolViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/11/9.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "ProtocolViewController.h"
#import "MyObject.h"
@protocol protocol1 <NSObject>

- (void)method1;

@end

@protocol protocol2 <NSObject>

- (void)method2;

@end

@interface ProtocolViewController ()
@property (nonatomic,strong)MyObject<protocol1> *o1;
@property (nonatomic,strong)MyObject<protocol2> *o2;
@end

@implementation ProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
