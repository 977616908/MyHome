//
//  DateTimeProtocol.h
//  P2PCamera
//
//  Created by mac on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DateTimeProtocol <NSObject>

- (void) DateTimeProtocolResult:(int)now tz:(int)tz ntp_enable:(int)ntp_enable net_svr:(NSString*)ntp_svr;

@end
