//
//  EAGLViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2021/11/18.
//  Copyright © 2021 Dwight. All rights reserved.
//

#import "EAGLViewController.h"
#import <GLKit/GLKBaseEffect.h>
#import <GLKit/GLKEffects.h>

@interface OpenGLView()
{
    GLuint framebuffer;
    GLKBaseEffect *effect;
    CADisplayLink *ticker;
    BOOL testa;
}
@end

@implementation OpenGLView

+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (void)setupTicker
{
    ticker = [CADisplayLink displayLinkWithTarget:self selector:@selector(doCaller:)];
    [ticker setFrameInterval:60];
    [ticker addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
}

- (void)doCaller:(id)sender {
    [self render];
}

 
- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
 
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupFrameBuffer {
    
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
        GL_RENDERBUFFER, _colorRenderBuffer);
 }



- (void)render {
    int r =arc4random()%255;
    int g=arc4random()%255;
    int b=arc4random()%255;
    glClearColor(r/255.0, g/255.0, b/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    NSLog(@"%@ - %p",[NSThread currentThread],[EAGLContext currentContext]);
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (void)setupCanAsync
{
    [self setupContext];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self setupTicker];
}

// Replace dealloc method with this
- (void)dealloc
{
    _context = nil;
}

@end

@interface EAGLViewController ()
{
    
}
@end

@implementation EAGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    OpenGLView *a = [[OpenGLView alloc] initWithFrame:CGRectMake(10, 90, 200, 200)];
    [a setupCanAsync];
    [self.view addSubview:a];
    
    OpenGLView *b = [[OpenGLView alloc] initWithFrame:CGRectMake(10, 300, 200, 200)];
    WBMPPerformBlockOnWBoxGameThread(^{
        [b setupCanAsync];
    });
    [self.view addSubview:b];
}


-(void)loadView{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.view = scroll;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.translatesAutoresizingMaskIntoConstraints  = NO;
    scroll.contentSize = CGSizeMake(scroll.frame.size.width, 10000);
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


@interface WBMPGameThread : NSObject
@property (nonatomic, strong) NSThread *gameThread;
@property (nonatomic, assign) BOOL gameThreadStop;
@end
@implementation WBMPGameThread

void WBMPPerformBlockOnWBoxGameThread(void (^block)(void))
{
    [[WBMPGameThread sharedManager] performBlockOnWBoxGameThread:block];
}

void WBMPPerformBlockOnWBoxGameThreadSync(void (^block)(void))
{
    [[WBMPGameThread sharedManager] performBlockOnWBoxGameThreadSync:block];
}

- (void)performBlockOnWBoxGameThread:(void (^)(void))block
{
    if ([NSThread currentThread] == _gameThread) {
        block();
    } else {
        [self performSelector:@selector(performBlockOnWBoxGameThread:)
                     onThread:_gameThread
                   withObject:[block copy]
                waitUntilDone:NO];
    }
}

- (void)performBlockOnWBoxGameThreadSync:(void (^)(void))block
{
    if ([NSThread currentThread] == _gameThread) {
        block();
    } else {
        [self performSelector:@selector(performBlockOnWBoxGameThread:)
                     onThread:_gameThread
                   withObject:[block copy]
                waitUntilDone:YES];
    }
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static WBMPGameThread *manager;
    dispatch_once(&onceToken, ^{
        manager = [[WBMPGameThread alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _gameThread = [[NSThread alloc] initWithTarget:self selector:@selector(_runGameThread) object:nil];
        _gameThread.name = @"wb.wbox.game";
        _gameThread.qualityOfService = [[NSThread mainThread] qualityOfService];
        [_gameThread start];

    }
    return self;
}

- (void)_runGameThread
{
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    while (!_gameThreadStop) {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}

@end
