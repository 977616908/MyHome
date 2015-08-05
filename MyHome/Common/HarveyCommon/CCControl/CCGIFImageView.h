//
//  Created by Harvey on 13-5-30.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCGIFImageFrame : NSObject {
    
}
@property (nonatomic) double duration;
@property (nonatomic, retain) UIImage* image;

@end

@interface CCGIFImageView : UIImageView {
    NSInteger _currentImageIndex;
}
@property (nonatomic, retain) NSArray* imageFrameArray;
@property (nonatomic, retain) NSTimer* timer;

//Setting this value to pause or continue animation;
@property (nonatomic) BOOL animating;

/// gif图片的二进制
- (void)setData:(NSData*)imageData;

/// gif图片的名字, e.g mygif
- (void)setGIFImageWithImageName:(NSString *)imageName;

/// 通过url加载gif动画
- (void)setGIFImageWithURL:(NSString *)url;

@end
