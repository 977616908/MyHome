//
//  ImageCacher.m
//  AAPinChe
//
//  Created by Reese on 13-4-3.
//  Copyright (c) 2013年 Himalayas Technology&Science Company CO.,LTD-重庆喜玛拉雅科技有限公司. All rights reserved.
//  单例类

#import "ImageCacher.h"
@interface ImageCacher (){
    
}


@end

@implementation ImageCacher

static ImageCacher *defaultCacher=nil;
-(id)init
{
    if (defaultCacher) {
        return defaultCacher;
    }else
    {
        self =[super init];
        [self setFlip];
        return self;
    }
}

+(ImageCacher*)defaultCacher
{
    if (!defaultCacher) {

        defaultCacher=[[super allocWithZone:nil]init];
    }
    return defaultCacher;
    
}

+ (id)allocWithZone:(NSZone *)zone
{
    
    return [self defaultCacher];
}


-(void) setFade
{
    _type=kCATransitionFade;
    
}

-(void) setCube
{
   _type=@"cube";
}

-(void) setFlip
{
   _type= @"oglFlip";
}


-(void)cacheImage:(NSDictionary*)aDic
{
    NSString *paths=[aDic objectForKey:@"url"];
    if (isNIL(paths))return;
//    PSLog(@"-----%@----",aURL);
    NSURL *aURL;
    if ([paths hasPrefix:@"http://"]) {
        aURL=paths.urlInstance;
    }else{
        aURL=ROUTER_FILE_WHOLEDOWNLOAD(paths).encodedString.urlInstance;
    }
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    if (image==nil) {
        return;
    }
    UIView *view=[aDic objectForKey:@"imageView"];
    //判断view是否还存在 如果tablecell已经移出屏幕会被回收 那么什么都不用做，下次滚到该cell 缓存已存在 不需要执行此方法
    if (view!=nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            CATransition *transtion = [CATransition animation];
//            transtion.duration = 0.1;
//            [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//            [transtion setType:_type];
//            [transtion setSubtype:kCATransitionFromRight];
//            
//            [view.layer addAnimation:transtion forKey:@"transtionKey"];
            UIImage *showImg=[self imageByScalingAndCroppingForSize:CGSizeMake(CGRectGetWidth(view.frame)*2,CGRectGetHeight(view.frame)*2) sourceImage:image];
            [(UIImageView*)view setImage:showImg];
        });
   
    }
    
    NSValue *value=[aDic objectForKey:@"size"];
    UIImage *small;
    if(value){
        CGSize size=[value CGSizeValue];
        PSLog(@"--%f--%f",size.width,size.height);
        //        small=[self scaleImage:image size:CGSizeMake(size.width*2,size.height*2)];
        small=[self imageByScalingAndCroppingForSize:CGSizeMake(size.width*2,size.height*2) sourceImage:image];
    }else{
        small=[self scaleImage:image size:CGSizeMake(144, 144)];
    }
    if (!hasCachedImageWithString(paths)) {
        NSData *smallData=nil;
        if ([GlobalShare isHDPicture]) {
            smallData=UIImageJPEGRepresentation(small, 1);
        }else{
            smallData=UIImageJPEGRepresentation(small, 0.5);
        }
        if (smallData) {
            NSString *path=pathInCacheDirectory(@"com.pifii");
            NSFileManager *fileManager=[NSFileManager defaultManager];
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            NSString *pathUrl=pathForString(paths);
            
            [fileManager createFileAtPath:pathUrl contents:smallData attributes:nil];
            //        PSLog(@"--%@---%d--%d-",pathUrl,isFile,isWrite);
        }
    }
  
    
}

-(void)downImage:(NSString *)url{
    if (!hasCachedImageWithString(url)) {
        NSURL *aURL;
        if ([url hasPrefix:@"http://"]) {
            aURL=url.urlInstance;
        }else{
            aURL=ROUTER_FILE_WHOLEDOWNLOAD(url).encodedString.urlInstance;
        }
        NSData *data=[NSData dataWithContentsOfURL:aURL] ;
        UIImage *image=[UIImage imageWithData:data];
        UIImage *small=[self scaleImage:image size:CGSizeMake(144, 144)];
        NSData *smallData=UIImageJPEGRepresentation(small, 0.5);
        if (smallData) {
            NSString *path=pathInCacheDirectory(@"com.pifii");
            NSFileManager *fileManager=[NSFileManager defaultManager];
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            NSString *pathUrl=pathForString(url);
            [fileManager createFileAtPath:pathUrl contents:smallData attributes:nil];
            //        PSLog(@"--%@---%d--%d-",pathUrl,isFile,isWrite);
        }
    }
}

-(UIImage*)scaleImage:(UIImage *)image size:(CGSize )size{
    CGSize imgSize = image.size; //原图大小
    CGSize viewSize = size;          //视图大小
    CGFloat imgwidth = 0;            //缩放后的图片宽度
    CGFloat imgheight = 0;          //缩放后的图片高度
    
    //视图横长方形及正方形
    if (viewSize.width >= viewSize.height) {
        //缩小
        if (imgSize.width > viewSize.width && imgSize.height > viewSize.height) {
            imgwidth = viewSize.width;
            imgheight = imgSize.height/(imgSize.width/imgwidth);
        }
        //放大
        if(imgSize.width < viewSize.width){
            imgwidth = viewSize.width;
            imgheight = (viewSize.width/imgSize.width)*imgSize.height;
        }
        //判断缩放后的高度是否小于视图高度
        imgheight = imgheight < viewSize.height?viewSize.height:imgheight;
    }
    
    //视图竖长方形
    if (viewSize.width < viewSize.height) {
        //缩小
        if (imgSize.width > viewSize.width && imgSize.height > viewSize.height) {
            imgheight = viewSize.height;
            imgwidth = imgSize.width/(imgSize.height/imgheight);
        }
        
        //放大
        if(imgSize.height < viewSize.height){
            imgheight = viewSize.width;
            imgwidth = (viewSize.height/imgSize.height)*imgSize.width;
        }
        //判断缩放后的高度是否小于视图高度
        imgwidth = imgwidth < viewSize.width?viewSize.width:imgwidth;
    }
    
    //重新绘制图片大小
    UIImage *i;
    UIGraphicsBeginImageContext(CGSizeMake(imgwidth, imgheight));
    [image drawInRect:CGRectMake(0, 0, imgwidth, imgheight)];
    i=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //截取中间部分图片显示
    if (imgwidth > 0) {
        CGImageRef newImageRef = CGImageCreateWithImageInRect(i.CGImage, CGRectMake((imgwidth-viewSize.width)/2, (imgheight-viewSize.height)/2, viewSize.width, viewSize.height));
        return [UIImage imageWithCGImage:newImageRef];
    }else{
        CGImageRef newImageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake((imgwidth-viewSize.width)/2, (imgheight-viewSize.height)/2, viewSize.width, viewSize.height));
        return [UIImage imageWithCGImage:newImageRef];
    }
}

#pragma -mark 按比例压缩图片
- (UIImage *) compressImage:(UIImage *)image sizewidth:(float)sizewidth
{
    if (image.size.width > sizewidth) {
        float scale = image.size.width / sizewidth;
        UIImage *imagetemp = [self imageByScalingAndCroppingForSize:CGSizeMake(image.size.width/scale, image.size.height/scale) sourceImage:image];
        return imagetemp;
    }
    return image;
}

- (UIImage *) compressImage:(UIImage *)image sizeheight:(float)sizeheight
{
    if (image.size.height > sizeheight) {
        float scale = image.size.height / sizeheight;
        UIImage *imagetemp = [self imageByScalingAndCroppingForSize:CGSizeMake(image.size.width/scale, image.size.height/scale) sourceImage:image];
        return imagetemp;
    }
    return image;
}

//压缩图片
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize sourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            if (_isCenter) {
               thumbnailPoint.y = (targetHeight - scaledHeight) * 0.2;
            }else{
               thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            }
            
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        PSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

@end
