//
//  CCView.m
//  HarveySDK
//
//  Created by Harvey on 13-10-12.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import "CCView.h"
#import <objc/runtime.h>

@interface CCView ()
{
    CGFloat passTime;
    CABasicAnimation* rotationAnimation;
    NSTimeInterval animationDuration;
    NSTimer *timerForAnimation;
    CGFloat angle;
}
@end

@implementation CCView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)viewLoad
{
    [self initBase];
    [self initStyle];
    [self addControl];
    [self HTTPRequest];
}

- (void)initBase
{
}

- (void)initStyle
{
}

- (void)addControl
{
}

- (void)HTTPRequest
{
}

+ (id)createWithFrame:(CGRect)frame
{
    
  return [[self alloc] initWithFrame:frame];
}

- (void)addAction:(SEL)action runTarget:(id)target
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

+ (id)createWithFrame:(CGRect)frame backgroundColor:(UIColor *)color
{
    UIView *v = [[self alloc] initWithFrame:frame];
    v.backgroundColor = color;
    return v;
}

#pragma mark mark: animation
- (void)startRotationAnimationWithDuration:(NSTimeInterval)duration
{
    rotationAnimation = nil;
    passTime = 0;
    timerForAnimation = nil;
    timerForAnimation = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addTimeForAnimation) userInfo:nil repeats:YES];
    animationDuration = duration;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0  - angle];
    rotationAnimation.fromValue = [NSNumber numberWithFloat: angle ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT32_MAX;
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopRotationAnimation
{
    [self.layer removeAllAnimations];
    [timerForAnimation invalidate];
    angle = [self calculateAnimationTime];
      self.transform = CGAffineTransformMakeRotation(angle);
}

- (void)addTimeForAnimation
{
    passTime += 0.1;
}

- (CGFloat)calculateAnimationTime
{
    int num = passTime / animationDuration;
    CGFloat var = (passTime - animationDuration*num) / animationDuration;
    return M_PI * 2.0*var;
}

@end
