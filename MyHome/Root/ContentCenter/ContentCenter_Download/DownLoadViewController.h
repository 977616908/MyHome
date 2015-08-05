//
//  CCDownloadViewController.h
//  MyHome
//
//  Created by Harvey on 14-5-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CCViewController.h"
#import "CCDownloadView.h"

@interface DownLoadViewController : PiFiiBaseViewController

@property (nonatomic,strong) NSArray    *teskLists;
@property (nonatomic,strong) NSString   *url;


- (void)monitorDownloadInfoStop:(BOOL)isStop;
- (void)showTipWithText:(NSString *)text;
@end

