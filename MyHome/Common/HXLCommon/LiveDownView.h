//
//  LineStandView.h
//  MyHome
//
//  Created by HXL on 14/11/11.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LiveDownBlock)(NSString* detail);
@interface LiveDownView : UIView

@property(nonatomic,copy)NSArray *arrayList;
@property(nonatomic,assign)CGFloat heightTb;
@property(nonatomic,copy)LiveDownBlock liveDown;
@property(nonatomic,assign)BOOL isHidden;
-(void)showHidden:(BOOL)hidden;
@end
