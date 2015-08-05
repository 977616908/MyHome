//
//  Created by Harvey on 13-5-30.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import "CCLabel.h"

@implementation CCLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CCLabel *)createWithText:(NSString *)text fontSize:(CGFloat)fontSize frame:(CGRect)frame
{
    return [CCLabel createWithText:text fontSize:fontSize frame:frame isBlod:NO];
}

+ (CCLabel *)createWithText:(NSString *)text blodFontSize:(CGFloat)fontSize frame:(CGRect)frame
{
    return [CCLabel createWithText:text fontSize:fontSize frame:frame isBlod:YES];
}

UIKIT_EXTERN CCLabel *CCLabelCreateWithNewValue(NSString *text,CGFloat fontSize,CGRect frame)
{
    return [CCLabel createWithText:text fontSize:fontSize frame:frame isBlod:NO];
}

UIKIT_EXTERN CCLabel *CCLabelCreateWithBlodNewValue(NSString *text,CGFloat fontSize,CGRect frame)
{
    return [CCLabel createWithText:text fontSize:fontSize frame:frame isBlod:YES];
}

+ (CCLabel *)createWithText:(NSString *)text fontSize:(CGFloat)fontSize frame:(CGRect)frame isBlod:(BOOL)yn
{
    CCLabel *label = [[self alloc] initWithFrame:frame];
    label.backgroundColor = RGBClearColor();
    if(yn) [label alterFontUseBlodWithSize:fontSize];
    else [label alterFontSize:fontSize];
    
    label.text = text;
    return label;
}

- (void)addAction:(SEL)action runTarget:(id)target
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tgr];
}

- (void)alterFontUseBlodWithSize:(CGFloat)fontSize
{
    self.font = [UIFont boldSystemFontOfSize:fontSize];
}

- (void)alterFontColor:(UIColor *)textColor
{
    self.textColor = textColor;
}

- (void)alterFontSize:(CGFloat)fontSize
{
    self.font = [UIFont systemFontOfSize:fontSize];
}

- (void)clearBackgroundColor
{
    self.backgroundColor = [UIColor clearColor];
}

@end
