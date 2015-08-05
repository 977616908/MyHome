//
//  Created by Harvey on 13-5-30.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import "CCButton.h"

@implementation CCButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark mark: 初始化方法
+ (CCButton *)createWithFrame:(CGRect)frame
{
    CCButton *button = [CCButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    return button;
}

+ (CCButton *)createWithTitle:(NSString *)title backImage:(NSString *)normalImageName frame:(CGRect)frame
{
    return [CCButton createWithTitle:title backImage:normalImageName pressBackImage:normalImageName frame:frame];
}

+ (CCButton *)createWithTitle:(NSString *)title backImage:(NSString *)normalImageName pressBackImage:(NSString *)pressImageName frame:(CGRect)frame
{
    CCButton *button = [CCButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button alterNormalTitle:title];
    [button alterNormalBackgroundImage:normalImageName];
    [button alterPressBackgroundImage:pressImageName];
    return button;
}

- (void)alterFontSize:(CGFloat)fontSize
{
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)alterFontUseBoldWithSize:(CGFloat)fontSize
{
    self.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
}

- (void)alterNormalBackgroundImage:(NSString *)imgeName
{
    [self setBackgroundImage:[UIImage imageNamed:imgeName] forState:UIControlStateNormal];
}

- (void)alterNormalTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)alterPressBackgroundImage:(NSString *)imgeName
{
    [self setBackgroundImage:[UIImage imageNamed:imgeName] forState:UIControlStateHighlighted];
}

- (void)alterNormalTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)alterPressTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

- (void)addAction:(SEL)action runTarget:(id)target
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

UIKIT_EXTERN CCButton *CCButtonCreateWithFrame(CGRect frame)
{
    return [CCButton createWithFrame:frame];
}

UIKIT_EXTERN CCButton *CCButtonCreateWithValue(CGRect frame,SEL action,id target)
{
    CCButton *button = [CCButton createWithFrame:frame];
    [button addAction:action runTarget:target];
    return button;
}
@end
