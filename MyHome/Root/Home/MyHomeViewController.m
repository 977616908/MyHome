//
//  MyHomeViewController.m
//  MyHome
//
//  Created by HXL on 15/8/4.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "MyHomeViewController.h"

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
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
        case 3:
            
            break;
        case 4:
            
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
    rect.origin = CGPointMake((XL_ScreenWidth-rect.size.width)/2.0,( XL_ScreenHeight - rect.size.height)/3.0);

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
