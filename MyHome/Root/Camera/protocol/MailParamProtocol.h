//
//  MailParamProtocol.h
//  P2PCamera
//
//  Created by Tsang on 12-12-13.
//
//

#import <Foundation/Foundation.h>

@protocol MailParamProtocol <NSObject>

- (void) MailParam: (NSString*) strSender smtpsvr:(NSString*) strSmtpSvr smtpport:(int) smtpport ssl:(int)ssl auth:(int)auth user:(NSString*)user pwd:(NSString*)pwd recv1:(NSString*)recv1 recv2:(NSString*)recv2 recv3:(NSString*)recv3 recv4:(NSString*)recv4;

@end
