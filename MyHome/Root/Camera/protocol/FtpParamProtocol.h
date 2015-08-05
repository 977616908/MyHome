//
//  FtpParamProtocol.h
//  P2PCamera
//
//  Created by Tsang on 12-12-12.
//
//

#import <Foundation/Foundation.h>

@protocol FtpParamProtocol <NSObject>

- (void) FtpParam: (char*) svr user:(char*) user pwd:(char*) pwd dir:(char*)dir port:(int)port uploadinterval: (int) uploadinterval mode:(int)mode;

@end
