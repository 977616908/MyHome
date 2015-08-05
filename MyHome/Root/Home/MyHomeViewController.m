//
//  MyHomeViewController.m
//  MyHome
//
//  Created by HXL on 15/8/4.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "MyHomeViewController.h"

@interface MyHomeViewController ()
- (IBAction)onHomeClick:(id)sender;

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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
