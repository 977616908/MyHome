//
//  NotifyMessageProtocol.h
//  P2PCamera
//
//  Created by Tsang on 13-4-9.
//
//

#import <Foundation/Foundation.h>

@protocol NotifyMessageProtocol <NSObject>
- (void) NotifyMessage:(NSInteger)msgType;
@end
