//
//  GetNSPredicateViewController.h
//  LearnObjective-C
//
//  Created by liudonghuan on 16/6/30.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 比较运算法
 >,<,==<>=,<=,!=
 */

/*
 * 范围运算符
 IN
 BETWEEN
 AND
 OR
 NOT
 ANY
 SOME
 ALL
 NONE
 */

/*
 * 本身引用
 SELF
 */

/*
 * 字符串包含
 CONTAIN [c]
 BEGINSWITH
 ENDSWITH
 注:[c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号
 */

/*
 * 通配符
 LIKE [c]
 */

/*
 * 正则
 MATCHES
 */

@interface NSPredicateViewController : UIViewController

@end
