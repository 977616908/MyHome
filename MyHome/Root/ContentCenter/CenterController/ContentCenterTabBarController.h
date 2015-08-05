//
//  ContentCenterTabBarController.h
//  MyHome
//
//  Created by Harvey on 14-5-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentCenterTabBarController : UITabBarController<UITabBarControllerDelegate>
{
    CCImageView     *_scrollViewBack;
    CCLabel         *_labTitle;
}

@end
