//
//  CalendarManager.h
//  LearnObjective-C
//
//  Created by liudonghuan on 16/8/5.
//  Copyright © 2016年 Dwight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

extern NSString * const WBCalendarErrorDomain;

typedef NS_ENUM(NSUInteger, WBCalendarError) {
    WBCalendarErrorUnknow,
    WBCalendarErrorMissingArgu,
    WBCalendarErrorUnauthorized,
    WBCalendarErrorSystemError,
};

@interface CalendarEvent : NSObject

@property (nonatomic, readonly, copy) NSString *eventID;
@property (nonatomic, readonly, copy) NSString *calendarEventID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSArray *alarms;
@property (nonatomic, copy) NSString *url;

@end


@interface CalendarManager : NSObject

@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *laiseeCalendar;

@end
