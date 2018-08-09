//
//  OperationViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/6.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import "OperationViewController.h"
#import "MyOperation.h"
#import "MyRequest.h"

@interface OperationViewController ()<MyOperationDelegate>
{
    NSOperationQueue *_loadQueue;
}
@end

@implementation OperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loadQueue = [[NSOperationQueue alloc] init];
    _loadQueue.maxConcurrentOperationCount = 5;
    
    
    for (int i = 0; i<10; i++) {
        [self addRequest:[[MyRequest alloc]initWithUrl:[NSString stringWithFormat:@"%d",i]]];
    }
    
    //取消队列
    for (int i = 0; i<10; i++) {
        MyOperation *op = [self operationForUrl:[NSString stringWithFormat:@"%d",i]];
        [op cancel];
    }
    
    for (int i = 0; i<10; i++) {
        [self addRequest:[[MyRequest alloc]initWithUrl:[NSString stringWithFormat:@"%d",i]]];
    }
}

- (void)loadCompleted:(MyOperation *)operarion url:(NSString *)url
{
    NSLog(@"%@",url);
    NSLog(@"%@",[NSThread currentThread]);
}

- (void)addRequest:(MyRequest *)request
{
    NSString *url = request.url;
    MyOperation *op = [self operationForUrl:url];
    if (!op) {
        op = [[MyOperation alloc] initWithUrl:url];
        op.delegate = self;
        [_loadQueue addOperation:op];
    }
    
    
}


- (MyOperation *)operationForUrl:(NSString *)url{
    for (MyOperation *op in _loadQueue.operations) {
        if ([op.url isEqualToString:url]) {
            return op;
        }
    }
    return nil;
}

@end
