//
//  SDWebImageManager+MJ.m
//  FingerNews
//
//  Created by mj on 13-9-23.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "SDWebImageManager+MJ.h"
#import "UIImageView+WebCache_HW.h"
@implementation SDWebImageManager (MJ)
+ (void)downloadWithURL:(NSURL *)url
{
    // cmp不能为空
    [[self sharedManager] downloadWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        
    }];

}

+ (void)downloadWithImageView:(UIImageView *)imageView url:(NSURL *)url{
    NSData *data=[NSData dataWithContentsOfURL:url];
    UIImage *img=[UIImage imageWithData:data];
    CGFloat wh=img.size.width/320;
    PSLog(@"-%f--%f---%f",wh,img.size.width,img.size.height);
    [[self sharedManager] downloadWithURL:url
                                  options:0 width:img.size.width/wh height:img.size.height/wh
                                 progress:nil
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
     {
         if (image)
         {
             imageView.image = image;
         }
     }];
}
@end
