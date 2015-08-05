//
//  PiFiiBaseNavigationController.m
//  PiFiiHome
//
//  Created by Harvey on 14-8-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "PiFiiBaseNavigationController.h"

@interface PiFiiBaseNavigationController ()

@end

@implementation PiFiiBaseNavigationController


+(void)initialize{
    // 设置导航栏主题
    [self setupNavBarTheme];
    // 设置导航栏按钮主题
    [self setupBarButtonItemTheme];
}


/**
 *  设置导航栏主题
 */
+(void)setupNavBarTheme{
    UINavigationBar *navBar=[UINavigationBar appearance];
    navBar.tintColor = [UIColor whiteColor];
    navBar.barStyle = UIBarStyleDefault;
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:19.0];
    [navBar setTitleTextAttributes:textAttrs];
    NSString *backImage = @"hm_bg00_iOS6";
    if (is_iOS7()) {
        backImage = @"hm_bg00";
    }
    [navBar setBackgroundImage:[UIImage imageNamed:backImage] forBarMetrics:UIBarMetricsDefault];
     [((UIView *)[[(UIView *)[navBar.subviews objectAtIndex:0] subviews] lastObject]) removeFromSuperview];
}

/**
 * 设置导航栏按钮主题
 */
+(void)setupBarButtonItemTheme{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    if (!is_iOS7()) {
        UIImage *image=[[UIImage alloc]init];
        [item setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:image forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        [item setBackgroundImage:image forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    }
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:16];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[UITextAttributeTextColor] =  [UIColor lightGrayColor];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed=YES;
    }
    [super pushViewController:viewController animated:animated];
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
