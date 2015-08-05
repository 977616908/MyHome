//
//  PlayView.m
//  MyHome
//
//  Created by Harvey on 14-8-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backView = CCImageViewCreateWithNewValue(@"hm_hongsetup", CGRectMake(0, 0, 80, 80));
        self.backView.alpha = 0;
        [self addSubview:self.backView];
        
        self.preview = CCImageViewCreateWithNewValue(@"hm_xiaotu", CGRectMake(0, 0, 80, 80));
        [self addSubview:self.preview];
        
        self.title = CCLabelCreateWithNewValue(@"名字", 12, CGRectMake(0, 80, 80, 50));
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.numberOfLines = 2;
        [self.title alterFontColor:RGBAlpha(255, 255, 255, 1)];
        [self addSubview:self.title];
        
        
//        
//        NSString *key = @"transform.rotation.y";
//        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:key];
//        basicAnimation.toValue =  [NSNumber numberWithFloat: radian(135)];
//        basicAnimation.cumulative = YES;
//        basicAnimation.autoreverses = YES;
//        basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        [self.layer addAnimation:basicAnimation forKey:key];
       

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



@implementation MusicCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.pv = [[PlayView alloc] initWithFrame:CGRectMake(13, 100, 80, 130)];
        [self addSubview:self.pv];
    }
    return self;
}

@end



