//
//  Created by Harvey on 13-5-30.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

/// CCLabel继承UILabel
@interface CCLabel : UILabel

/// 获取CCLabel实例
+ (CCLabel *)createWithText:(NSString *)text fontSize:(CGFloat)fontSize frame:(CGRect)frame;

/// 获取CCLabel实例
+ (CCLabel *)createWithText:(NSString *)text blodFontSize:(CGFloat)fontSize frame:(CGRect)frame;

/// 获取CCLabel实例
UIKIT_EXTERN CCLabel *CCLabelCreateWithNewValue(NSString *text,CGFloat fontSize,CGRect frame);

/// 获取CCLabel实例
UIKIT_EXTERN CCLabel *CCLabelCreateWithBlodNewValue(NSString *text,CGFloat fontSize,CGRect frame);

/// 添加点击事件
- (void)addAction:(SEL)action runTarget:(id)target;

/// 更改字体(粗体)大小
- (void)alterFontUseBlodWithSize:(CGFloat)fontSize;

/// 更改字体大小
- (void)alterFontSize:(CGFloat)fontSize;

/// 更改字体颜色
- (void)alterFontColor:(UIColor *)textColor;

/// 清除背影颜色,使背影透明
- (void)clearBackgroundColor;

@end
