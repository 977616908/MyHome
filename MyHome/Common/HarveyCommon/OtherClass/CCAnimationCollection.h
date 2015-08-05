//
//  CCAnimationCollectionView.h
//  UIView3DAnimation
//
//  Created by Harvey on 14-3-10.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCAnimationCollection : NSObject

#pragma mark -AnimationType

/// 立体效果
CA_EXTERN NSString * const AnimationTypeCube;
/// 渐渐缩小
CA_EXTERN NSString * const AnimationTypeSuckEffect;
/// 上下翻转
CA_EXTERN NSString * const AnimationTypeOglFlip;
/// 水波效果
CA_EXTERN NSString * const AnimationTypeRippleEffect;
///
CA_EXTERN NSString * const AnimationTypePageCurl;
///
CA_EXTERN NSString * const AnimationTypePageUnCurl;
///
CA_EXTERN NSString * const AnimationTypeCameraIrisHollowOpen;
///
CA_EXTERN NSString * const AnimationTypeCameraIrisHollowClose;
/// 渐渐消失
CA_EXTERN NSString * const AnimationTypeFade;
/// 覆盖进入
CA_EXTERN NSString * const AnimationTypeMoveIn;
/// 推出
CA_EXTERN NSString * const AnimationTypePush;
/// 与MoveIn相反
CA_EXTERN NSString * const AnimationTypeReveal;


#pragma mark -AnimationSubType

/// 动画从右边开始
CA_EXTERN NSString * const AnimationSubTypeFromRight;
/// 动画从左边开始
CA_EXTERN NSString * const AnimationSubTypeFromLeft;
/// 动画从顶部开始
CA_EXTERN NSString * const AnimationSubTypeFromTop;
/// 动画从底部开始
CA_EXTERN NSString * const AnimationSubTypeFromBottom;


#pragma mark -AnimationMode

/// 动画速度匀速
CA_EXTERN CAMediaTimingFunction *TimingFunctionLinear();
/// 淡入
CA_EXTERN CAMediaTimingFunction *TimingFunctionEaseIn();
/// 淡出
CA_EXTERN CAMediaTimingFunction *TimingFunctionEaseOut();
/// 淡入淡出
CA_EXTERN CAMediaTimingFunction *TimingFunctionEaseInEaseOut();
/// 默认
CA_EXTERN CAMediaTimingFunction *TimingFunctionDefault();


#pragma mark - fillMode
/// 动画结束layer恢复至动画前状态
CA_EXTERN NSString * const FillModeRemoved;
/// 动画结束layer保持动画结束时状态
CA_EXTERN NSString * const FillModeForwards;
/// 动画加入时layer立即进入动画初始状态
CA_EXTERN NSString * const FillModeBackwards;
/// 动画加入时layer立即进入动画初始状态, 结束时layer保持动画结束时状态
CA_EXTERN NSString * const FillModeBoth;

@end

@interface UIView (Animation_UIView)

/// animationType: 动画类型, animationSubType: 动画方向, timingFunction: 过度效果, fillMode: 动画模式  duration: 动画时间
- (void)startEffectWithType:(NSString *)animationType subType:(NSString *)animationSubType timingFunction:(CAMediaTimingFunction *)timingFunction fillMode:(NSString *)fillMode duration:(CFTimeInterval)duration;

/// animationType: 动画类型, animationSubType: 动画方向, timingFunction: 过度效果, fillMode: 动画模式, 动画时间: .35s
- (void)startEffectWithType:(NSString *)animationType subType:(NSString *)animationSubType timingFunction:(CAMediaTimingFunction *)timingFunction fillMode:(NSString *)fillMode;

/// animationType: 动画类型, animationSubType: 动画方向, timingFunction: 过度效果, duration: 动画时间
- (void)startEffectWithType:(NSString *)animationType subType:(NSString *)animationSubType timingFunction:(CAMediaTimingFunction *)timingFunction duration:(CFTimeInterval)duration;

/// animationType: 动画类型, animationSubType: 动画方向, timingFunction: 过度效果, 动画时间: .35s
- (void)startEffectWithType:(NSString *)animationType subType:(NSString *)animationSubType timingFunction:(CAMediaTimingFunction *)timingFunction;

@end



