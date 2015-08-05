//
//  FlashInView.h
//  PiFiiHome
//
//  Created by HXL on 14-5-13.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BindType)(NSInteger tag,NSString* statue);


@interface BindView : UIView

@property(nonatomic,copy)BindType type;
@property(nonatomic,assign)BOOL isBind;
@property (weak, nonatomic)CCButton       *btnScanner;
-(void)moveTransiton:(BOOL)isAnimation;

@end
