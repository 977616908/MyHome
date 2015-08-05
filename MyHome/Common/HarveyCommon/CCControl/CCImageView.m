//
//  Created by Harvey on 13-5-30.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import "CCImageView.h"

@implementation CCImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CCImageView *)createWithImage:(NSString *)imageName frame:(CGRect)frame
{
    CCImageView *imageView = [[CCImageView alloc] initWithFrame:frame];
    [imageView alertImage:imageName];
    return imageView;
}

UIKIT_EXTERN id CCImageViewCreateWithNewValue(NSString *imageName,CGRect frame)
{
    return [CCImageView createWithImage:imageName frame:frame];
}


#pragma mark mark: 更改属性

- (void)addAction:(SEL)action runTarget:(id)target
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

- (void)alertImage:(NSString *)imageName
{
    self.image = [UIImage imageNamed:imageName];
}

- (void)alertLeftCapWidth:(NSInteger)wPix topCapHeight:(NSInteger)hPix
{
    [self.image stretchableImageWithLeftCapWidth:wPix topCapHeight:hPix];
}

@end
