//
//  CustomView.m
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/6.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import "CustomView.h"
#import <React/RCTLog.h>

@implementation CustomView
RCT_EXPORT_MODULE();
RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
{
    RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end
