//
//  UIRGB.m
//  HarveySDK
//
//  Created by Harvey on 13-10-12.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import "UIRGB.h"

@implementation UIRGB

UIKIT_EXTERN UIColor *RGBCommon(NSInteger red, NSInteger green, NSInteger blue)
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
}

UIKIT_EXTERN UIColor *RGBAlpha(NSInteger red, NSInteger green, NSInteger blue,float alpha)
{
     return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

UIKIT_EXTERN UIColor *RGBFromHexColor(NSString *hexColor)
{
    return [UIRGB colorWithHexColor:hexColor];
}

+ (UIColor *)colorFromImage:(NSString *)imageName
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
}

UIKIT_EXTERN UIColor *RGBBlackColor()
{
    return [UIColor blackColor];
}

UIKIT_EXTERN UIColor *RGBDarkGrayColor()
{
    return [UIColor darkGrayColor];
}

UIKIT_EXTERN UIColor *RGBLightGrayColor()
{
    return [UIColor lightGrayColor];
}

UIKIT_EXTERN UIColor *RGBWhiteColor()
{
    return [UIColor whiteColor];
}

UIKIT_EXTERN UIColor *RGBGrayColor()
{
    return [UIColor grayColor];
}

UIKIT_EXTERN UIColor *RGBRedColor()
{
    return [UIColor redColor];
}

UIKIT_EXTERN UIColor *RGBGreenColor()
{
    return [UIColor greenColor];
}

UIKIT_EXTERN UIColor *RGBBlueColor()
{
    return [UIColor blueColor];
}

UIKIT_EXTERN UIColor *RGBCyanColor()
{
    return [UIColor cyanColor];
}

UIKIT_EXTERN UIColor *RGBYellowColor()
{
    return [UIColor yellowColor];
}

UIKIT_EXTERN UIColor *RGBMagentaColor()
{
    return [UIColor magentaColor];
}

UIKIT_EXTERN UIColor *RGBOrangeColor()
{
    return [UIColor orangeColor];
}

UIKIT_EXTERN UIColor *RGBPurpleColor()
{
    return [UIColor purpleColor];
}

UIKIT_EXTERN UIColor *RGBBrownColor()
{
    return [UIColor brownColor];
}

UIKIT_EXTERN UIColor *RGBClearColor()
{
    return [UIColor clearColor];
}

+(UIColor *) colorWithHexColor:(NSString *)hexColor
{
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return RGBBlackColor();
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return RGBClearColor();
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    PSLog(@"R%d G%d B%d",r,g,b);
    return RGBCommon(r, g, b);
}

@end
