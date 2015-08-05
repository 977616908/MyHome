//
//  CEButton.m
//  MyHome
//
//  Created by HXL on 15/5/21.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CEButton.h"

@implementation CEButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        // 字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        // 文字颜色
        [self setTitleColor:RGBCommon(143, 143, 148) forState:UIControlStateNormal];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)setTitleName:(NSString *)name{
    [self setTitle:name forState:UIControlStateNormal];
}

-(void)setImageName:(NSString *)name{
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    return CGRectMake(imageW-50, 10, 50, 50);
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(0, 0, titleW, titleH);
}

@end
