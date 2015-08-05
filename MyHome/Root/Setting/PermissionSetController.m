//
//  NetSaveViewController.m
//  MyHome
//
//  Created by HXL on 15/3/13.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "PermissionSetController.h"

@interface PermissionSetController ()



@end

@implementation PermissionSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self createView];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden=YES;
}


-(void)createNav{
    CGFloat gh=0;
    if (is_iOS7()) {
        gh=20;
    }
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, gh, 80, 44) backgroundColor:[UIColor clearColor]];
    [navTopView addSubview:CCImageViewCreateWithNewValue(@"ht_return", CGRectMake(10, 11.75, 12, 20.5))];
    NSString *prasentTitle  = @"返回";
    CCButton *btnBack = CCButtonCreateWithValue(CGRectMake(25, 0, 40,44), @selector(exitCurrentController), self);
    [btnBack alterNormalTitle:prasentTitle];
    [btnBack alterNormalTitleColor:RGBWhiteColor()];
    [btnBack alterFontSize:18];
    [navTopView addSubview:btnBack];
    [self.view addSubview:navTopView];

}


- (void)createView{
    CGFloat gh=0;
    if (is_iOS7()) {
        gh=20;
    }

    //    UIView *bgView=[];
    CCImageView *image=CCImageViewCreateWithNewValue(@"hm_quxian", CGRectMake(105, 100+gh, 118, 118));
    [self.view addSubview:image];
    
    CCLabel *lbTitle=CCLabelCreateWithNewValue(@"此应用程序没有权限来访问:", 20.0f, CGRectMake(30,CGRectGetMaxY(image.frame)+30, 260, 30));
    lbTitle.backgroundColor=[UIColor clearColor];
    [lbTitle setTextColor:[UIColor whiteColor]];
    [self.view addSubview:lbTitle];
    
    CCLabel *lbContent=CCLabelCreateWithNewValue(@"您的照片或视频", 20.0f, CGRectMake(30,CGRectGetMaxY(lbTitle.frame), 260, 30));
    lbContent.backgroundColor=[UIColor clearColor];
    [lbContent setTextColor:[UIColor whiteColor]];
    lbContent.textAlignment=NSTextAlignmentCenter;
    if (_tipDetail&&![_tipDetail isEqualToString:@""])lbContent.text=_tipDetail;
    [self.view addSubview:lbContent];
    
    CCLabel *lbTips=CCLabelCreateWithNewValue(@"您可以在“隐私设置”中启用访问", 18.0f, CGRectMake(30,CGRectGetMaxY(lbContent.frame)+20, 260, 30));
    lbTips.backgroundColor=[UIColor clearColor];
    [lbTips setTextColor:[UIColor whiteColor]];
    [self.view addSubview:lbTips];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.hidden=NO;
}

@end
