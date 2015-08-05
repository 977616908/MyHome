//
//  PiFiiBaseTabBarController.m
//  MyHome
//
//  Created by HXL on 15/5/19.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "PiFiiBaseTabBarController.h"
#import "CCTabBar.h"
#import "PiFiiBaseNavigationController.h"
#import "RoutingTimeController.h"
//#import "ApplyViewController.h"
#import "MyHomeViewController.h"
#import "WowoViewController.h"

@interface PiFiiBaseTabBarController ()<CCTabBarDelegate>
@property(nonatomic,weak)CCTabBar *customTabBar;

@end

@implementation PiFiiBaseTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
//    self.selectedIndex=1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    CCTabBar *customTabBar = [[CCTabBar alloc] init];
    customTabBar.frame =self.tabBar.bounds;;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

- (void)setupTabbars
{
    CCTabBar *customTabBar = [[CCTabBar alloc] init];
    CGRect bounds=self.tabBar.bounds;
    customTabBar.frame =CGRectMake(0, CGRectGetHeight(self.view.frame)-bounds.size.height, CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    customTabBar.delegate = self;
    [self.tabBar removeFromSuperview];
    [self.view addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(CCTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
}

/**
 *  初始化所有的子控制器
 */
- (void)setupAllChildViewControllers
{
    // 1.时光游
    RoutingTimeController *time = [[RoutingTimeController alloc] init];
    time.barView=self.customTabBar;
    [self setupChildViewController:time title:@"时光游" imageName:@"hm_sgy" selectedImageName:@"hm_sgy_selected"];
    
    // 2.应用
    MyHomeViewController *myHome = [[MyHomeViewController alloc] init];
    [self setupChildViewController:myHome title:@"家庭应用" imageName:@"hm_yyon" selectedImageName:@"hm_yyon_selected"];
    
    // 3.我
    WowoViewController *wo = [[WowoViewController alloc] init];
    [self setupChildViewController:wo title:@"我" imageName:@"hm_woo" selectedImageName:@"hm_woo_selected"];
    

}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title=title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    if (is_iOS7()) {
        childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    // 2.包装一个导航控制器
    PiFiiBaseNavigationController *nav = [[PiFiiBaseNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
