//
//  CalendarManager.m
//  LearnObjective-C
//
//  Created by liudonghuan on 16/8/5.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import "CalendarManager.h"

@implementation CalendarEvent

- (void)updateWithJSONDictionary:(NSDictionary *)dict
{
    self.title = [dict objectForKey:@"title"];
    self.desc = [dict objectForKey:@"des"];

    NSTimeInterval tempTimeInteverval = [[dict objectForKey:@"dt_start"] integerValue];
    self.startDate = [NSDate dateWithTimeIntervalSince1970:tempTimeInteverval];

    self.endDate = self.startDate;
    
    NSArray *alarmsInterval = [dict objectForKey:@"alarm_list"];
    NSMutableArray *alarms = [NSMutableArray array];
    if (alarmsInterval)
    {
        [alarmsInterval enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger number = [obj integerValue];
            [alarms addObject:@((- number * 60))];
        }];
    }
    
    self.alarms = alarms;
    
    self.url = [dict objectForKey:@"scheme"];
}


@end

static dispatch_queue_t wb_calendar_manager_queue;

@implementation CalendarManager

+ (instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    static CalendarManager *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        wb_calendar_manager_queue = dispatch_queue_create("wb_calendar_manager_queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return sharedManager;
}

- (EKCalendar*)defaultCalendar
{
    return self.eventStore.defaultCalendarForNewEvents;
}

-(EKCalendar *)laiseeCalendar
{
    return _eventStore.defaultCalendarForNewEvents;
}

//读取日历
- (NSArray *)fetchEventsStartDate:(NSDate*)startDate_ EndDate:(NSDate *)endDate_
{
    //
    if (!startDate_ || !endDate_) {
        return nil;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.minute = -1;
    NSDate *oneMinAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:startDate_
                                                 options:0];
    
    // 创建结束日期组件（Create the end date components）
    NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
    oneYearFromNowComponents.minute = 1;
    NSDate *oneMinAfter = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                    toDate:endDate_
                                                   options:0];
    //
    // We will only search the default calendar for our events
    NSArray *calendarArray = @[self.defaultCalendar];
    
    // Create the predicate
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:oneMinAgo
                                                                      endDate:oneMinAfter
                                                                    calendars:calendarArray];
    NSArray *events = [self.eventStore  eventsMatchingPredicate:predicate];
    
    return events;
}
//奥运日历使用
- (void)isCalendarEventExist:(CalendarEvent *)event_ completion:(void(^)(BOOL exist))completion
{
    if (!completion)
    {
        return;
    }
    NSArray *events = [self fetchEventsStartDate:event_.startDate EndDate:event_.endDate];
    __block BOOL isExist = NO;
    [events enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EKEvent *event = (EKEvent *)obj;
        if ([event.title isEqualToString:event_.title] && [event.startDate isEqualToDate:event_.startDate]) {
            isExist = YES;
            *stop = YES;
        }
    }];
    if (isExist)
    {
        completion(YES);
    }
    else
    {
        completion(NO);
    }
}

- (BOOL)checkAccessForCalendar
{
    BOOL authorization = NO;
    
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (status == EKAuthorizationStatusAuthorized)
    {
        authorization = YES;
    }
    return authorization;
}

//日历存储
- (void)saveCalendarEvent:(CalendarEvent *)event_ completion:(void(^)(BOOL success, NSError *error))completion
{
    if (!completion)
    {
        return;
    }
    if (![self checkAccessForCalendar])
    {
        NSError *error = [NSError errorWithDomain:WBCalendarErrorDomain code:WBCalendarErrorUnauthorized userInfo:nil];
        completion(NO, error);
        return;
    }
    
    if (event_ == nil)
    {
        NSError *error = [NSError errorWithDomain:WBCalendarErrorDomain code:WBCalendarErrorMissingArgu userInfo:nil];
        completion(NO, error);
        return;
    }
    
    if (!event_.startDate || !event_.endDate || !(event_.title.length > 0)) {
        NSError *error = [NSError errorWithDomain:WBCalendarErrorDomain code:WBCalendarErrorMissingArgu userInfo:nil];
        completion(NO, error);
        return;
    }
    dispatch_async(wb_calendar_manager_queue, ^{
        EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
        event.title = event_.title;
        event.startDate = event_.startDate;
        event.endDate = event_.endDate;
        event.notes = event_.desc;
        event.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        
        if (event_.alarms.count > 0)
        {
            [event_.alarms enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
                [event addAlarm:[EKAlarm alarmWithRelativeOffset:[obj integerValue]]];
            }];
        }
        event.availability = EKEventAvailabilityFree;
        [event setCalendar:self.laiseeCalendar];
        if (event_.url)
        {
            event.URL = [NSURL URLWithString:event_.url];
        }
        NSError *error = nil;
        [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, error);
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(YES, nil);
            });
        }
        
    });
}

- (void)saveCalendarEventNoRepeat:(CalendarEvent *)event_ completion:(void(^)(BOOL success, NSError *error))completion
{
    NSArray *events = [self fetchEventsStartDate:event_.startDate EndDate:event_.endDate];
    __block BOOL exist = NO;
    [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EKEvent *event = (EKEvent *)obj;
        if ([event.title isEqualToString:event_.title] && [event.startDate isEqualToDate:event_.startDate])
        {
            //已有
            completion(YES,nil);
            exist = YES;
            *stop = YES;
        }
    }];
    
    if (!exist) [self saveCalendarEvent:event_ completion:completion];
    
}

- (void)removeCalendarEvent:(CalendarEvent *)event_ completion:(void(^)(BOOL success, NSError *error))completion
{
    if (!completion)
    {
        return;
    }
    dispatch_async(wb_calendar_manager_queue, ^{
        NSArray *events = [self fetchEventsStartDate:event_.startDate EndDate:event_.endDate];
        [events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            EKEvent *event = (EKEvent *)obj;
            NSError *error = nil;
            if ([event.title isEqualToString:event_.title] && [event.startDate isEqualToDate:event_.startDate])
            {
                [self.eventStore removeEvent:event span:EKSpanThisEvent error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES, error);
                });
            }
        }];
        if (!events) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:WBCalendarErrorDomain code:WBCalendarErrorMissingArgu userInfo:nil];
                completion(NO, error);
            });
        }
        
    });
    
    
}

- (void)checkAccessAndRequestForCalendarSyncWithCompletion:(void(^)(BOOL granted))completion
{
    if (!completion)
    {
        return;
    }
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    if (status == EKAuthorizationStatusAuthorized)
    {
        completion(YES);
    }
    else if (status == EKAuthorizationStatusDenied || status == EKAuthorizationStatusRestricted)
    {
        completion(NO);
    }
    else if (status == EKAuthorizationStatusNotDetermined)
    {
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            completion(granted);
        }];
    }
}

- (void)saveCalendarEventsArray:(NSArray *)eventsArray completion:(void (^)(BOOL success, NSError *error))completion{
    
    // 循环遍历数组，逐条插入系统日历
    if (!completion) {
        return;
    }
    if (eventsArray == nil || eventsArray.count == 0)
    {
        NSError *error = [NSError errorWithDomain:WBCalendarErrorDomain code:WBCalendarErrorMissingArgu userInfo:nil];
        completion(NO, error);
        return;
    }
    
    __weak CalendarManager *weakSelf = self;
    [eventsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CalendarEvent *event = obj;
        [weakSelf saveCalendarEvent:event completion:^(BOOL success, NSError *error) {
            completion(success,error);
        }];
    }];
}

@end
