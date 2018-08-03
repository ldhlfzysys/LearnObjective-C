//
//  NSStringViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/2.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import "NSStringViewController.h"

@interface NSStringViewController ()

@end

@implementation NSStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableString *mutableStr = [NSMutableString string];
    NSString *immutable = nil;
#define _OBJC_TAG_MASK (1UL<<63)
    char c = 'a';
    do {
        [mutableStr appendFormat:@"%c", c++];
        immutable = [mutableStr copy];
        NSLog(@"%p %@ %@", immutable, immutable, immutable.class);
    }while(((uintptr_t)immutable & _OBJC_TAG_MASK) == _OBJC_TAG_MASK);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
