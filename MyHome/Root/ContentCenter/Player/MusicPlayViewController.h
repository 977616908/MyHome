//
//  MusicPlayViewController.h
//  MyHome
//
//  Created by Harvey on 14-8-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MusicPlayViewController : PiFiiBaseViewController

@property (nonatomic,strong) NSArray                    *musicInfo;
@property (nonatomic,assign) NSInteger                  currentPlayIndex;

@end
