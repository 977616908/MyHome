//
//  RoutingCell.m
//  RoutingTest
//
//  Created by HXL on 15/5/18.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "FontprintCell.h"

@interface FontprintCell()

@property(nonatomic,weak)IBOutlet UIView *leftView;
@property(nonatomic,weak)IBOutlet UIView *rightView;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgTap;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lbPrice;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lbDisPrice;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lbCount;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lbDate;
- (IBAction)onClick:(id)sender;

@end

@implementation FontprintCell

+(instancetype)cellWithTarget:(id)target tableView:(UITableView *)tableView{
    static NSString *ID=@"FontprintCell";
    FontprintCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[FontprintCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSString *price=((UILabel*)self.lbDisPrice[0]).text;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:price];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, [price length])];
    for (UILabel *label in self.lbDisPrice) {
        [label setAttributedText:attri];
    }
    if (_isDouble) {
        self.leftView.hidden=NO;
        self.rightView.hidden=YES;
    }else{
        self.leftView.hidden=YES;
        self.rightView.hidden=NO;
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self=[[NSBundle mainBundle]loadNibNamed:@"FontprintCell" owner:nil options:nil][0];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onClick:(id)sender {
    PSLog(@"---%d---",[sender tag]);
}
@end
