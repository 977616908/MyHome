//
//  Created by Harvey on 13-5-30.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import "CCGIFImageView.h"
#import <ImageIO/ImageIO.h>

@implementation CCGIFImageFrame
@synthesize image = _image;
@synthesize duration = _duration;

- (void)dealloc
{
    [_image release];
    [super dealloc];
}

@end

@interface CCGIFImageView ()

- (void)resetTimer;

- (void)showNextImage;

@end

@implementation CCGIFImageView
@synthesize imageFrameArray = _imageFrameArray;
@synthesize timer = _timer;
@synthesize animating = _animating;

- (void)dealloc
{
    [self resetTimer];
    [_imageFrameArray release];
    [_timer release];
    [super dealloc];
}

- (void)resetTimer {
    if (_timer && _timer.isValid) {
        [_timer invalidate];
    }
    
    self.timer = nil;
}

- (void)setData:(NSData *)imageData {
    if (!imageData) {
        return;
    }
    [self resetTimer];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray* tmpArray = [NSMutableArray array];
    
    for (size_t i = 0; i < count; i++) {
        CCGIFImageFrame* gifImage = [[[CCGIFImageFrame alloc] init] autorelease];
        
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        gifImage.image = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
        NSDictionary* frameProperties = [(NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL) autorelease];
        gifImage.duration = [[[frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary] objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
        gifImage.duration = MAX(gifImage.duration, 0.01);
        
        [tmpArray addObject:gifImage];
        
        CGImageRelease(image);
    }
    CFRelease(source);
    
    self.imageFrameArray = nil;
    if (tmpArray.count > 1) {
        self.imageFrameArray = tmpArray;
        _currentImageIndex = -1;
        _animating = YES;
        [self showNextImage];
    } else {
        self.image = [UIImage imageWithData:imageData];
    }
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    [self resetTimer];
    self.imageFrameArray = nil;
    _animating = NO;
}

- (void)showNextImage {
    if (!_animating) {
        return;
    }
    
    _currentImageIndex = (++_currentImageIndex) % _imageFrameArray.count;
    CCGIFImageFrame* gifImage = [_imageFrameArray objectAtIndex:_currentImageIndex];
    [super setImage:[gifImage image]];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:gifImage.duration target:self selector:@selector(showNextImage) userInfo:nil repeats:NO];
}

- (void)setAnimating:(BOOL)animating {
    if (_imageFrameArray.count < 2) {
        _animating = animating;
        return;
    }
    
    if (!_animating && animating) {
        //continue
        _animating = animating;
        if (!_timer) {
            [self showNextImage];
        }
    } else if (_animating && !animating) {
        //stop
        _animating = animating;
        [self resetTimer];
    }
}

- (void)setGIFImageWithImageName:(NSString *)imageName
{
    [self setData:[[[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"gif"]] autorelease]];
}

- (void)setGIFImageWithURL:(NSString *)url
{
    NSString  *encodedURL = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)url, NULL, NULL,  kCFStringEncodingUTF8 ));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
         [self setData:[[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:encodedURL]] autorelease]];
    });
}

@end
