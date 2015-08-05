//
//  MJZoomingScrollView.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoLoadingView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
@interface MJPhotoView ()<SDWebImageManagerDelegate>
{
    BOOL _doubleTap;
    UIImageView *_imageView;
    MJPhotoLoadingView *_photoLoadingView;
    SDWebImageManager *manager;
    NSOperationQueue *queue;
    CCButton *btnPlayer;
}
@end

@implementation MJPhotoView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
		// 图片
		_imageView = [[UIImageView alloc] init];
//		_imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:_imageView];
        manager=[SDWebImageManager sharedManager];
        manager.delegate=self;
        // 进度条
        _photoLoadingView = [[MJPhotoLoadingView alloc] init];
    
		// 属性
		self.backgroundColor = [UIColor clearColor];
 

		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
      
        btnPlayer=CCButtonCreateWithValue(CGRectMake(0, -70, 70, 70), @selector(onPlayer), self);
        [btnPlayer alterNormalBackgroundImage:@"hm_bofansp"];
//

    }
    return self;
}

#pragma mark - photoSetter
- (void)setPhoto:(MJPhoto *)photo {
    _photo = photo;
//    btnPlayer.hidden=!photo.isVedio;
   
    PSLog(@"====加载图片===[%d]=",photo.isVedio);
    self.isPlay=NO;
    if (photo.isVedio){
        CGRect rect=[[UIScreen mainScreen]bounds];
        btnPlayer.center=CGPointMake(CGRectGetWidth(rect)/2, CGRectGetHeight(rect)/2);
        self.delegate = nil;
    }else{
        btnPlayer.center=CGPointMake(0, -70);
        self.delegate = self;
    }
    [self addSubview:btnPlayer];
    [self showImage];
}

-(void)onPlayer{
    PSLog(@"--onPlayer---");
    self.isPlay=YES;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
}

#pragma mark 显示图片
- (void)showImage
{
    [self photoStartLoad];
}

#pragma mark 开始加载图片
- (void)photoStartLoad
{
    if (_photo.image) {
        self.scrollEnabled = YES;
        _imageView.hidden=NO;
        _imageView.image = _photo.image;
        if (_photoLoadingView) {
            [_photoLoadingView removeFromSuperview];
        }
        [self adjustFrame];
    } else {
        self.scrollEnabled = NO;
        if(_isPhotoImg){
            [self showPhoneWithImage:_photo.url];
        }else{
            [self showNetWorkWithImage:_photo.url];
        }
    }
}

//加载显示相机图片
-(void)showPhoneWithImage:(NSURL *)url{
    // 直接显示进度条
    [_photoLoadingView showLoading];
    [self addSubview:_photoLoadingView];
    _imageView.hidden=YES;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:_photo.url resultBlock:^(ALAsset *asset)
     {
         //在这里使用asset来获取图片
         UIImage *image = [[UIImage alloc]initWithCGImage:[[asset  defaultRepresentation]fullScreenImage]];
         dispatch_async(dispatch_get_main_queue(), ^{
             if (image) {
                 _imageView.hidden=NO;
                 _imageView.image=image;
                 [self photoDidFinishLoadWithImage:image];
             }
         });
     }
            failureBlock:^(NSError *error)
     {
         _imageView.hidden=NO;
         UIImage *image=[UIImage imageNamed:[_photo.url path]];
         _imageView.image=image;
         [self photoDidFinishLoadWithImage:image];
     }];
}

#pragma mark -加载显示云图片
-(void)showNetWorkWithImage:(NSURL *)url{
    if ([manager diskImageExistsForURL:_photo.url]) {
        UIImage *image= [manager.imageCache imageFromDiskCacheForKey:[_photo.url absoluteString]];
        _imageView.hidden=NO;
        _imageView.image=image;
        [self photoDidFinishLoadWithImage:image];
    }
    else{
        _imageView.hidden=YES;
        // 直接显示进度条
        [_photoLoadingView showLoading];
        [self addSubview:_photoLoadingView];
        if (!_photo.isFast) {
            _photo.isFast=YES;
            PSLog(@"-----开始线程下图片-----");
            
            if (queue) {
                [queue cancelAllOperations];
                queue=nil;
            }
            queue=[[NSOperationQueue alloc]init];
            //                queue=[NSOperationQueue mainQueue];
            queue.maxConcurrentOperationCount=1;
            NSBlockOperation *block=[NSBlockOperation blockOperationWithBlock:^{
                [self downImageWithManager];
            }];
            [queue addOperation:block];
            //                [NSThread detachNewThreadSelector:@selector(downImageWithManager) toTarget:self withObject:nil];
        }
    }
}

-(void)downImageWithManager{
//    __weak MJPhotoView *photoView = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data=[NSData dataWithContentsOfURL:_photo.url];
        UIImage *img=[UIImage imageWithData:data];
        CGFloat count=1;
        if (img.size.width>640) {
            count=img.size.width/640;
        }
        CGFloat wh=img.size.width/count;
        CGFloat hg=img.size.height/count;
        PSLog(@"--%f--%f",wh,hg);
        [manager downloadWithURL:_photo.url options:0 width:wh height:hg progress:^(NSUInteger receivedSize, long long expectedSize) {
             dispatch_async(dispatch_get_main_queue(), ^{
                if (receivedSize > kMinProgress) {
                    _photoLoadingView.progress = (float)receivedSize/expectedSize;
                }
             });
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    _imageView.hidden=NO;
                    _imageView.image=image;
                    [self photoDidFinishLoadWithImage:image];
                }
             });
        }];
//    });
}

#pragma mark 加载完毕
- (void)photoDidFinishLoadWithImage:(UIImage *)image
{
    if (image) {
        self.scrollEnabled = YES;
        _photo.image = image;
        if (_photoLoadingView) {
            [_photoLoadingView removeFromSuperview];
        }
        if ([self.photoViewDelegate respondsToSelector:@selector(photoViewImageFinishLoad:)]) {
            [self.photoViewDelegate photoViewImageFinishLoad:self];
        }
    } else {
        [self addSubview:_photoLoadingView];
        [_photoLoadingView showFailure];
    }
    
    // 设置缩放比例
    [self adjustFrame];
}

#pragma mark 调整frame
- (void)adjustFrame
{
	if (_imageView.image == nil) return;
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width==0?1:imageSize.width;
    CGFloat imageHeight = imageSize.height==0?1:imageSize.height;
//    PSLog(@"%f--[%f]--[%f]--",self.origin.y,imageWidth,imageHeight);
	// 设置伸缩比例
    CGFloat widthRatio = boundsWidth/imageWidth;
    CGFloat heightRatio = boundsHeight/imageHeight;
    CGFloat minScale = (widthRatio > heightRatio) ? heightRatio : widthRatio;
    
    if (minScale >= 1) {
		minScale = 0.8;
	}
    
	CGFloat maxScale = 4.0;
    
//	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
//		maxScale = maxScale / [[UIScreen mainScreen] scale];
//	}
    
	self.maximumZoomScale = maxScale;
	self.minimumZoomScale = minScale;
	self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    // 宽大
    if ( imageWidth <= imageHeight &&  imageHeight <  boundsHeight ) {
        imageFrame.origin.x = floorf( (boundsWidth - imageFrame.size.width ) / 2.0) * minScale;
        imageFrame.origin.y = floorf( (boundsHeight - imageFrame.size.height ) / 2.0) * minScale;
    }else{
        imageFrame.origin.x = floorf( (boundsWidth - imageFrame.size.width ) / 2.0);
        imageFrame.origin.y = floorf( (boundsHeight - imageFrame.size.height ) / 2.0)-self.frame.origin.y;
    }

    
//    // y值
//    if (imageFrame.size.height < boundsHeight) {
//        
//        imageFrame.origin.y = floorf( (boundsHeight - imageFrame.size.height ) / 2.0) * minScale;
//        
////        imageFrame.origin.y = floorf( (boundsHeight - imageFrame.size.height ) / 2.0) * minScale;
//        
//	} else {
//        imageFrame.origin.y = 0;
//	}
    
    if (_photo.firstShow) { // 第一次显示的图片
        _photo.firstShow = NO; // 已经显示过了
        
        _imageView.frame = [_photo.srcImageView convertRect:_photo.srcImageView.bounds toView:nil];

        [UIView animateWithDuration:  0.3  animations:^{
            
            _imageView.frame = imageFrame;
        } completion:^(BOOL finished) {
            // 设置底部的小图片
            _photo.srcImageView.image = _photo.placeholder;
            [self photoStartLoad];
        }];
    } else {
        _imageView.frame = imageFrame;
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
	return _imageView;
}

// 让UIImageView在UIScrollView缩放后居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                            scrollView.contentSize.height * 0.5 + offsetY);
}


#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = NO;
    self.isPlay=NO;
    [self performSelector:@selector(hide) withObject:nil afterDelay:0.2];
//    [self hide];
}

- (void)hide
{
    if (_doubleTap) return;
    // 通知代理
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
        [self.photoViewDelegate photoViewSingleTap:self];
    }
}

- (void)reset
{
    _imageView.image = _photo.capture;
    _imageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    _doubleTap = YES;
    
    CGPoint touchPoint = [tap locationInView:self];
	if (self.zoomScale == self.maximumZoomScale) {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	} else {
		[self zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
	}
    
}

-(UIImage*)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL width:(NSInteger)w height:(NSInteger)h {
    //缩放图片
    // Create a graphics image context
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,w, h)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)dealloc
{
    // 取消请求
    [_imageView setImageWithURL:[NSURL URLWithString:@"file:///abc"]];
    PSLog(@"---delloc--");
    [queue cancelAllOperations];
    queue=nil;
}
@end