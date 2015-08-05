//
//  PlaybackBean.m
//  P2PCamera
//
//  Created by Tsang on 13-6-20.
//
//

#import "PlaybackBean.h"

@implementation PlaybackBean
@synthesize pbuf;
@synthesize len;
@synthesize timestamp;
@synthesize type;
-(void)dealloc{
     delete pbuf;
//    [super dealloc];
}
@end
