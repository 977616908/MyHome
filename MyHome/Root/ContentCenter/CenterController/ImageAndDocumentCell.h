//
//  ImageAndDocumentCell.h
//  MyHome
//
//  Created by Harvey on 14-7-31.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAndDocumentCell : UITableViewCell
@property (weak, nonatomic)  IBOutlet UIImageView    *selectImg;
@property (nonatomic,strong) IBOutlet UIImageView    *filePreview;
@property (nonatomic,strong) IBOutlet UILabel        *fileName;
@property (nonatomic,strong) IBOutlet UILabel        *fileSize;
@property (nonatomic,strong) IBOutlet UILabel        *fileUpDate;

@end
