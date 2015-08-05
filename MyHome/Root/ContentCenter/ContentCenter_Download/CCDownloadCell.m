//
//  CCDownloadCell.m
//  MyHome
//
//  Created by Harvey on 14-5-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CCDownloadCell.h"

@implementation CCDownloadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self=[[NSBundle mainBundle]loadNibNamed:@"CCDownloadCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)doAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.38];
    
    self.arrowImage.transform = CGAffineTransformIdentity;
    self.arrowImage.transform = CGAffineTransformMakeRotation(3.14);
    
    [UIView commitAnimations];
    PSLog(@"animtaon");
}

- (void)resetAnimation
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.38];
    self.arrowImage.transform = CGAffineTransformIdentity;
    self.arrowImage.transform = CGAffineTransformMakeRotation(radian(0));
    [UIView commitAnimations];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



@implementation CCActionCell

- (IBAction)userAction:(UIButton *)sender
{
    if (self.userClickAction) {
        
        self.userClickAction(sender.tag);
    }
}



@end



@implementation CCDownloadItem


@end