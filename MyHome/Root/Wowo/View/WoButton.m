//
//  WoButton.m
//  MyHome
//
//  Created by HXL on 15/5/20.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "WoButton.h"

@implementation WoButton

// 图标的比例
#define IWTabBarButtonImageRatio 0.6

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        // 图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        // 文字颜色
        [self setTitleColor:RGBCommon(52, 52, 52) forState:UIControlStateNormal];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)setImageName:(NSString *)name Title:(NSString *)title{
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
}

// 重写去掉高亮状态
- (void)setHighlighted:(BOOL)highlighted {}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * IWTabBarButtonImageRatio;
    return CGRectMake(0, 0, imageW, imageH);
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * IWTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}

@end
