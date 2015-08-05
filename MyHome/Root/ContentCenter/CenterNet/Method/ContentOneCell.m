//
//  ContentOneCell.m
//  MyHome
//
//  Created by HXL on 14-5-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ContentOneCell.h"

@implementation ContentOneCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      //  [self myloadview];
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
-(void)layoutSubviews{
   //   PSLog(@"cell-->%@",self.mymodel);
    UIView * cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    self.imageView1 =[[UIImageView alloc]initWithFrame:CGRectMake(50, 22, 60, 60)];
    self.imageView1.image = [UIImage imageNamed:self.mymodel.image1];
    
    [cellView addSubview:self.imageView1];
    self.label001 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView1.bottom+5, cellView.width, 20)];
    self.label001.backgroundColor = [UIColor clearColor];
    self.label001.text = self.mymodel.item1;
    self.label001.font =[UIFont systemFontOfSize:14.0f];
    self.label001.textColor = [UIColor grayColor];
    self.label001.textAlignment = NSTextAlignmentCenter;
    [cellView addSubview:self.label001];
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(cellView.right-0.5, 0, 0.5, cellView.height)];
    line1.backgroundColor = RGBCommon(215, 234, 240);
    
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, cellView.bottom-0.5, cellView.width, 0.5)];
    line2.backgroundColor = RGBCommon(215, 234, 240);
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line2];
    [self.contentView addSubview:cellView];
    
    
}
@end
