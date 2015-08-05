//
//  CCAnimationCollectionView.m
//  UIView3DAnimation
//
//  Created by Harvey on 14-3-10.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import "CCAnimationCollection.h"

@implementation CCAnimationCollection

 NSString * const AnimationTypeCube = @"cube";
 NSString * const AnimationTypeSuckEffect = @"suckEffect";
 NSString * const AnimationTypeOglFlip = @"oglFlip";
 NSString * const AnimationTypeRippleEffect = @"rippleEffect";
 NSString * const AnimationTypePageCurl = @"pageCurl";
 NSString * const AnimationTypePageUnCurl = @"pageUnCurl";
 NSString * const AnimationTypeCameraIrisHollowOpen = @"cameraIrisHollowOpen";
 NSString * const AnimationTypeCameraIrisHollowClose = @"cameraIrisHollowClose";
 NSString * const AnimationTypeFade = @"fade";
 NSString * const AnimationTypeMoveIn = @"moveIn";
 NSString * const AnimationTypePush = @"push";
 NSString * const AnimationTypeReveal = @"reveal";

 NSString * const AnimationSubTypeFromRight = @"fromRight";
 NSString * const AnimationSubTypeFromLeft = @"fromLeft";
 NSString * const AnimationSubTypeFromTop = @"fromTop";
 NSString * const AnimationSubTypeFromBottom = @"fromBottom";

CA_EXTERN CAMediaTimingFunction *TimingFunctionLinear() {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
}

CA_EXTERN CAMediaTimingFunction *TimingFunctionEaseIn() {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
}

CA_EXTERN CAMediaTimingFunction *TimingFunctionEaseOut() {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
}

CA_EXTERN CAMediaTimingFunction *TimingFunctionEaseInEaseOut() {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
}

CA_EXTERN CAMediaTimingFunction *TimingFunctionDefault() {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
}

 NSString * const FillModeRemoved = @"removed";
 NSString * const FillModeForwards = @"forwards";
 NSString * const FillModeBackwards =@"backwards";
 NSString * const FillModeBoth = @"both";

@end


@implementation UIView (Animation_UIView)

- (void)startEffectWithType:(NSString *)animationType subType:(NSString *)animationSubType timingFunction:(CAMediaTimingFunction *)timingFunction fillMode:(NSString *)fillMode
{
    [self startEffectWithType:animationType subType:animationSubType timingFunction:timingFunction fillMode:fillMode duration:.35];
}

- (void)startEffectWithType:(NSString *)animationType subType:(NSString *)animationSubType timingFunction:(CAMediaTimingFunction *)timingFunction fillMode:(NSString *)fillMode duration:(CFTimeInterval)duration
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = duration;
    animation.fillMode = fillMode;//must animation.removedOnCompletion = NO;
    animation.type = animationType;
    animation.removedOnCompletion = NO;
    animation.timingFunction = timingFunction;
    animation.subtype = animationSubType;
    [self.layer addAnimation:animation forKey:@"animation"];
}

- (void)startRo
{
    
    NSString *key = @"transform.rotation.z";
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:key];
    baseAnimation.duration = 10;
    baseAnimation.removedOnCompletion = NO;
    baseAnimation.timingFunction = TimingFunctionLinear();
    baseAnimation.fillMode = FillModeForwards;
    baseAnimation.toValue = [NSNumber numberWithFloat:M_PI*2];
    [self.layer addAnimation:baseAnimation forKey:key];
}

- (void)startEffectWithType:(NSString *)animationType
{
    //[self startEffectWithType:animationType subType:AnimationSubTypeFromRight timingFunction:TimingFunctionEaseInEaseOut() duration:1];
    [self startEffectWithType:animationType subType:AnimationSubTypeFromTop timingFunction:TimingFunctionLinear() fillMode:FillModeBoth duration:1];
}

- (void)startEffectWithType:(NSString *)animationType subType:(NSString *)animationSubType timingFunction:(CAMediaTimingFunction *)timingFunction
{
    [self startEffectWithType:animationType subType:animationSubType timingFunction:timingFunction duration:.35];
}

- (void)startEffectWithType:(NSString *)animationType subType:(NSString *)animationSubType timingFunction:(CAMediaTimingFunction *)timingFunction duration:(CFTimeInterval)duration
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = duration;
    animation.type = animationType;
    animation.timingFunction = timingFunction;
    animation.subtype = animationSubType;
    [self.layer addAnimation:animation forKey:@"animation"];
}

@end
