//
//  MyOperation.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/6.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import "MyOperation.h"

@implementation MyOperation
@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.url = url;
        self.lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

+ (void)networkRequestThreadEntryPoint
{
    @autoreleasepool {
        [[NSThread currentThread] setName:@"WBImageLoadOperationWithLock"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (NSThread *)networkRequestThread
{
    static NSThread *_networkRequestThread = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _networkRequestThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkRequestThreadEntryPoint) object:nil];
        [_networkRequestThread start];
    });
    
    return _networkRequestThread;
}

- (void)main{
    [self.lock lock];
    
    if (self.isCancelled) {
        self.finished = YES;
        [_delegate loadCompleted:self url:nil];
    }else{
        sleep(5);
        [_delegate loadCompleted:self url:self.url];
        self.finished = YES;
    }
    [self.lock unlock];
}

-(void)cancel{
    void (^doCancel)(void) = ^ {
        [self.lock lock];
        
        if (!self.isFinished && !self.isCancelled)
        {
            [self willChangeValueForKey:@"isCancelled"];
            [super cancel];
            [self didChangeValueForKey:@"isCancelled"];
            
            [self performSelector:@selector(cancelConnection)
                         onThread:[[self class] networkRequestThread]
                       withObject:nil
                    waitUntilDone:NO
                            modes:@[NSRunLoopCommonModes]];
        }
        [self.lock unlock];
        
        
    };
    
    if ([NSThread isMainThread])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), doCancel);
    }
    else
    {
        doCancel();
    }
}

- (void)cancelConnection{
    if (self.isExecuting) {
        [self setFinished:YES];
    }
}

- (void)setFinished:(BOOL)finished
{
    [self.lock lock];
    if (finished != _finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self setExecuting:!finished];
        [self didChangeValueForKey:@"isFinished"];
    }
    [self.lock unlock];

}

- (void)setExecuting:(BOOL)executing
{
    [self.lock lock];
    if (executing != _executing) {
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
    [self.lock unlock];
    
}

- (BOOL)isConcurrent
{
    return YES;
}

@end
