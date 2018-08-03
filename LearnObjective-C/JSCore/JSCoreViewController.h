//
//  JSCoreViewController.h
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/2.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
/*
 JSContext
    一个JSContext对象代表一个JavaScript执行环境。在native代码中，使用JSContext去执行JS代码，访问JS中定义或者计算的值，并使JavaScript可以访问native的对象、方法、函数。
 

 JSValue
    一个JSValue实例就是一个JavaScript值的引用。使用JSValue类在JavaScript和native代码之间转换一些基本类型的数据（比如数值和字符串）每个JSValue对象都持有其JSContext对象的强引用
    Objective-C type  |  JavaScript type
 ------------------------------------------
    nil                     undefined
    NSNull                  null
    NSString                string
    NSNumber                number, boolean
    NSDictionary            Object object
    NSArray                 Array object
    NSDate                  Date object
    NSBlock                 Function object
    id                      Wrapper object
    Class                   Constructor object
 
 JSManagedValue
    JSManagedValue，jsvalue没有强引用会释放，强引用容易造成循环引用。用于jsvalue的条件引用
 JSVirtualMachine
    实现并发的js执行，单个虚拟机内是线程安全的
    桥接对象内存管理
 JSExport
    将oc中对象暴露给js用
 */

@interface JSCoreViewController : UIViewController

@end
