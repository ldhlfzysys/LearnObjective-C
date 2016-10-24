//
//  HeaderContext.h
//  LearnObjective-C
//
//  Created by donghuan1 on 16/9/8.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



//这个协议用于主动和VC通信
@protocol HeaderContext <NSObject>

- (void)updateHeight:(CGFloat)height;

@end

//这个协议用于规范需要显示在我上面的view
@protocol HeaderViewSetup <NSObject>

@required
@property (nonatomic,strong)UIView *showView;
//通知子view要更新了
- (void)updateView;

@end


@interface HeaderContext : NSObject
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,assign)id<HeaderContext> delegate;
//@property (nonatomic,assign)HeaderNeedShowType showType;

- (instancetype)initWithDelegate:(id)delegate;
- (void)update;

- (void)registerView:(Class)className;
@end

