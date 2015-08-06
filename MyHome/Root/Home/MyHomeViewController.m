//
//  MyHomeViewController.m
//  MyHome
//
//  Created by HXL on 15/8/4.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "MyHomeViewController.h"
#import "HtmlViewController.h"

@interface MyHomeViewController ()

@property (strong, nonatomic) IBOutlet UIView *bgFun;

@property (strong, nonatomic) IBOutlet UIView *bgSave;

- (IBAction)onHomeClick:(id)sender;

- (IBAction)onTypeClick:(id)sender;


@end

@implementation MyHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)coustomNav{
    self.navigationItem.title=@"家庭应用";
//    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(10, 0, 30, 20), @selector(onAddClick:), self);
//    sendBut.tag=1;
//    [sendBut setImage:[UIImage imageNamed:@"hm_add"] forState:UIControlStateNormal];
//    [sendBut setImage:[UIImage imageNamed:@"hm_add_select"] forState:UIControlStateSelected];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
}


- (IBAction)onHomeClick:(id)sender {
    PSLog(@"---[%d]---",[sender tag]);
    switch ([sender tag]) {
        case 1:
            [self alertAction:self.bgFun];
            break;
        case 2:
            [self alertAction:self.bgSave];
            break;
        case 3:{
            HtmlViewController * web =[[HtmlViewController alloc]init];
            web.url = @"http://www.adsmart.com.cn/ast7e07h";
            web.title =@"智能手环";
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case 4:{
            HtmlViewController * web =[[HtmlViewController alloc]init];
            web.url = @"http://www.wiselink.net.cn/index.php/a/1";
            web.title =@"车联网";
            [self.navigationController pushViewController:web animated:YES];
        }
            
            break;
    }
    
}

- (IBAction)onTypeClick:(id)sender {
    [self cancelShow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertAction:(UIView *)alertView {
    CGRect rect =  alertView.frame;
    rect.origin = CGPointMake((XL_ScreenWidth-rect.size.width)/2.0,( XL_ScreenHeight - rect.size.height)/2.0);

    alertView.frame = rect;
    [GlobalShare addSubViewToAlertWindowAndShow:alertView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelShow)];
    [[GlobalShare alertWindow] addGestureRecognizer:tap];
}

-(void)cancelShow
{
    [GlobalShare showRootWindowAndHiddenAlertWindow];
}


@end
