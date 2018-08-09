//
//  MyOperation.h
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/6.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyOperation;
@protocol MyOperationDelegate <NSObject>
- (void)loadCompleted:(MyOperation *)operarion url:(NSString *)url;
@end

@interface MyOperation : NSOperation
@property (nonatomic,copy)NSString *url;
@property(nonatomic, weak)id<MyOperationDelegate> delegate;
@property(atomic, readonly, getter = isFinished)BOOL finished;
@property(atomic, readonly, getter = isExecuting)BOOL executing;
@property (nonatomic, strong) NSRecursiveLock *lock;
- (instancetype)initWithUrl:(NSString *)url;
@end
