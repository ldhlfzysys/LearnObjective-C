//
//  testModel.h
//  LearnObjective-C
//
//  Created by donghuan1 on 16/8/22.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "BaseModel.h"

//extern NSString* const DHTEST;

@interface testModel : BaseModel
@property (nonatomic,strong)NSString *str;
@property (nonatomic,assign)NSInteger number;
@property (nonatomic,strong)NSDictionary *dict;
@end
