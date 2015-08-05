//
//  CCDownloadCell.h
//  MyHome
//
//  Created by Harvey on 14-5-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCDownloadCell : UITableViewCell

@property (nonatomic,weak)      IBOutlet UILabel         *contentName;
@property (nonatomic,weak)      IBOutlet UILabel         *contentSize;
@property (nonatomic,weak)      IBOutlet UIImageView     *arrowImage;
@property (nonatomic,weak)      IBOutlet UIButton        *arrowBackView;//下标
@property (nonatomic,weak)      IBOutlet UILabel         *downPercent;
@property (nonatomic,strong)    IBOutlet UIView          *actionView;
@property (nonatomic,strong)    IBOutlet UIButton        *actionBut;//下载
@property (nonatomic,strong)    IBOutlet UIButton        *delBut;//删除


- (void)doAnimation;
- (void)resetAnimation;

@end


typedef void(^UserClickAction)(NSInteger index);
@interface CCActionCell : UITableViewCell
@property (nonatomic,copy) UserClickAction userClickAction;

@end



@interface CCDownloadItem : NSObject

@property (nonatomic,strong) NSString *contentName;             /**<文件名字*/
@property (nonatomic,strong) NSString *contentSize;             /**<文件大小*/
@property (nonatomic,strong) NSString *contentState;            /**<文件状态*/
@property (nonatomic,strong) NSString *contentFinishPercent;    /**<文件完成百分比*/
@property (nonatomic,strong) NSString *contectFinishedSize;     /**<文件已经缓存的大小*/
@property (nonatomic,strong) NSString *contentFinishTime;       /**<文件完成下载时间*/

@end