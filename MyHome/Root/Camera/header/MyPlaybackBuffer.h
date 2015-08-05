//
//  MyPlaybackBuffer.h
//  P2PCamera
//
//  Created by Tsang on 13-6-20.
//
//

#import <Foundation/Foundation.h>
#import "PlaybackBean.h"
@interface MyPlaybackBuffer : NSObject
{
    NSMutableArray *mArr;
    int maxsize;
    BOOL isLeakOneFrame;
    BOOL isFirstFrame;
    BOOL isMJPG;
    NSCondition *mLock;
    int framenumber;
}
@property BOOL isMJPG;
-(void)writeOneFrame:(char *)data Len:(unsigned int)len Type:(int)type Timestamp:(unsigned int)timestamp FrameNumber:(int )frameno;
-(PlaybackBean *)readOneFrame;
-(void)removeArrLastBean;
-(BOOL)isBuffOver;
@end
