//
//  SnapshotProtocol.h
//  IpCameraClient
//
//  Created by apple on 12-6-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SnapshotProtocol <NSObject>

- (void) SnapshotNotify: (NSString*) strDID data:(char*) data length:(int) length;

@end
