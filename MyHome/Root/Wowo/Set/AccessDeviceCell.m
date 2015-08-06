//
//  AccessDeviceCell.m
//  PiFiiHome
//
//  Created by Harvey on 14-5-10.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "AccessDeviceCell.h"

@implementation AccessDeviceCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _wifiLolo = CCImageViewCreateWithNewValue(@"", CGRectMake(18, 20, 70, 70));
        [self addSubview:_wifiLolo];
        
        _wifiName = CCLabelCreateWithNewValue(@"", 12, CGRectMake(10, 90, 86, 20));
        _wifiName.textAlignment = NSTextAlignmentCenter;
        _wifiName.textColor = RGBWhiteColor();
        [self addSubview:_wifiName];
    }
    return self;
}

@end


@implementation DeviceItem


@end