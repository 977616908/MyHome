//
//  VideoAndMusicGridCell.m
//  MyHome
//
//  Created by Harvey on 14-7-30.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "VideoAndMusicGridCell.h"

@implementation VideoAndMusicGridCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CCImageView *imageView = CCImageViewCreateWithNewValue(@"", CGRectMake(35, 5, 80, 80));
        _filePreview=imageView;
        [self addSubview:imageView];
        
        CCLabel *label = CCLabelCreateWithNewValue(@"", 13, CGRectMake(5, 90, CGRectGetWidth(self.frame)-10, 20));
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines=0;
//        [label alterFontColor:[UIRGB colorWithHexColor:@"#c8c8c8"]];
        label.textColor=RGBCommon(38, 38, 38);
        _fileName=label;
        [self addSubview:label];
        
    }
    return self;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end




