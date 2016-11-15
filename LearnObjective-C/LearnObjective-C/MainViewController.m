//
//  MainViewController.m
//  LearnObjective-C
//
//  Created by liudonghuan on 16/6/30.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "MainViewController.h"
#import "FPSObject.h"
#import "testModel.h"

#include <libkern/OSAtomic.h>
#include <execinfo.h>


@interface MainViewController()
{
//    double test1;
//    double test2;
//    double test3;
}
@property (nonatomic,assign)id obj2;
@property (nonatomic,strong) NSMutableArray *arr;
@end

@implementation MainViewController
-(instancetype)init
{
    if (self = [super init]) {
        mControllers = [NSArray arrayWithObjects:@"NSPredicate",@"Draw",@"RunLoop",@"AsyncDraw",@"Thread",@"Semaphore",@"FeedPerforms",@"CoreText",@"MyScroll",@"Protocol", nil];
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"LearnObjective-C";
        
        
        double time1 = CFAbsoluteTimeGetCurrent();
        
        for (int i = 0; i < 10*100*100*1000; i ++) {
            NSNumber *test1 = @(123.1231231);
           NSNumber *test2 = @(333.4563456);
           double test3 = [test2 doubleValue] - [test1 doubleValue];
        }
        
        double time2 = CFAbsoluteTimeGetCurrent();
        
        NSLog(@"%f",time2-time1);

        

        
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
//    [viewControllerName insertString:@"Get" atIndex:0];
    [viewControllerName appendString:@"ViewController"];
    UIViewController *sessionVC = [[NSClassFromString(viewControllerName) alloc]init];
    [sessionVC setTitle:viewControllerName];
    [self.navigationController pushViewController:sessionVC animated:YES];

//    for (int i = 0; i < 100; i ++) {
//        NSDictionary *dict3 = [[NSDictionary alloc]initWithObjectsAndKeys:@"123123",@"cddddfadsfasdf",
//                               @"3123123",@"asdcasdcasdcasdc",
//                               @"da123as",@"asdcasdcxacdad",
//                               @"123aese",@"casdcxacds",
//                               @"12awe",@"casdcaxacd",
//                               @"123aedqwe",@"asdcaxcadc",nil];
//        [_arr addObject:dict3];
//    }
}
@end
