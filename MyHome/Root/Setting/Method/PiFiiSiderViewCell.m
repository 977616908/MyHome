//
//  PiFiiSiderViewCell.m
//  MyHome
//
//  Created by Harvey on 14-5-13.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "PiFiiSiderViewCell.h"

@implementation PiFiiSiderViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



@implementation PiFiiSiderViewItem

@end



@implementation PiFiiSiderGridCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    _appIco = CCImageViewCreateWithNewValue(@"", CGRectMake(27, 8, 30, 30));
    [self addSubview:_appIco];
    
    _appName = CCLabelCreateWithNewValue(@"", 12, CGRectMake(0, 38, 85, 25));
    [_appName alterFontColor:RGBCommon(143, 211, 244)];
    _appName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_appName];
}

@end



@implementation PiFiiSiderGridItem

@end



