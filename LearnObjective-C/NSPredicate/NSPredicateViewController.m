//
//  GetNSPredicateViewController.m
//  LearnObjective-C
//
//  Created by liudonghuan on 16/6/30.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "NSPredicateViewController.h"

@implementation NSPredicateViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
     NSString *schemeStr2 = [@"立刻去微博查看~跳转地址：sinaweibo://pageinfo?containerid=10080892c0e2324536a73dc4de98931f69c675" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *a = [schemeStr2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@/n%@",schemeStr2,a);
    
}

- (void)officialDocuments
{
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"" argumentArray:nil];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@""];
    
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"" arguments:nil];
    
    NSPredicate *predicate4 = [NSPredicate predicateWithValue:YES];
    

    
}


@end
