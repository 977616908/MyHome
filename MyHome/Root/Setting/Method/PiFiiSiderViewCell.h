//
//  PiFiiSiderViewCell.h
//  MyHome
//
//  Created by Harvey on 14-5-13.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PiFiiSiderViewCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView     *rightImage;
@property (nonatomic,weak) IBOutlet UILabel         *tipText;
@property (nonatomic,weak) IBOutlet UIImageView     *leftImage;
@property (weak, nonatomic) IBOutlet UIView *bgLine;

@end



@interface PiFiiSiderViewItem : NSObject

@property (nonatomic,strong) NSString *leftImage;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSString *rightImage;

@end



@interface PiFiiSiderGridCell : UICollectionViewCell

@property (nonatomic,strong) CCLabel        *appName;
@property (strong,nonatomic) CCImageView    *appIco;

@end



@interface PiFiiSiderGridItem : NSObject

@property (nonatomic,strong) NSString *appName;
@property (nonatomic,strong) NSString *appIco;
@property (nonatomic,copy)   NSString *appUrl;

@end










