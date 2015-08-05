//
//  FlashInView.m
//  PiFiiHome
//
//  Created by HXL on 14-5-13.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "BindView.h"
#import "CCTextField.h"

#define UNBINDHEIGHT 135
#define BINDHEIGHT 166
@interface BindView()

@property(nonatomic,weak)UIScrollView *moveView;
@property(nonatomic,weak)CCTextField *textPwd;
@property(nonatomic,weak)UIView *bindView;
@property(nonatomic,weak)UIView *unBindView;
@end
@implementation BindView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =RGBAlpha(0, 0, 0, 0.6);
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelfView)];
        [self addGestureRecognizer:tap];
        UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, CGRectGetHeight(self.frame))];
        _moveView=scrollView;
        [self addSubview:scrollView];
        [self createUnBind];
        [self createBind];
    }
    return self;
}

-(void)setIsBind:(BOOL)isBind{
    _bindView.hidden=isBind;
    _unBindView.hidden=!isBind;
    CGRect rootRect=_moveView.frame;
    if (isBind) {
        rootRect.origin.y=CGRectGetHeight(_unBindView.frame);
    }else{
        rootRect.origin.y=CGRectGetHeight(_bindView.frame);
    }
    _moveView.frame=rootRect;
}

-(void)createBind{
    UIView * childView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-BINDHEIGHT, 320 , BINDHEIGHT)];
    childView.backgroundColor=[UIColor whiteColor];
    CCButton *btnSao=CCButtonCreateWithValue(CGRectMake(129, 10, 62, 62), @selector(goBind:), self);
    btnSao.tag=1;
    [btnSao alterNormalBackgroundImage:@"hm_saosao"];
    [childView addSubview:btnSao];
    
    CCButton *btnType=CCButtonCreateWithFrame(CGRectMake(27, CGRectGetMaxY(btnSao.frame)+5, 266, 22));
    [btnType alterFontSize:16];
    [btnType alterNormalTitle:@"扫一扫"];
    [btnType alterNormalTitleColor:RGBCommon(68, 68, 68)];
    _btnScanner=btnType;
    [childView addSubview:btnType];
    
    CCButton *btnBind=CCButtonCreateWithValue(CGRectMake(22, CGRectGetHeight(childView.frame)-57, 266, 42), @selector(goBind:), self);
    btnBind.backgroundColor=RGBCommon(63, 205, 225);
    btnBind.tag=2;
    [btnBind alterFontSize:20];
    [btnBind alterNormalTitle:@"绑定"];
    [childView addSubview:btnBind];
    self.bindView=childView;
    [_moveView addSubview:childView];
}

-(void)createUnBind
{
    UIView * childView =[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-UNBINDHEIGHT, 320 , UNBINDHEIGHT)];
    childView.backgroundColor=[UIColor whiteColor];
    UIImageView *bgImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_hm_sruk"]];
    bgImage.frame=CGRectMake(22, 20, 266, 42);
    CCImageView *imgPwd=CCImageViewCreateWithNewValue(@"hm_miyao02", CGRectMake(10, 11, 12, 20));
    [bgImage addSubview:imgPwd];
    CGPoint point=bgImage.frame.origin;
    CCTextField *textPwd=[[CCTextField alloc]initWithFrame:CGRectMake(point.x+30,point.y+childView.frame.origin.y, 236, 42)];
    [textPwd setBackgroundColor:[UIColor clearColor]];
    textPwd.secureTextEntry=YES;
    textPwd.placeholder=@"登录密码";
    textPwd.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    self.textPwd=textPwd;
    [childView addSubview:bgImage];

    
    CCButton *btnBind=CCButtonCreateWithValue(CGRectMake(22, CGRectGetHeight(childView.frame)-62, 266, 42), @selector(goBind:), self);
    btnBind.backgroundColor=RGBCommon(63, 205, 225);
    btnBind.tag=3;
    [btnBind alterFontSize:20];
    [btnBind alterNormalTitle:@"解除绑定"];
    [childView addSubview:btnBind];
    [_moveView addSubview:childView];
    self.unBindView=childView;
    [_moveView addSubview:textPwd];
}

-(void)moveTransiton:(BOOL)isAnimation{
    self.hidden=NO;
    [UIView animateWithDuration:0.25 animations:^{
        if (isAnimation) {
            _moveView.transform=CGAffineTransformMakeTranslation(0, -_moveView.frame.origin.y);
        }else{
            _moveView.transform=CGAffineTransformIdentity;
        }
    }completion:^(BOOL finished) {
        self.hidden=!isAnimation;
    }];
}

- (void)hiddenSelfView
{
    self.type(0,nil);
}

-(void)goBind:(CCButton *)sendar
{
    NSString *pwd=nil;
    if (sendar.tag==3) {
        pwd=_textPwd.text?_textPwd.text:@"";
    }
    
    if (pwd&&pwd.length<6) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请正确登录密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        return;
    }
    self.type(sendar.tag,pwd);
    
}

@end
