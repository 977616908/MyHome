//
//  AUICubeMenu.m
//  TestCubeMenu
//
//  Created by AlimysoYang on 13-4-11.
//  Copyright (c) 2013年 AlimysoYang. All rights reserved.
//

#import "CubeImageView.h"
#import <QuartzCore/QuartzCore.h>

#define DEFAULTIMAGE @""

@implementation CubeImageView

@synthesize isChange = _isChange;
@synthesize imageFrist = _imageFrist;
@synthesize imageSecond = _imageSecond;
@synthesize imageThird = _imageThird;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        CGRect rect = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        
        //第一张图片
        self.imageFrist = [[UIImageView alloc] initWithFrame:rect];
        self.imageFrist.tag = 100;
        self.imageFrist.image = [UIImage imageNamed:DEFAULTIMAGE];
        [self addSubview:self.imageFrist];
        
        //第二张图片
        self.imageSecond = [[UIImageView alloc] initWithFrame:rect];
        self.imageSecond.tag = 101;
        self.imageSecond.image = [UIImage imageNamed:DEFAULTIMAGE];
        [self addSubview:self.imageSecond];
        
        //第三张图片
        self.imageThird = [[UIImageView alloc] initWithFrame:rect];
        self.imageThird.tag = 102;
        self.imageThird.image = [UIImage imageNamed:DEFAULTIMAGE];
        self.imageThird.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imageThird];
        
        [self addAction:@selector(startCubeAnimation) runTarget:self];
    }
    return self;
}

- (UIImage *)getImage
{
    return self.imageSecond.image;
}

- (void)setImage:(UIImage *)image
{
    if(image == nil)
        return;
    if(self.isChange)
        return;
    
    self.imageSecond.image = image;
    self.isChange = YES;
    
    [self cubeAnimation:101];
}

- (void)startCubeAnimation
{
    [self cubeAnimation:101];
}

- (void)setDefaultImage:(UIImage *)image
{
    self.imageFrist.image = image;
    self.imageSecond.image = image;
    self.imageThird.image = image;
}

- (void)cubeAnimation:(int)tag
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.8;
    animation.type = @"cube";
    animation.subtype = kCATransitionFromRight;

    if (tag==100)
        [self bringSubviewToFront:self.imageFrist];
    else if (tag==101)
        [self bringSubviewToFront:self.imageSecond];
    else if (tag ==102)
        [self bringSubviewToFront:self.imageThird];
    [self.layer addAnimation:animation forKey:@"animation"];
}

@end
