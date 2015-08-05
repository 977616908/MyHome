//
//  ScanReusltViewController.m
//  YYQMusic
//
//  Created by Harvey on 13-11-4.
//  Copyright (c) 2013年 广东星外星文化传播有限公司. All rights reserved.
//

#import "ScanReusltViewController.h"

@implementation ScanReusltViewController
@synthesize text=_text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)nag_coustomNavigation{}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CCLabel *lab = [CCLabel createWithText:_text fontSize:16 frame:CGRectMake(0, 40, 320, 80)];
    lab.textColor = RGBCommon(88, 88, 88);
    lab.numberOfLines = INT32_MAX;
    [self.view addSubview:lab];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
