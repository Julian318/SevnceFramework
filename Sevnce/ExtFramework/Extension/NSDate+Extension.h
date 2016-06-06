//
//  NSDate+Extension.h
//  轻松调频
//
//  Created by imac on 13-6-9.
//  Copyright (c) 2013年 criOnline. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
@property NSInteger weekDay;
@property NSInteger year;
@property NSInteger month;
@property NSInteger day;
@property NSInteger hour;
@property NSInteger minute;
@property NSInteger second;
@property NSInteger week;
@property NSDate* beijingNow;
@property NSDate* firstDayOfTheMonth;
@property NSDate* followingDay;
@property NSUInteger numberOfWeeksInMonth;
+(NSDate*)dateWithFormat:(NSString*)format value:(NSString*)value;
+(NSDate*)today;
+(NSString*)NowByString;
-(NSString*)stringWithFormat:(NSString*)format;
-(Boolean)earlierThan:(NSDate*)otherDate;
-(Boolean)laterThan:(NSDate*)otherDate;
-(Boolean)between:(NSDate*)startDate endDate:(NSDate*)endDate;
-(NSDate*)dateAfterDays:(int)dayDiff;
-(NSDate*)dateAfterMonths:(int)monthDiff;
-(NSDate*)dateAfterHours:(int)diff;
-(Boolean)isToday;
@end
