//
//  NSObject+AddMethod.h
//  HarveySDK
//
//  Created by Harvey on 13-10-31.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

@interface NSObject (AddMethod)

/// ARC项目中或手动内存管理项目中都可以使用
- (void)arcRelease;

/// ARC项目中或手动内存管理项目中都可以使用
- (id)arcRetain;

/// ARC项目中或手动内存管理项目中都可以使用
- (void)arcAutorelease;

/// 判断方法中是否含有参数
FOUNDATION_EXPORT BOOL existParameterOnSEL(SEL action);

/// 函数回调
- (void)performSelector:(SEL)action withParameter:(id)para;

/// 默认初始化, 相当于alloc
+ (id)defaultInit;

/// 判断一个对象是否为空
FOUNDATION_EXPORT BOOL isNIL(id instance);

/// 角度转弧度
FOUNDATION_EXPORT CGFloat radian(int angle);


@end


@interface UIImage (AddMethod_UIImage)

/// 创建一张颜色渐变的图片; size: 返回图片的的大小; cocors: 类型(NSArray *)，Objcet(CGColorRef *).
+ (UIImage*) drawGradientInRect:(CGSize)size withColors:(NSArray*)colors;

/// 合并subImg和cImg，cImg为背影图片，subImg在cImg中水平和垂直方向居中
+ (UIImage *)overlayWithSubImage:(UIImage *)subImg onContext:(UIImage *)cImg subImageSize:(CGSize)subSize;
+ (UIImage *)overlayWithSubImageName:(NSString *)subImgName onContext:(NSString *)cImgName subImageSize:(CGSize)subSize;

/// 合成一张图片; image: 为背景图片, 或者图片的名字; sImage为子图片, 或者图片的名字; position: 子图片在背景图片中的位. 
+ (UIImage *)composeWithBase:(id)image subImage:(id)sImage inPosition:(CGRect)position;

@end


@interface UIView (AddMethod_UIView)

/// 为view增加一圈阴影; offset: 阴影偏移量; opacity: 阴影透明度; radius: 阴影圆角数; coclor: 阴影的颜色
- (void)addShowOffset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius color:(UIColor *)coclor;
- (void)startAnimationOfBorder;

@end


@interface NSFileManager (AddMethod_NSFileManager)

/// 获取一个文件的字节数
+(long long int)calculateFileSizeWithPath:(NSString *)filePath;

/// 获取一个文件夹里面所有文件的字节数
+ (long long int)calculateFolderSizeWithPath:(NSString*) folderPath;

@end


@interface NSString (AddMethod_NSString)

/// ObjC反射, 返回一个类的对象
- (id)instance;
- (id)instanceWithFrame:(CGRect)frame;

/// 通过图片的名字返回UIImage实例
- (id)imageInstance;

/// 返回NSURL对象
- (id)urlInstance;

/// 返回UIColor对象
- (id)colorInstance;

/// (NSString *)转(NSData *),编码:NSUTF8StringEncoding
- (NSData *)stringConvertData;

/// 编码处理, 将字符串中的中文转为十六进制, 一般用于url编码
- (NSString *)encodedString;

@end


@interface NSData (AddMethod_NSData)

/// (NSData *)转(NSString *),编码:NSUTF8StringEncoding
- (NSString *)dataConvertString;

@end



@interface NSDictionary (AddMethod_NSDictionary)
/**
 *  使用该方法,当value是为[NSNull null]时,不会carsh
 *
 *  @param aKey 键
 *
 *  @return value
 */
- (id)objectForKey_:(id)aKey;
@end



@interface NSNumber (Binary)

- (NSString *)binaryString;

@end


