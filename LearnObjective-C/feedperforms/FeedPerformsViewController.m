//
//  FeedPerformsViewController.m
//  LearnObjective-C
//
//  Created by donghuan1 on 16/9/26.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "FeedPerformsViewController.h"

@implementation FeedPerformsViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self analysisDatas2];
    }
    return self;
}

- (void)anlysisDatas
{
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"performsdata" ofType:@"json"]];
    
    NSArray *datas = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    __block NSMutableArray *parseTimes = [NSMutableArray array];
    __block NSMutableArray *netTimes = [NSMutableArray array];
    __block NSMutableArray *durings = [NSMutableArray array];
    
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = obj;
        if ([[dict objectForKey:@"netDataCount"] integerValue] > 14) {
            if ([dict objectForKey:@"parseTime"] != nil)
            {
                [parseTimes addObject:[dict objectForKey:@"parseTime"]];
            }
            if ([dict objectForKey:@"net_time"] != nil) {
                [netTimes addObject:[dict objectForKey:@"net_time"]];
            }
            if ([dict objectForKey:@"during_time"]) {
                [durings addObject:[dict objectForKey:@"during_time"]];
            }


        }
    }];
    
    NSLog(@"parseTime:%f",[self valueForAverage:parseTimes]);
    NSLog(@"NetTime:%f",[self valueForAverage:netTimes]);
    NSLog(@"during:%f",[self valueForAverage:durings]);
    
}

- (double)valueForAverage:(NSArray *)arr
{
    __block double count = 0;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        double value = [obj doubleValue];
        count += value;
    }];
    double average = count/arr.count;
    return average;
}

//
- (void)analysisDatas2
{
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"analysisdata" ofType:@"json"]];
    
    NSArray *datas = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    __block NSMutableArray *persent = [NSMutableArray array];

    __block double oneTime = 0;
    __block double parserTime = 0;
    [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dict = obj;
        
        if ([dict objectForKey:@"Parser"])
        {
            parserTime += [[dict objectForKey:@"Parser"] doubleValue];
        }
        if ([dict objectForKey:@"One"])
        {
            double OneStatusTime = [[dict objectForKey:@"One"] doubleValue];
            double persentValue = parserTime/OneStatusTime;
            parserTime = 0;
            oneTime += OneStatusTime;
            [persent addObject:[NSNumber numberWithDouble:persentValue]];
            
        }
        if ([dict objectForKey:@"ALL"])
        {
            double alltime = [[dict objectForKey:@"ALL"] doubleValue];
            NSLog(@"all persent:%f",oneTime/alltime);
            
        }
    }];
    NSLog(@"averge:%f",[self valueForAverage:persent]);
}



@end
