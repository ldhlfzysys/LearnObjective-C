//
//  WKWebViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2019/8/20.
//  Copyright © 2019 Dwight. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
@interface WKWebViewController ()<UIScrollViewDelegate>
{
    WKWebView *webView;
    WKWebViewConfiguration *config;
}
@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    config = [[WKWebViewConfiguration alloc] init];
    webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.235.24.23"]]];
    webView.scrollView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"a");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
