
//
//  DrawViewController.m
//  LearnObjective-C
//
//  Created by liudonghuan on 16/7/22.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "DrawViewController.h"

@interface DrawView()
{
    NSString *test;
    CAGradientLayer *gradientLayer;
}

@end
@implementation DrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.backgroundColor = [UIColor grayColor].CGColor;
        gradientLayer.frame = CGRectMake(5, 5, 200, 5);
        
        gradientLayer.startPoint = CGPointMake(0, .5);
        gradientLayer.endPoint = CGPointMake(1, .5);
        gradientLayer.cornerRadius = 2;

        gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:249.0/255 green:183.0/255 blue:19.0/255 alpha:1] CGColor],
                                (id)[[UIColor colorWithRed:247.0/255 green:138.0/255 blue:2.0/255 alpha:1] CGColor],
                                (id)[[UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1] CGColor],
                                (id)[[UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1] CGColor],
                                nil];
        
        gradientLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                                           [NSNumber numberWithFloat:0.4],
                                    [NSNumber numberWithFloat:0.41],
                                   [NSNumber numberWithFloat:1.0],
                                           nil];
        [self.layer addSublayer:gradientLayer];

        
        
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    
    
}

- (void)setupData
{
    test = @"援助人数：133人";
}

//-(void)drawRect:(CGRect)rect
//{
//    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:test];
//    [str1 setAttributes:@{NSForegroundColorAttributeName:[UIColor yellowColor],NSFontAttributeName:[UIFont systemFontOfSize:17]} range:NSMakeRange(5, 4)];
//    
//    [str1 drawInRect:CGRectMake(0, 0, 100, 20)];
//    
//    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:test];
//    [str2 setAttributes:@{NSForegroundColorAttributeName:[UIColor yellowColor],NSFontAttributeName:[UIFont systemFontOfSize:17]} range:NSMakeRange(5, 4)];
//    
//    [str2 drawInRect:CGRectMake(0, 30, 100, 20)];
//    
//
//}

@end

@implementation DrawViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    DrawView *test = [[DrawView alloc]initWithFrame:CGRectMake(0, 100, 200, 200)];
    test.backgroundColor = [UIColor whiteColor];
    [test setupData];
    [self.view addSubview:test];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, 300, 200)];
    textView.backgroundColor = [UIColor redColor];
    textView.pasteDelegate = self;
    [self.view addSubview:textView];
}

- (BOOL)textPasteConfigurationSupporting:(id<UITextPasteConfigurationSupporting>)textPasteConfigurationSupporting shouldAnimatePasteOfAttributedString:(NSAttributedString*)attributedString toRange:(UITextRange*)textRange;

{
    return NO;
}

@end
