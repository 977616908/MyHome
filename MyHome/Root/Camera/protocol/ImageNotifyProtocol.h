//
//  ImageNotifyProtocol.h
//  P2PCamera
//
//  Created by mac on 12-7-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol ImageNotifyProtocol <NSObject>

- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did;
- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did;
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp DID:(NSString *)did;
@optional
- (void) CameraDefaultParams:(int)m_Contrast Bright:(int)m_Brightness Resolution:(int)nResolution Flip:(int)m_nFlip Frame:(int)frame;;
- (void) AVData:(char *)data length:(int)length Timestamp:(int)timestamp;

@end
