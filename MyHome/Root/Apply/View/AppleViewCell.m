//
//  AppleViewCell.m
//  MyHome
//
//  Created by HXL on 15/8/21.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "AppleViewCell.h"

@interface AppleViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIImageView *bgIcon;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbStatue;
@property (weak, nonatomic) IBOutlet UILabel *lbMsg;
@property (weak, nonatomic) IBOutlet UIView *sxtBg;
@property (weak, nonatomic) IBOutlet UIImageView *sxtImg;
@property (weak, nonatomic) IBOutlet UIImageView *sxtStatue;

@property (nonatomic,strong)NSArray *arrStyle;
@end

@implementation AppleViewCell


+(instancetype)cellWithTableView:(UITableView *)table{
    static NSString *cellID=@"AppleID";
    AppleViewCell *cell=[table dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[AppleViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor=[UIColor clearColor];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self=[[NSBundle mainBundle]loadNibNamed:@"AppleViewCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setViewStyle:(NSInteger)styleTag{
    NSDictionary *style=self.arrStyle[styleTag];
    self.bgImg.image=[UIImage imageNamed:style[@"icon"]];
    self.lbTitle.textColor=style[@"color"];
    self.lbStatue.textColor=style[@"color"];
    
}

-(void)setState:(AppleStatue *)state{
    _state=state;
    [self setupData];
}


-(void)setupData{
    self.bgIcon.image=[UIImage imageNamed:_state.appIcon];
    self.lbTitle.text=_state.appTitle;
    if (_state.appTag==1) {
        self.lbMsg.hidden=YES;
    }else{
        self.sxtBg.hidden=YES;
        self.lbMsg.text=_state.appMsg;
    }
    
}

-(NSArray *)arrStyle{
    if (_arrStyle==nil) {
        NSDictionary *dict01=@{@"icon":@"mh_apply01",
                               @"color":RGBCommon(60, 197, 216)};
        NSDictionary *dict02=@{@"icon":@"mh_apply02",
                               @"color":RGBCommon(30, 199, 185)};
        _arrStyle=@[dict01,dict02];
    }
    return _arrStyle;
}

@end
