//
//  PlaybackBean.h
//  P2PCamera
//
//  Created by Tsang on 13-6-20.
//
//

#import <Foundation/Foundation.h>

@interface PlaybackBean : NSObject
{
    unsigned int timestamp;
    unsigned int len;
    char *pbuf;
    int type;
}
@property unsigned int timestamp;
@property unsigned int len;
@property char *pbuf;
@property int type;
@end
