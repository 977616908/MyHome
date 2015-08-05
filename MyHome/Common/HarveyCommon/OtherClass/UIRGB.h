//
//  UIRGB.h
//  HarveySDK
//
//  Created by Harvey on 13-10-12.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIRGB : NSObject

/// 获取UIColor实例; red, green, blue最大值为255, 最小值为0; 透明度为1(不透明).
UIKIT_EXTERN UIColor *RGBCommon(NSInteger red, NSInteger green, NSInteger blue);// default is 1 of alpha

/// 获取UIColor实例; red、green、blue最大值为255, 最小值为0; alpha为透明度, 最大值为1, 最小值为0.
UIKIT_EXTERN UIColor *RGBAlpha(NSInteger red, NSInteger green, NSInteger blue,float alpha);

/// 从十六进制获取颜色
+(UIColor *) colorWithHexColor:(NSString *)hexColor;

/// 从十六进制获取颜色
UIKIT_EXTERN UIColor *RGBFromHexColor(NSString *hexColor);

/// 从一张图片获取颜色
+ (UIColor *)colorFromImage:(NSString *)imageName;

/// 黑色
UIKIT_EXTERN UIColor *RGBBlackColor();      // 0.0 white
UIKIT_EXTERN UIColor *RGBDarkGrayColor();   // 0.333 white
UIKIT_EXTERN UIColor *RGBLightGrayColor();  // 0.667 white
UIKIT_EXTERN UIColor *RGBWhiteColor();      // 1.0 white
UIKIT_EXTERN UIColor *RGBGrayColor();       // 0.5 white
UIKIT_EXTERN UIColor *RGBRedColor();        // 1.0, 0.0, 0.0 RGB
UIKIT_EXTERN UIColor *RGBGreenColor();      // 0.0, 1.0, 0.0 RGB
UIKIT_EXTERN UIColor *RGBBlueColor();       // 0.0, 0.0, 1.0 RGB
UIKIT_EXTERN UIColor *RGBCyanColor();       // 0.0, 1.0, 1.0 RGB
UIKIT_EXTERN UIColor *RGBYellowColor();     // 1.0, 1.0, 0.0 RGB
UIKIT_EXTERN UIColor *RGBMagentaColor();    // 1.0, 0.0, 1.0 RGB
UIKIT_EXTERN UIColor *RGBOrangeColor();     // 1.0, 0.5, 0.0 RGB
UIKIT_EXTERN UIColor *RGBPurpleColor();     // 0.5, 0.0, 0.5 RGB
UIKIT_EXTERN UIColor *RGBBrownColor();      // 0.6, 0.4, 0.2 RGB
UIKIT_EXTERN UIColor *RGBClearColor();      // 0.0 white, 0.0 alpha

@end
