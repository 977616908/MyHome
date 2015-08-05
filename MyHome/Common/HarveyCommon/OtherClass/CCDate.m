//
//  CCDate.m
//  HarveySDK
//
//  Created by Harvey on 14-1-16.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import "CCDate.h"

@implementation CCDate

+ (NSString *)systemDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *)systemDateWithFormatter:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:[NSDate date]];

}

+ (NSString *)stringFormCSTFormatter:(NSString *)cstFormatter withFormat:(NSString *)format
{
    NSDateFormatter* dateFormat=[NSDateFormatter new];
    dateFormat.dateFormat = @"EEE, MM LLL yyyy HH:mm:ss +A";
    NSDate *date = [dateFormat dateFromString:cstFormatter];
    
    dateFormat.dateFormat = format;
    return [dateFormat stringFromDate:date];
}

+ (NSString *)timeIntervalConvertDate:(NSTimeInterval)time
{
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:@"yyyy-MM-dd"];
    return [matter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

+ (NSString *)timeIntervalConvertDate:(NSTimeInterval)time formatter:(NSString *)formatter
{
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    [matter setDateFormat:formatter];
    return [matter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

- (NSInteger)calculateWeeksOfYear:(NSInteger)year
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%ld-12-31",(long)year]];
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    [calendar setMinimumDaysInFirstWeek:4];
    NSDateComponents*comps = [calendar components:NSWeekCalendarUnit fromDate:date];
    
    if([comps week] == 1) {
        
        date = [formatter dateFromString:[NSString stringWithFormat:@"%ld-12-27",(long)year]];
        comps = [calendar components:NSWeekCalendarUnit fromDate:date];
       return [comps week];
    }
    return [comps week];
}

+ (NSDate *)timeDate:(NSString *)date formatter:(NSString *)formatter{
    NSDateFormatter *sdf=[[NSDateFormatter alloc]init];
    [sdf setDateFormat:formatter];
    return [sdf dateFromString:date];
}

+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter{
    NSDateFormatter *sdf=[[NSDateFormatter alloc]init];
    [sdf setDateFormat:formatter];
    return [sdf stringFromDate:date];
}

@end
