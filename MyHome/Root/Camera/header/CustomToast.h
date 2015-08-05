//
//  CustomToast.h
//  P2PCamera
//
//  Created by mac on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomToast : NSObject

+ (void) showWithText: (NSString*) strText superView: (UIView*) superView bLandScap: (BOOL) bLandScap;


@end
