//
//  ContentCenterTabBarController.m
//  MyHome
//
//  Created by Harvey on 14-5-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ContentCenterTabBarController.h"

@interface ContentCenterTabBarController ()

@end

@implementation ContentCenterTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *viewControllNames = @[@"ResouceCtr",                   /**<资源中心控制器*/
                                   @"CCDownloadViewController",     /**<下载控制器*/
                                   @"ThreeViewController"];         /**<内容中心控制器*/
     NSArray *viewControllTitle = @[@"资源中心",@"下载",@"内容中心"];
    
    NSMutableArray *viewControllerInstance = [NSMutableArray new];
    for (NSString *vcName in viewControllNames) {
        
        [viewControllerInstance addObject:vcName.instance];
    }
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"hm_shenlan"]];
    self.delegate = self;
    self.navigationItem.title = @"内容中心";
    self.viewControllers = viewControllerInstance;
    
     NSArray *_itemBackImages = @[@"hm_icon001",@"hm_icon002",@"hm_icon003",@"hm_qianlan"];
    for (int i=0; i<3; i++) {
        
        CCImageView *item = CCImageViewCreateWithNewValue([_itemBackImages lastObject], CGRectMake(107*i, 0, 106, 49));
        [self.tabBar addSubview:item];
    }
    
    _scrollViewBack = CCImageViewCreateWithNewValue(@"hm_shenlan", CGRectMake(0, 0, 106, 49));
    [self.tabBar addSubview:_scrollViewBack];
    
    for (int i=0; i<3; i++) {
    
        CCImageView *item = CCImageViewCreateWithNewValue([_itemBackImages objectAtIndex:i], CGRectMake(41 + 107*i, 5, 24, 24));
        [self.tabBar addSubview:item];
        
        CCLabel *lab = CCLabelCreateWithNewValue([viewControllTitle objectAtIndex:i], 14, CGRectMake(107*i, 30, 106, 14));
        lab.textColor =RGBWhiteColor();
        lab.backgroundColor = RGBClearColor();
        lab.textAlignment = NSTextAlignmentCenter;
        [self.tabBar addSubview:lab];
    }
    
    if (is_iOS7() ^ 1) {
        
        self.navigationController.hidesBottomBarWhenPushed = YES;
        CCView *rigViewNav = [CCView createWithFrame:CGRectMake(0, 0, 120, 44) backgroundColor:RGBClearColor()];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitCurrentController)];
        [rigViewNav addGestureRecognizer:tap];
        
        [rigViewNav addSubview:CCImageViewCreateWithNewValue(@"ht_return", CGRectMake(0, 11.75, 12, 20.5))];
        
        _labTitle = CCLabelCreateWithNewValue(@"返回", 18, CGRectMake(15, 0, 100, 44));
        _labTitle.textColor = RGBWhiteColor();
        _labTitle.backgroundColor = RGBClearColor();
        [rigViewNav addSubview:_labTitle];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rigViewNav];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    _scrollViewBack.frame = CGRectMake(107*tabBarController.selectedIndex, 0, 106, 49);
    [UIView commitAnimations];
}

- (void)exitCurrentController
{
    
    if (![self.navigationController popViewControllerAnimated:YES]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
