//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>

@protocol MJPhotoBrowserDelegate;

typedef enum{
    PhotoShowNone,//默认本地
    PhotoShowRouter,//路由
    PhotoShowCamera//时光相册
}PhotoShowType;

@interface MJPhotoBrowser : PiFiiBaseViewController <UIScrollViewDelegate>
// 代理
@property (nonatomic, weak) id<MJPhotoBrowserDelegate> delegate;
// 所有的图片对象
@property (nonatomic, copy) NSMutableArray * photos;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
//是否为显示相机图片
//@property(nonatomic,assign) BOOL isPhoto;
@property(nonatomic,assign)PhotoShowType photoType;


@end

@protocol MJPhotoBrowserDelegate <NSObject>


-(void)NewPostImageReload:(NSInteger)ImageIndex;

@optional
// 切换到某一页图片
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
@end