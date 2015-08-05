//
//  VideoAndMusicViewController.h
//  MyHome
//
//  Created by Harvey on 14-7-30.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@import MediaPlayer;

typedef NS_ENUM(NSInteger, DataModel){
    
    DataModelMusic,
    DataModelVideo
};

@interface VideoMusicViewController :PiFiiBaseViewController

@property (nonatomic,assign) DataModel dataModel;

@end
