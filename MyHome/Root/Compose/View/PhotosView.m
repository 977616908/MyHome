//
//  PhotosView.m
//  MyHome
//
//  Created by HXL on 15/5/20.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "PhotosView.h"

#define HEIGHT 72

@implementation PhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *addImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hm_zengjjiad"]];
        addImg.tag=-1;
        [self addSubview:addImg];
    }
    return self;
}

- (UIImageView *)addImage:(UIImage *)image duration:(NSString *)duration
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, HEIGHT, HEIGHT)];
    if (image) {
        imageView.image = image;
    }else{
        imageView.image=[UIImage imageNamed:@"hm_tupian"];
    }
    if (duration&&![duration isEqualToString:@""]) {
        UIView *bgVedio=[[UIView alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(imageView.frame)-16, CGRectGetWidth(imageView.frame), 16)];
        bgVedio.hidden=NO;
        bgVedio.backgroundColor=[UIColor clearColor];
        UILabel *txtDuration=[[UILabel alloc]initWithFrame:CGRectMake(0, 2, CGRectGetWidth(bgVedio.frame)-5, 12)];
        txtDuration.backgroundColor=[UIColor clearColor];
        txtDuration.textColor = [UIColor whiteColor];
        txtDuration.textAlignment = NSTextAlignmentRight;
        txtDuration.font=[UIFont systemFontOfSize:12.0f];
        txtDuration.text=duration;
        [bgVedio addSubview:txtDuration
         ];
        UIImageView *imgVedio=[[UIImageView alloc]initWithFrame:CGRectMake(5, 1, 14, 14)];
        imgVedio.image=[UIImage imageNamed:@"hm_vedio"];
        [bgVedio addSubview:imgVedio];
        [imageView addSubview:bgVedio];
    }
    [self addSubview:imageView];
    return imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    int maxColumns = 4; // 一行最多显示4张图片
    CGFloat margin = (self.frame.size.width - maxColumns * HEIGHT) / (maxColumns + 1);
    for (int i = 0; i<count; i++) {
        UIImageView *imageView = self.subviews[i];
        if(imageView.tag!=-1)imageView.tag=i;
        CGFloat imageViewX = margin + ((i-1) % maxColumns) * (HEIGHT + margin);
        CGFloat imageViewY = ((i-1) / maxColumns) * (HEIGHT + margin);
        imageView.frame = CGRectMake(imageViewX, imageViewY, HEIGHT, HEIGHT);
        imageView.userInteractionEnabled=YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onAddTap:)]];
    }
    CGFloat imageViewX = margin + ((count-1) % maxColumns) * (HEIGHT + margin);
    CGFloat imageViewY = ((count-1) / maxColumns) * (HEIGHT + margin);
    ((UIImageView *)self.subviews[0]).frame=CGRectMake(imageViewX, imageViewY, HEIGHT, HEIGHT);
    ((UIImageView *)self.subviews[0]).hidden=_isAdd;
}

-(void)onAddTap:(UITapGestureRecognizer *)sendar{
    [self.delegate photosTapWithIndex:sendar.view.tag];
}

- (NSArray *)totalImages
{
    NSMutableArray *images = [NSMutableArray array];
    for (UIImageView *imageView in self.subviews) {
        if (imageView.tag!=-1) {
            [images addObject:imageView];
        }
    }
    return images;
}

@end
