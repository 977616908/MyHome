//
//  CollectionViewCell.m
//  collectionView
//
//  Created by shikee_app05 on 14-12-10.
//  Copyright (c) 2014年 shikee_app05. All rights reserved.
//

#import "ImagsCell.h"

@implementation ImagsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgImg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 72, 72)];
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(frame), CGRectGetHeight(bgImg.frame))];
        self.imgView.image=[UIImage imageNamed:@"hm_tupian"];
        [bgImg addSubview:self.imgView];
        
        self.selectImg=[[UIImageView alloc]init];
        UIImage *image=@"ImageSelectedOn".imageInstance;
        CGSize size=image.size;
        self.selectImg.frame=CGRectMake(CGRectGetWidth(self.imgView.frame)-size.width, CGRectGetHeight(self.imgView.frame)-size.height, size.width, size.height);
        self.selectImg.image=image;
        self.selectImg.hidden=YES;
        [bgImg addSubview:self.selectImg];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(6, -4, 28,31);
        [self.btn setBackgroundImage:[UIImage imageNamed:@"hm_dizi"] forState:UIControlStateNormal];
        [self.btn setTitle:@"已选择" forState:UIControlStateNormal];
        self.btn.titleEdgeInsets=UIEdgeInsetsMake(0, -1, 0, 0);
        self.btn.titleLabel.font=[UIFont systemFontOfSize:12];
        [bgImg addSubview:self.btn];
        self.btn.hidden=YES;
        [self addSubview:bgImg];
        
        
        
        UIView *bgVedio=[[UIView alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(self.imgView.frame)-16, CGRectGetWidth(self.imgView.frame), 18)];
        bgVedio.hidden=YES;
        bgVedio.backgroundColor=[UIColor clearColor];
        self.txtDuration=[[UILabel alloc]initWithFrame:CGRectMake(0, 4, CGRectGetWidth(bgVedio.frame)-5, 12)];
        self.txtDuration.backgroundColor=[UIColor clearColor];
        self.txtDuration.textColor = [UIColor whiteColor];
        self.txtDuration.textAlignment = NSTextAlignmentRight;
        self.txtDuration.font=[UIFont systemFontOfSize:12.0f];
        [bgVedio addSubview:self.txtDuration
         ];
        self.bgVedio=bgVedio;
        UIImageView *imgVedio=[[UIImageView alloc]initWithFrame:CGRectMake(5, 4, 14, 14)];
        imgVedio.image=[UIImage imageNamed:@"hm_vedio"];
        [bgVedio addSubview:imgVedio];
        [self addSubview:bgVedio];
        
        self.text = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(bgImg.frame)+5, CGRectGetWidth(bgImg.frame), 18)];
        self.text.backgroundColor=RGBCommon(209, 231, 238);
        self.text.textColor = RGBCommon(56, 56, 56);
        self.text.textAlignment = NSTextAlignmentCenter;
        self.text.font=[UIFont systemFontOfSize:13.0f];
        self.text.hidden=YES;
        [self addSubview:self.text];
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
