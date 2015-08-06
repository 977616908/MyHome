//
//  AccessDeviceCell.h
//  PiFiiHome
//
//  Created by Harvey on 14-5-10.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccessDeviceCell : UICollectionViewCell

@property (nonatomic,strong)  CCImageView     *wifiLolo;
@property (nonatomic,strong)  CCLabel         *wifiName;
//@property (nonatomic,weak)  UILabel         *wifiIP;
//@property (nonatomic,weak)  UIButton        *removeWifi;

@end



@interface DeviceItem : NSObject

@property (nonatomic,strong) NSString *deviceName;  /**<设备名字*/
@property (nonatomic,strong) NSString *deviceIP;    /**<设备IP*/
@property (nonatomic,strong) NSString *deviceMac;   /**<设备Mac地址*/

@end