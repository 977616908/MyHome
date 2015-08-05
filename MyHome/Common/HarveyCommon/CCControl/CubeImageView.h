//
//  AUICubeMenu.h
//  TestCubeMenu
//
//  Created by AlimysoYang on 13-4-11.
//  Copyright (c) 2013年 AlimysoYang. All rights reserved.
//  QQ:86373007

#import <UIKit/UIKit.h>

@interface CubeImageView : CCImageView

@property (assign, nonatomic) BOOL isChange;
@property (strong, nonatomic) UIImageView *imageFrist;
@property (strong, nonatomic) UIImageView *imageSecond;
@property (strong, nonatomic) UIImageView *imageThird;

- (void)setDefaultImage:(UIImage *)image;

@end
