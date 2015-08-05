//
//  CCDate.h
//  HarveySDK
//
//  Created by Harvey on 14-1-16.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCDate : NSDate

/// 返回当前系统时间,格式yyyy-MM-dd HH:mm:ss
+ (NSString *)systemDate;
+ (NSString *)systemDateWithFormatter:(NSString *)format;


/// 将NSTimeInterval转为格式yyyy-MM-dd的日期
+ (NSString *)timeIntervalConvertDate:(NSTimeInterval)time;

///将NSTimeInterval转为格式指定fomatter的日期
+ (NSString *)timeIntervalConvertDate:(NSTimeInterval)time formatter:(NSString *)formatter;

/// 一年有多少个周
- (NSInteger)calculateWeeksOfYear:(NSInteger)year;

+ (NSDate *)timeDate:(NSString *)date formatter:(NSString *)formatter;

+ (NSString *)stringFromDate:(NSDate *)date formatter:(NSString *)formatter;
/**
 *  将CST时间字符串转为指定格式
 *
 *  @param cstFormatter 为CST格式时间
 *  @param format       指定时间格式
 *
 *  @return format格式的时间字符串
 */
+ (NSString *)stringFormCSTFormatter:(NSString *)cstFormatter withFormat:(NSString *)format;

@end
