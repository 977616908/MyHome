//
//  SearchAddCameraInfoProtocol.h
//  P2PCamera
//
//  Created by mac on 12-11-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchAddCameraInfoProtocol <NSObject>

- (void) AddCameraInfo: (NSString*) strCameraName DID: (NSString*) strDID IP:(NSString *)strIP Port:(NSString *)port;
@end
