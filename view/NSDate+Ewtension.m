

#import "NSDate+Ewtension.h"

@implementation NSDate (Ewtension)

- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    //日历
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    //比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calender components:unit fromDate:from toDate:[NSDate date] options:0];
}

- (BOOL)isThisYear
{
    //日历
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSInteger nowYear = [calender component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calender component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

- (BOOL)isToday
{
    //日历
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *nowCmps = [calender components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calender components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year && nowCmps.month == selfCmps.month && nowCmps.day == selfCmps.day;
}

- (BOOL)isYesterday
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *now = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calender components:NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth fromDate:selfDate toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

@end
