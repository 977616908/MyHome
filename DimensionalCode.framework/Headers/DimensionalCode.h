//
//  YYQDimensionalCode.h
//  BarcodeDemo
//
//  Created by Harvey on 13-10-15.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "qrencode.h"
#import "ZBarSDK.h"

@interface DimensionalCode : NSObject

+ (void)buildDimensionalCodeWithText:(NSString *)text size:(CGFloat)size completeBlock:(void (^)(UIImage *image))successBlock;

+ (void)buildDimensionalCodeWithText:(NSString *)text size:(CGFloat)size  QRecLevel:(QRecLevel)myQRecLevel  logoName:(NSString *)logoName logoSize:(CGSize)logoSize completeBlock:(void (^)(UIImage *image))successBlock;

+ (void)buildDimensionalCodeWithText:(NSString *)text size:(CGFloat)size  QRecLevel:(QRecLevel)myQRecLevel  logoImage:(UIImage *)logoImage logoSize:(CGSize)logoSize completeBlock:(void (^)(UIImage *image))successBlock;

+ (void)buildDimensionalCodeWithText:(NSString *)text size:(CGFloat)size  QRecLevel:(QRecLevel)myQRecLevel  logoData:(NSData *)logoData logoSize:(CGSize)logoSize completeBlock:(void (^)(UIImage *image))successBlock;


UIKIT_EXTERN NSString *DimensionalCodeAnalyzeWithDictionary(NSDictionary *info);
UIKIT_EXTERN NSString *DimensionalCodeAnalyzeWithZBarSymbolSet(ZBarSymbolSet *symbols);

+ (void)DimensionalCodeAnalyzeWithZBarSymbolSet:(ZBarSymbolSet *)symbols analyzeFinish:(void (^)(NSString *content,BOOL isRQCODE))myFinish;

@end
