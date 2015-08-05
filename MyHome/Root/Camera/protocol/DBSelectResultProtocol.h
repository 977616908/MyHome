//
//  DBSelectResultProtocol.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-25.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DBSelectResultProtocol


- (void) SelectP2PResult:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd;
- (void) SelectDDNSResult:(NSString *)name IP:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd;
@end
