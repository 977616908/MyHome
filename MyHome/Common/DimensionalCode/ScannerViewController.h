//
//  ScannerViewController.h
//  YYQMusic
//
//  Created by Harvey on 13-10-18.
//  Copyright (c) 2013年 广东星外星文化传播有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DimensionalCode/DimensionalCodeSDK.h>
#import "DownLoadViewController.h"
#import "WFXDeviceFinder.h"
#import "SemiAsyncDispatcher.h"
typedef enum{
    ScannerNone=0,
    ScannerMac,
    ScannerOther
}ScannerType;
@protocol ScannerMacDelegate <NSObject>
@optional
-(void)scannerMacWithDeviceEcho:(DeviceEcho *)echo;
-(void)scannerMessage:(NSString *)msg;

@end

@interface ScannerViewController : DimensionalCodeReaderViewController <DimensionalCodeReaderViewControllerDelegate>

{
    CCLabel *tipBack;
    CCView  *tipView;
    CCLabel *crMsg;
    CCView *rigViewNav;
    CGFloat org_Y;
}

@property(nonatomic,assign)ScannerType type;
@property(nonatomic,weak)id<ScannerMacDelegate> delegate;

@end
