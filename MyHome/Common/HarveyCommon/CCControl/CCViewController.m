//
//  CCViewController.m
//  HarveySDK
//
//  Created by Harvey on 13-10-12.
//  Copyright (c) 2013年 Harvey. All rights reserved.
//

#import "CCViewController.h"

@implementation CCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
   // self.view.alpha = .5;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
    [self initBase];
    [self initStyle];
    [self addControl];
    [self HTTPRequest];
}

- (void)initBase
{
}

- (void)initStyle
{
}

- (void)addControl
{
}

- (void)HTTPRequest
{
    
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    CATransition *transition = [CATransition animation];
//    [transition setDuration:1];
//    transition.subtype = AnimationSubTypeFromRight;
//    transition.timingFunction = TimingFunctionDefault();
//    transition.type = AnimationTypeReveal;
//    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


