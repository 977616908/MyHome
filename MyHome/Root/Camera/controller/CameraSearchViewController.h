//
//  CameraSearchViewController.h
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchAddCameraInfoProtocol.h"

@interface CameraSearchViewController : UIViewController

@property (nonatomic, assign) id<SearchAddCameraInfoProtocol> SearchAddCameraDelegate;

@end
