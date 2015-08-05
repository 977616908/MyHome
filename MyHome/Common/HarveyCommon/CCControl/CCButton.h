//
//  Created by Harvey on 13-5-30.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 按钮类, 继承于UIButton
@interface CCButton : UIButton

///获取CCButton实例
+ (CCButton *)createWithFrame:(CGRect)frame;

///获取CCButton实例
+ (CCButton *)createWithTitle:(NSString *)title backImage:(NSString *)normalImageName frame:(CGRect)frame;

///获取CCButton实例
+ (CCButton *)createWithTitle:(NSString *)title backImage:(NSString *)normalImageName pressBackImage:(NSString *)pressImageName frame:(CGRect)frame;

/// 使用粗体, 更改title的字体大小
- (void)alterFontUseBoldWithSize:(CGFloat)fontSize;

/// 更改title颜色
- (void)alterNormalTitleColor:(UIColor *)color;

/// 更改title按下时的颜色
- (void)alterPressTitleColor:(UIColor *)color;

/// 更改title
- (void)alterNormalTitle:(NSString *)title;

/// 更改title的字体大小
- (void)alterFontSize:(CGFloat)fontSize;

/// 更改背景图片
- (void)alterNormalBackgroundImage:(NSString *)imgeName;

/// 更改按下时的背景图片
- (void)alterPressBackgroundImage:(NSString *)imgeName;

/// 添加单击事件
- (void)addAction:(SEL)action runTarget:(id)target;

///获取CCButton实例
UIKIT_EXTERN CCButton *CCButtonCreateWithFrame(CGRect frame);

///获取CCButton实例
UIKIT_EXTERN CCButton *CCButtonCreateWithValue(CGRect frame,SEL action,id target);

@end









