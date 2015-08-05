//
//  PlaybackProtocol.h
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol PlaybackProtocol <NSObject>

- (void) PlaybackStop;
- (void) PlaybackTotalTime: (NSInteger) nTotalTime;
- (void) PlaybackPos: (NSInteger) nPos;
- (void) PlaybackData: (UIImage *) image Timestamp:(unsigned int)timestamp TimeZone:(int)timezone;
- (void) PlaybackData: (Byte*) yuv length:(int)length width:(int)width height:(int)height Timestamp:(unsigned int)timestamp TimeZone:(int)timezone;

@end
