//
//  CCDownloadView.h
//  MyHome
//
//  Created by HXL on 14/11/14.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CCDownType){
    CCDownTypeAll,
    CCDownTypeNotFinish,
    CCDownTypeFinish
};

@interface CCDownloadView : UIView

@property(nonatomic,assign)CCDownType downType;
@property(nonatomic,copy)NSArray *arrayList;
@property(nonatomic,strong)id superController;

@end
