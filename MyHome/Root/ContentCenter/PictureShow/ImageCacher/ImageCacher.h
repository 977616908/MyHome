//
//  ImageCacher.h
//  AAPinChe
//
//  Created by Reese on 13-4-3.
//  Copyright (c) 2013年 Himalayas Technology&Science Company CO.,LTD-重庆喜玛拉雅科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ImageCacher : NSObject

@property (retain,nonatomic) NSString *type;
@property(nonatomic,assign) BOOL isCenter;
+(ImageCacher*)defaultCacher;
-(void)cacheImage:(NSDictionary*)aDic;
-(void)downImage:(NSString *)url;
-(void) setFlip;
-(void) setCube;
-(void) setFade;
- (UIImage*)scaleImage:(UIImage *)image size:(CGSize )size;
- (UIImage *) compressImage:(UIImage *)image sizewidth:(float)sizewidth;
- (UIImage *) compressImage:(UIImage *)image sizeheight:(float)sizeheight;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize sourceImage:(UIImage *)sourceImage;
@end
