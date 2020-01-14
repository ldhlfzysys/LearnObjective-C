//
//  SnapshotViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2019/11/7.
//  Copyright © 2019 Dwight. All rights reserved.
//

#import "SnapshotViewController.h"

@interface SnapshotViewController ()

@end

@implementation SnapshotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 100, 30)];
    [l setText:@"aaaaaaaaaa"];
    [l setTextColor:[UIColor blackColor]];
    [self.view addSubview:l];
    
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 100, 30)];
    [l2 setText:@"aaaaaaaaaa"];
    [l2 setTextColor:[UIColor blackColor]];
    [self.view addSubview:l2];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIImage *image;
    CGSize newSize = [UIScreen mainScreen].bounds.size;
    @try {
        UIGraphicsBeginImageContextWithOptions(newSize, YES, 0.5);
        [self.view drawViewHierarchyInRect:(CGRect){{0,0}, newSize} afterScreenUpdates:NO];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } @catch (NSException *exception) {
        
    }
    
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 300, 300, 300)];
    imagev.layer.borderColor = [UIColor blackColor].CGColor;
    imagev.layer.borderWidth = 1;
    [imagev setImage:image];
    [self.view addSubview:imagev];
}

+ (CGFloat)accountWithImage:(UIImage *)image{
    if (!image || ![image isKindOfClass:[UIImage class]]) return CGFLOAT_MIN;
    CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
    CFDataRef pixelData = CGDataProviderCopyData(provider);
    const UInt8 *data = CFDataGetBytePtr(pixelData);
    long dataLength = CFDataGetLength(pixelData);
    int numberOfColorComponents = 4;
    
    int colorCount = 0;
    int detectionCount = 0;
    for (int i = 0; i < dataLength; i += numberOfColorComponents) {
        if (data[i+3] != 0) {
            ++colorCount;
            
            UInt8 blue = data[i];
            UInt8 green = data[i+1];
            UInt8 red = data[i+2];
            if (blue >= 250 && green >= 250 && red >= 250) {
                ++detectionCount;
            }
        }
    }
    
    return (colorCount > 0) ? (CGFloat)detectionCount / colorCount : CGFLOAT_MIN;
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
