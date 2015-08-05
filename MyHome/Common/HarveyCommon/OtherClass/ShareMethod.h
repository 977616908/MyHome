//
//  Created by Harvey on 13-5-30.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareMethod : NSObject

/// 指定字体大小, 计算字符串长度
+ (CGFloat)calculateWidthWithString:(NSString *)string fontSize:(CGFloat)fontSize;

/// 指定字体(粗体)大小, 计算字符串长度
+ (CGFloat)calculateWidthWithString:(NSString *)string boldFontSize:(CGFloat)fontSize;

/// 指定字体大小和宽度, 计算字符串高度
+ (CGFloat)calculateHeightWithString:(NSString *)string width:(CGFloat)width fontSize:(CGFloat)fontSize;

/// 指定字体大小(粗体)和宽度, 计算字符串高度
+ (CGFloat)calculateHeightWithString:(NSString *)string width:(CGFloat)width boldFontSize:(CGFloat)fontSize;

/// 从字符串中去掉HTML标签, tags:HTML标签数组
+ (NSString *)removeHTMLTagFromString:(NSString *)str HTMLTags:(NSArray *)tags;

@end
