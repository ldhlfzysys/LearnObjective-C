//
//  AsyncDrawViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/8/4.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "AsyncDrawViewController.h"

@interface WBImage : UIImage

@end
@implementation WBImage

-(void)drawInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [super drawInRect:rect];
}

@end

@implementation TestAsyncDrawView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.testStr = @"异步来画这句话";
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, 1);
    CGContextRef context2 = UIGraphicsGetCurrentContext();
    
    WBImage *image = [[WBImage alloc] initWithCGImage:[UIImage imageNamed:@"test.png"].CGImage];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [image drawInRect:CGRectMake(100, 0, 30, 30)];
//        CGContextDrawImage(context, CGRectMake(100, 0, 30, 30), image.CGImage);
        UIGraphicsEndImageContext();
    });
    
    
}

-(BOOL)drawInRect:(CGRect)rect Context:(CGContextRef)context
{
    CGContextRef contextnew = UIGraphicsGetCurrentContext();
    WBImage *image = [[WBImage alloc] initWithCGImage:[UIImage imageNamed:@"test.png"].CGImage];
//    [image drawInRect:CGRectMake(0, 0, 30, 30)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [image drawInRect:CGRectMake(100, 0, 30, 30)];
        UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(100,0,30, 30)];
        [imagev setImage:image];
//        [self addSubview:imagev];
    });
//    CGContextDrawImage(context, CGRectMake(100, 0, 30, 30), image.CGImage);
    return YES;
}

@end

@implementation AsyncDrawViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    TestAsyncDrawView *view = [[TestAsyncDrawView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    view.backgroundColor = [UIColor grayColor];
    [cell addSubview:view];
//    [view setNeedsDisplay];
    return cell;
}

@end
