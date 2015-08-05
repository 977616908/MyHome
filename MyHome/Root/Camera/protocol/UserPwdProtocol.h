//
//  UserPwdProtocol.h
//  P2PCamera
//
//  Created by mac on 12-10-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol UserPwdProtocol <NSObject>

- (void) UserPwdResult:(NSString *)did user1:(NSString*)strUser1 pwd1:(NSString*)strPwd1 user2:(NSString*)strUser2 pwd2:(NSString*)strPwd2 user3:(NSString*)strUser3 pwd3:(NSString*)strPwd3;

@end