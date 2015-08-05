//
//  FlashInView.h
//  PiFiiHome
//
//  Created by HXL on 14-5-13.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ApplyType)(NSInteger tag);


@interface ApplyView : UIView

@property(nonatomic,copy)ApplyType type;
-(void)moveTransiton:(BOOL)isAnimation;

@end
