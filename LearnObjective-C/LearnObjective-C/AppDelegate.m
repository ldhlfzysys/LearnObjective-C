//
//  AppDelegate.m
//  LearnObjective-C
//
//  Created by liudonghuan on 16/6/30.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <objc/runtime.h>
@interface JSONA : NSObject
@property(nonatomic,strong)NSString *str;
@property(nonatomic,strong)NSArray *arr;
@property(nonatomic,strong)JSONA *child;

@end
@implementation JSONA

@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    MainViewController *mainVC = [[MainViewController alloc]init];
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    [self.window setRootViewController:mainNav];
    [self.window makeKeyAndVisible];
    
    //
    JSONA *a = [JSONA new];
    JSONA *b = [JSONA new];
    a.str = @"astr";
    a.arr = @[@"1",@"2"];
    b.str = @"bstr";
    b.arr = @[@"3",@"4"];
    a.child = b;
    NSData * data = [NSJSONSerialization dataWithJSONObject:[[self class] getObjectInternal:a] options:0 error:nil];
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
    NSLog(@"%@",jsonString);
    
    return YES;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (id)objectFromDict:(NSDictionary *)dict
{
    NSString *maybe_class = [dict objectForKey:@"_isa"];
    if (!maybe_class) {
        return dict;
    }
    
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList(NSClassFromString(maybe_class), &propsCount);
    id obj = [[NSClassFromString(maybe_class) alloc] init];
    for(int i = 0;i < propsCount; i++) {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [dict objectForKey:propName];
        if ([value isKindOfClass: [NSDictionary class]]) {
            [obj setValue:[[self class] objectFromDict:value] forKey:propName];
        }else{
            [obj setValue:value forKey:propName];
        }
    }
    return obj;
}

+ (id)objectFromJsonString:(NSString *)json
{
    NSDictionary *dict = [[self class] dictionaryWithJsonString:json];
    NSMutableDictionary *new = [[NSMutableDictionary alloc] init];
    NSArray *arr = [dict allKeys];
    // 遍历arr 取出对应的key以及key对应的value
    for (NSInteger i = 0; i < arr.count; i++) {
        id obj = [dict objectForKey:arr[i]];
        if([obj isKindOfClass:[NSString class]]
           || [obj isKindOfClass:[NSNumber class]]
           || [obj isKindOfClass:[NSNull class]]) {
            [new setObject:obj forKey:arr[i]];
        }else{
            [new setObject:[[self class] objectFromDict:obj] forKey:arr[i]];
        }
    }
    return new;
}

+ (NSDictionary*)getObjectData:(id)obj {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    for(int i = 0;i < propsCount; i++) {
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil) {
            value = [NSNull null];
        }
        else {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    [dic setObject:NSStringFromClass([obj class]) forKey:@"_isa"];
    return dic;
}

+ (id)getObjectInternal:(id)obj {
    if([obj isKindOfClass:[NSString class]]
       || [obj isKindOfClass:[NSNumber class]]
       || [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    
    if([obj isKindOfClass:[NSArray class]]) {
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for(int i = 0;i < objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    
    if([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for(NSString *key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self getObjectData:obj];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
