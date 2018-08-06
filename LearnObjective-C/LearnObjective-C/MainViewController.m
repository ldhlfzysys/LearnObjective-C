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
#import "ExternTest.h"
#import <objc/runtime.h>
#import "WBNaviTransition.h"
#import "ReactViewController.h"
#import "CustomPresent.h"

#define kWBUserDefaultsKey  @"kWBUserDefaultsKey"
extern int ctest();
static dispatch_queue_t wb_user_defaults_queue;
static dispatch_queue_t test_queue;

@interface MainViewController()<WBPresentedOneControllerDelegate>{
    
}
@property (nonatomic, strong) CustomPresent *interactivePush;

@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic,assign) NSInteger testcount;
@property (nonatomic,strong)NSTimer *timer;
@end

static dispatch_queue_t mqueue;

@implementation MainViewController

@synthesize testcount = _testcount;

-(void)viewDidLoad
{
    [super viewDidLoad];
    _interactivePush = [CustomPresent interactiveTransitionWithTransitionType:WBInteractiveTransitionTypePresent GestureDirection:WBInteractiveTransitionGestureDirectionUp];
    typeof(self)weakSelf = self;
    _interactivePush.presentConifg = ^(){
//        [weakSelf present];
    };
    [_interactivePush addPanGestureForViewController:self.navigationController];
}


-(instancetype)init
{
    if (self = [super init]) {
        mControllers = [NSArray arrayWithObjects:@"NSPredicate",@"Draw",@"RunLoop",@"AsyncDraw",@"Thread",@"Semaphore",@"FeedPerforms",@"CoreText",@"MyScroll",@"Protocol",@"JSCore",@"NSString",@"React", nil];
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"LearnObjective-C";
    
        
    }
    return self;
}
- (void)test{
    NSLog(@"aaaaa");
}


//动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([NSStringFromSelector(sel) isEqualToString:@"test"]) {
        NSLog(@"%@ not found",NSStringFromSelector(sel));
        return NO;
    }else{
        return [super resolveInstanceMethod:sel];
    }
    
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    if ([NSStringFromSelector(sel) isEqualToString:@"test"]) {
        NSLog(@"%@ not found",NSStringFromSelector(sel));
        return NO;
    }else{
        return [super resolveInstanceMethod:sel];
    }
}

//备用接收者
- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"%@ not found",NSStringFromSelector(aSelector));
    return nil;
}

+ (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"%@ not found",NSStringFromSelector(aSelector));
    return nil;
}

//完整消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"test"]) {
        NSMethodSignature *sign = [NSMethodSignature signatureWithObjCTypes:"v@:"];
        return sign;//签名，进入forwardInvocation
    }
    
    return [super methodSignatureForSelector:aSelector];
}
+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"test"]) {
        NSMethodSignature *sign = [NSMethodSignature signatureWithObjCTypes:"v#:"];
        return sign;//签名，进入forwardInvocation
    }
    
    return [super methodSignatureForSelector:aSelector];
}

//完整消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    
    ExternTest *p = [ExternTest new];
    if([p respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:p];
    }
    else {
        [self doesNotRecognizeSelector:sel];
    }
    
}
+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    
    ExternTest *p = [ExternTest new];
    if([p respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:p];
    }
    else {
        [self doesNotRecognizeSelector:sel];
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%f",scrollView.contentOffset.y);
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
//    NSLog(@"%ld",self.testcount);
    NSMutableString *viewControllerName = [[mControllers objectAtIndex:indexPath.row] mutableCopy];
//    [viewControllerName insertString:@"Get" atIndex:0];
    [viewControllerName appendString:@"ViewController"];
    if ([viewControllerName isEqualToString:@"ReactViewController"]) {
        [self present];
    }else{
        UIViewController *sessionVC = [[NSClassFromString(viewControllerName) alloc]init];
        [sessionVC setTitle:viewControllerName];
        [self.navigationController pushViewController:sessionVC animated:YES];
    }
    

}

- (void)presentedOneControllerPressedDissmiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent{
    return _interactivePush;
}

- (void)present{
    ReactViewController *presentedVC = [ReactViewController new];
    presentedVC.delegate = self;
    [self presentViewController:presentedVC animated:YES completion:nil];
}
@end
