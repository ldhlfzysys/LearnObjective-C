//
//  JSContextViewController.m
//  
//
//  Created by donghuan1 on 2018/12/3.
//

#import "JSContextViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSContextViewController ()
{
    JSContext *pageContext;
    JSContext *serviceContext;
}
@end

@implementation JSContextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    [b setBackgroundColor:[UIColor greenColor]];
    [b addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    [self initPage];
    [self initService];
}

- (void)click
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    JSValue *v = [pageContext evaluateScript:@"click"];
    JSValue *r =[v callWithArguments:nil];
    NSLog(@"%@",r);
}

- (void)initPage
{
    __block JSContextViewController *weakSelf = self;
    pageContext = [[JSContext alloc] init];
    pageContext[@"getData"] = ^(NSString *methodName){
        JSValue *v = [weakSelf->serviceContext evaluateScript:methodName];
        JSValue *r = [v callWithArguments:nil];
        return r;
        
    };
    NSString *pagejs = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"page" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
    [pageContext evaluateScript:pagejs];
}

- (void)initService
{
    serviceContext[@"setData"] = ^(NSString *methodName){
        return [pageContext evaluateScript:methodName];
    };
    serviceContext = [[JSContext alloc] init];
    NSString *servicejs = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"service" ofType:@"js"] encoding:NSUTF8StringEncoding error:nil];
    [serviceContext evaluateScript:servicejs];
}

@end
