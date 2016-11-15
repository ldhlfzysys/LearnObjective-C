//
//  WBFPSManager.h
//  WBTool
//
//  Created by donghuan1 on 16/9/7.
//  Copyright © 2016年 Sina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBFPSManager : NSObject<UIAlertViewDelegate>

//精确度，单位：(次/秒)，最精确为60，如果精确度为2即1秒取2次值，每次值是30次的平均值。精度必须可被60整除
//设置精确度会重置各参数并且停止统计，需要调用start来重启
@property (nonatomic,assign)NSUInteger precision;
//调用startRecordCardType:开启后会一直记录，知道记录结束才停止。通过设置needRecording来控制记录的值是否存储。
@property (nonatomic,assign)BOOL needRecording;

//开启统计的总开关，在调试选项里开启
@property (nonatomic,assign)BOOL mainSwitch;


+ (WBFPSManager *)sharedManager;

//停止统计（一般在统计完成时调用，主动调用将提前结束统计）
- (void)endRecord;

//开启统计@"feed"表示feed，包含"card" 表示为card。其他会弹框提示输入
- (void)startRecordType:(id)type;

- (void)recordMBlogs:(NSString *)status Trend:(BOOL)isTrend;//(记录当前微博id，暂时不用)
@end
