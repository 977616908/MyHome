//
//  Created by Harvey on 13-5-30.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CCImageView : UIImageView

/// 获取CCImageView实例
+ (CCImageView *)createWithImage:(NSString *)imageName frame:(CGRect)frame;

/// 点击事件
- (void)addAction:(SEL)action runTarget:(id)target;

/// 设置图片
- (void)alertImage:(NSString *)imageName;

///  
- (void)alertLeftCapWidth:(NSInteger)wPix topCapHeight:(NSInteger)hPix;

/// 获取CCImageView实例
UIKIT_EXTERN id CCImageViewCreateWithNewValue(NSString *imageName,CGRect frame);

@end





