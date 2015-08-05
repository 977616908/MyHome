//
//  CgiResultProtocol.h
//  P2PCamera
//
//  Created by Tsang on 13-4-9.
//
//

#import <Foundation/Foundation.h>

@protocol CgiResultProtocol <NSObject>
- (void) CgiResultNotify: (NSInteger) cgiID CgiResult:(NSString*)strResult ;
@end
