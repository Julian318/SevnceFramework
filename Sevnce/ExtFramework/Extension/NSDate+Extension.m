//
//  NSDate+Extension.m
//  轻松调频
//
//  Created by imac on 13-6-9.
//  Copyright (c) 2013年 criOnline. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
+(NSDate*)dateWithFormat:(NSString*)format value:(NSString*)value{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    NSDate* date = [formatter dateFromString:value];
    return date;
}
-(void)setBlock:(id)block{
    
}
-(NSString*)stringWithFormat:(NSString*)format{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}
- (NSDateComponents *)componentsOfDay
{
    static NSDateComponents *dateComponents = nil;
    static NSDate *previousDate = nil;
    if (!previousDate || ![previousDate isEqualToDate:self]) {
        previousDate = self;
        dateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self];
    }
    return dateComponents;
}

-(NSInteger)weekDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps=[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
                                        fromDate:self];
    NSInteger today=[comps weekday]-2;
    if(today==-1)today=6;
    return today;
}
-(NSInteger)hour{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger hour = [components hour];
    return hour;
}
-(NSInteger)second{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps=[calendar components:(NSSecondCalendarUnit)
                                        fromDate:self];
    return [comps second];
}

-(Boolean)earlierThan:(NSDate*)otherDate{
    return self==[self earlierDate:otherDate];
}
-(Boolean)isToday{
    NSDate* today=[NSDate today];
    return self.year==today.year&&self.month==today.month&&self.day==today.day;
}
-(Boolean)between:(NSDate*)startDate endDate:(NSDate*)endDate{
    return self==[self earlierDate:endDate]&&self==[self laterDate:startDate];
}
-(Boolean)laterThan:(NSDate*)otherDate{
    return self==[self laterDate:otherDate];
}
-(NSInteger)year{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger month = [components year];
    return month;
}
-(NSInteger)month{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger month = [components month];
    return month;
}
-(NSInteger)day{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger month = [components day];
    return month;
}
-(NSInteger)week{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    return components.weekday;
}
+(NSDate*)today{
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
-(NSDate*)beijingNow{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    NSString *loctime = [dateFormatter stringFromDate:self];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:loctime];
    return date;
}
+(NSString*)NowByString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    return [dateFormatter stringFromDate:[NSDate today]];
}

/******************************************
 *@Description:获取当月的天数
 *@Params:nil
 *@Return:当月的天数
 ******************************************/
- (NSUInteger)numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}
/******************************************
 *@Description:获取当月的第一天
 *@Params:nil
 *@Return:当月的第一天
 ******************************************/
- (NSDate *)firstDayOfTheMonth
{
    [[self componentsOfDay] setDay:1];
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}

/******************************************
 *@Description:获取当月的最后一天
 *@Params:nil
 *@Return:当月的最后一天
 ******************************************/
- (NSDate *)lastDayOfTheMonth
{
    [[self componentsOfDay] setDay:[self numberOfDaysInMonth]];
    return [[NSCalendar currentCalendar] dateFromComponents:[self componentsOfDay]];
}
/******************************************
 *@Description:获取当月的周数
 *@Params:nil
 *@Return:当月的周数
 ******************************************/
- (NSUInteger)numberOfWeeksInMonth
{
    NSUInteger weekOfFirstDay = [[self firstDayOfTheMonth] componentsOfDay].weekday;
    NSUInteger numberDaysInMonth = [self numberOfDaysInMonth];
    
    return ((weekOfFirstDay - 1 + numberDaysInMonth) % 7) ? ((weekOfFirstDay - 1 + numberDaysInMonth) / 7 + 1): ((weekOfFirstDay - 1 + numberDaysInMonth) / 7);
}
/******************************************
 *@Description:获取当天是当年的第几周
 *@Params:nil
 *@Return:当天是当年的第几周
 ******************************************/
- (NSUInteger)weekOfDayInYear
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSWeekOfYearCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
}
/******************************************
 *@Description:后一天
 *@Params:nil
 *@Return:后一天
 ******************************************/
- (NSDate *)followingDay
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}
- (NSDate *)dateAfterDays:(int)dayDiff
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = dayDiff;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}
- (NSDate *)dateAfterMonths:(int)monthDiff
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = monthDiff;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}
- (NSDate *)dateAfterHours:(int)diff
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = diff;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}
@end
