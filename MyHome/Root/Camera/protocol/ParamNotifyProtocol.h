//
//  ParamNotifyProtocol.h
//  IpCameraClient
//
//  Created by apple on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParamNotifyProtocol <NSObject>

- (void) ParamNotify: (int) paramType params:(void*) params;

@end
