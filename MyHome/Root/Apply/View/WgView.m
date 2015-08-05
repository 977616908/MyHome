//
//  WgView.m
//  MyHome
//
//  Created by HXL on 15/6/24.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "WgView.h"

@implementation WgView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"ContentView" owner:nil options:nil];
        if(ScreenWidth()<=480){
           self=array[2];
        }else{
           self=array[0];
        }
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect bgFrame=self.bgView.frame;
    bgFrame.origin.x=self.moveX;
    self.bgView.frame=bgFrame;
}

@end
