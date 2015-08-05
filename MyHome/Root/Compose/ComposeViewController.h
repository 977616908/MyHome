//
//  ComposeViewController.h
//  MyHome
//
//  Created by HXL on 15/5/20.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "PiFiiBaseViewController.h"
typedef enum{
    ComposeNone,
    ComposePhoto,
    ComposeCamera
}ComposeType;


@interface ComposeViewController : PiFiiBaseViewController
@property(nonatomic,assign)ComposeType type;
@property(nonatomic,copy)NSArray *arrPhoto;
@end
