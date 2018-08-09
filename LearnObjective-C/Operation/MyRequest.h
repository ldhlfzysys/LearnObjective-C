//
//  MyRequest.h
//  LearnObjective-C
//
//  Created by donghuan1 on 2018/8/6.
//  Copyright © 2018年 Dwight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyRequest : NSObject
@property (nonatomic,copy)NSString *url;
- (instancetype)initWithUrl:(NSString *)url;
@end
