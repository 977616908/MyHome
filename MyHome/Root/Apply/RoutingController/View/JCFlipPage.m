//
//  JCFlipPage.m
//  JCFlipPageView
//
//  Created by ThreegeneDev on 14-8-8.
//  Copyright (c) 2014年 JimpleChen. All rights reserved.
//

#import "JCFlipPage.h"
#import "RoutingImagsController.h"
@interface JCFlipPage ()

@property(nonatomic,weak)UILabel *lbDate;

@end

@implementation JCFlipPage
@synthesize reuseIdentifier = _reuseIdentifier;

- (void)dealloc
{
}

- (void)prepareForReuse
{
    
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _reuseIdentifier = reuseIdentifier;
        
//        UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test"]];
//        image.bounds=self.bounds;
//        [self addSubview:image];
//
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)-80)];
        bgView.backgroundColor=[UIColor clearColor];
        
        CCLabel *lbMsg=CCLabelCreateWithNewValue(@"重新批量选图将清空相册中原有照片", 14.0f, CGRectMake(45, 0, CGRectGetWidth(bgView.frame)-90, 40));
        lbMsg.numberOfLines=0;
        lbMsg.textAlignment=NSTextAlignmentCenter;
        lbMsg.textColor=RGBCommon(143, 120, 90);
        [bgView addSubview:lbMsg];
        
        CCButton *btnSelect=CCButtonCreateWithValue(CGRectMake(CGRectGetWidth(bgView.frame)/2-40, CGRectGetMaxY(lbMsg.frame)+15, 100, 34), @selector(onSelectClick:), self);
        [btnSelect alterNormalTitle:@"批量选图"];
        btnSelect.backgroundColor=RGBCommon(143, 120, 90);
        [bgView addSubview:btnSelect];
        
        [self addSubview:bgView];
        NSString *scr=@"";
//        PSLog(@"[%f]--[%f]",ScreenHeight(),ScreenWidth());
        if (CGRectGetWidth(self.frame)<=480) {
            scr=@"960";
        }
        UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"rt_end%@",scr]];
        UIImageView *endImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
        endImg.image=img;
        self.endImg=endImg;
        endImg.hidden=YES;
        [self addSubview:endImg];
  
        UIImage *imgs=[UIImage imageNamed:[NSString stringWithFormat:@"rt_start%@",scr]];
        UIImageView *startImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-imgs.size.width, 0, imgs.size.width, imgs.size.height)];
        startImg.image=imgs;
        startImg.hidden=YES;
        self.startImg=startImg;
//        CCLabel *lbDate=CCLabelCreateWithNewValue(@"2016/6/20 - 2016/6/21", 11.0f, CGRectMake(0, CGRectGetHeight(startImg.frame)-50, CGRectGetWidth(startImg.frame), 20));
        
        UILabel *lbDate=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(startImg.frame)-50, CGRectGetWidth(startImg.frame), 20)];
        lbDate.textAlignment=NSTextAlignmentCenter;
        lbDate.backgroundColor=[UIColor clearColor];
//        NSString *fontName=[[NSBundle mainBundle]pathForResource:@"TUNGAB.TTF" ofType:nil];
        lbDate.font=[UIFont fontWithName:@"Helvetica" size:10.0f];
        lbDate.textColor=RGBCommon(167, 167, 167);
//        lbDate.text=@"2016/6/20 - 2016/6/21";
        lbDate.shadowColor = [UIColor colorWithWhite:0.1f alpha:0.1f];    //设置文本的阴影色彩和透明度。
        lbDate.shadowOffset = CGSizeMake(0.5, 0.5f);
        self.lbDate=lbDate;
        [startImg addSubview:lbDate];
        [self addSubview:startImg];
    }
    return self;
}

-(void)onSelectClick:(id)sendar{
    NSLog(@"onSelect---");
    [sendar setEnabled:NO];
    RoutingImagsController *imagsController=[[RoutingImagsController alloc]init];
//    [self.superController presentViewController:imagsController animated:YES completion:nil];
    imagsController.view.origin=CGPointMake(0, CGRectGetHeight(imagsController.view.frame));
    imagsController.pifiiDelegate=self.superController;
    [[self.superController view] addSubview:imagsController.view];
    [self.superController addChildViewController:imagsController];
    [UIView animateWithDuration:0.5 animations:^{
        imagsController.view.origin=CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        [sendar setEnabled:YES];
    }];
}

-(void)setDateStr:(NSString *)dateStr{
    _dateStr=dateStr;
    self.lbDate.text=_dateStr;
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
