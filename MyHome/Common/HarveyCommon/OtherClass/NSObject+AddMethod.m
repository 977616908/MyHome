//
//  NSObject+AddMethod.m
//  HarveySDK
//
//  Created by Harvey on 13-10-31.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import "NSObject+AddMethod.h"

@implementation NSObject (AddMethod)

- (void)arcRelease
{
#if !OS_OBJECT_USE_OBJC
    [self release];
#endif
}

- (id)arcRetain
{
#if !OS_OBJECT_USE_OBJC
   return [self retain];
#endif
    return self;
}

- (void)arcAutorelease
{
#if !OS_OBJECT_USE_OBJC
    [self autorelease];
#endif
}

FOUNDATION_EXPORT BOOL existParameterOnSEL(SEL action)
{
    NSString *selString = NSStringFromSelector(action);
    NSRange rang = [selString rangeOfString:@":"];
    if(rang.location < selString.length)
        return YES;
    return NO;
}

- (void)performSelector:(SEL)action withParameter:(id)para
{
    NSMethodSignature *method = [self methodSignatureForSelector:action];
    if(method) {
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:method];
        invocation.target = self;
        invocation.selector = action;
        
        if(existParameterOnSEL(action)) {
            [invocation setArgument:&para atIndex:2];
        }
        [invocation invoke];
    }
}

+ (id)defaultInit
{
    return [[self alloc] init];
}

FOUNDATION_EXPORT BOOL isNIL(id instance)
{
    if([instance isEqual:[NSNull null]]){
        return YES;
    }
    return instance==nil ? YES:NO;
}
FOUNDATION_EXPORT CGFloat radian(int angle)
{
    return angle/180.0*M_PI;
}
@end


@implementation UIImage (AddMethod_UIImage)

+ (UIImage*) drawGradientInRect:(CGSize)size withColors:(NSArray*)colors
{
    if(colors == nil) [NSException raise:@"传入了空数组" format:@"colors is nil"];
    if(![[NSString stringWithFormat:@"%@",[[colors lastObject] class]] isEqualToString:@"__NSCFType"]) [NSException raise:@"数组中储存的类型不正确" format:@"in method:%s,正确类型是:(CGColorRef *)",  __func__];

    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = nil;
    
    if(colors.count > 2) colorSpace = CGColorGetColorSpace((__bridge CGColorRef)([colors objectAtIndex:colors.count - 2]));
    else colorSpace = CGColorGetColorSpace((__bridge CGColorRef)[colors lastObject]);

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, NULL);
    //     CGContextClipToRect(context, rect);
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(0.0, size.height);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    
    UIGraphicsEndImageContext(); // Clean up
    return image;
}

+ (UIImage *)overlayWithSubImage:(UIImage *)subImg onContext:(UIImage *)cImg subImageSize:(CGSize)subSize
{
    UIGraphicsBeginImageContextWithOptions(cImg.size,NO,0);
    [cImg drawInRect:CGRectMake(0, 0, cImg.size.width, cImg.size.height)];
    [subImg drawInRect:CGRectMake((cImg.size.width - subSize.width)/2.0f, (cImg.size.height - subSize.height)/2.0f, subSize.width, subSize.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

+ (UIImage *)overlayWithSubImageName:(NSString *)subImgName onContext:(NSString *)cImgName subImageSize:(CGSize)subSize
{
    return [UIImage overlayWithSubImage:[UIImage imageNamed:subImgName] onContext:[UIImage imageNamed:cImgName] subImageSize:subSize];
}

+ (UIImage *)composeWithBase:(id)image subImage:(id)sImage inPosition:(CGRect)position
{
    if(!([image isKindOfClass:[UIImage class]] || [image isKindOfClass:[NSString class]])) {
        
        [NSException raise:@"参数类型不匹配" format:@"image的类型必须是(UIImage *)或者(NSString *)在%s",__func__];
    }
    if(!([sImage isKindOfClass:[UIImage class]] || [sImage isKindOfClass:[NSString class]])) {
        
        [NSException raise:@"参数类型不匹配" format:@"sImage的类型必须是(UIImage *)或者(NSString *)在%s",__func__];
    }
    
    UIImage *backImage = nil;
    UIImage *subImage = nil;
    
    if([image isKindOfClass:[NSString class]])
        backImage = [UIImage imageNamed:image];
    else backImage = image;
    
    if([sImage isKindOfClass:[NSString class]])
        subImage = [UIImage imageNamed:sImage];
    else subImage = sImage;
    
    if(!backImage || !subImage) {
        
        [NSException raise:@"图片不存在" format:@"image为空或者sImage为空在%s",__func__];
    }
    
    UIGraphicsBeginImageContextWithOptions(backImage.size,NO,0);
    [backImage drawInRect:CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
    [subImage drawInRect:position];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
@end


@implementation UIView(AddMethod_UIView)

- (void)addShowOffset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius color:(UIColor *)coclor
{
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    self.layer.shadowColor = coclor.CGColor;
}

- (void)startAnimationOfBorder
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationRepeatCount:INT32_MAX];
    [UIView setAnimationDuration:1];
    [UIView setAnimationRepeatAutoreverses:NO];
    self.layer.borderWidth = .1;
    self.layer.borderColor = RGBAlpha(255, 255, 255, 0.1).CGColor;
    [UIView commitAnimations];
    
}
@end


@implementation NSFileManager (AddMethod_NSFileManager)

+(long long int)calculateFileSizeWithPath:(NSString *)filePath
{
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
}

+ (long long int)calculateFolderSizeWithPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName = nil;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [NSFileManager calculateFileSizeWithPath:fileAbsolutePath];
    }
    return folderSize;
}

@end


@implementation NSString (AddMethod_NSString)

- (id)instance
{
    id classInstance = [NSClassFromString(self) new];
    return classInstance;
}

- (id)instanceWithFrame:(CGRect)frame
{
    id classInstance = [[NSClassFromString(self) alloc] initWithFrame:frame];
    return classInstance;
}

- (id)imageInstance
{
    return [UIImage imageNamed:self];
}

- (id)urlInstance
{
    return [NSURL URLWithString:self];
}

- (id)colorInstance
{
    return [UIColor colorWithPatternImage:[self imageInstance]];
}

- (NSData *)stringConvertData
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodedString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)self, NULL, NULL,  kCFStringEncodingUTF8 ));
}


@end


@implementation NSData (AddMethod_NSData)

- (NSString *)dataConvertString
{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end



@implementation NSDictionary (AddMethod_NSDictionary)

- (id)objectForKey_:(id)aKey
{
    
    return [self objectForKey:aKey]==[NSNull null] ? nil:[self objectForKey:aKey];
}

@end



@implementation NSNumber (Binary)

- (NSString *)binaryString
{
    NSMutableString *string = [NSMutableString string];
    NSInteger value = [self integerValue];
    while (value){
        
        [string insertString:(value & 1)? @"1": @"0" atIndex:0];
        value /= 2;
    }
    return string;
}

@end

