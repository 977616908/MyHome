//
//  ImageAndDocumentCell.m
//  MyHome
//
//  Created by Harvey on 14-7-31.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ImageAndDocumentCell.h"

@implementation ImageAndDocumentCell

- (void)awakeFromNib
{
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self=[[NSBundle mainBundle]loadNibNamed:@"ImageAndDocumentCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
