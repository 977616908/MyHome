//
//  PPPPStatusProtocol.h
//  IpCameraClient
//
//  Created by apple on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PPPPStatusProtocol <NSObject>

- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status;

@end
