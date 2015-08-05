//
//  MyPlaybackBuffer.m
//  P2PCamera
//
//  Created by Tsang on 13-6-20.
//
//

#import "MyPlaybackBuffer.h"

@implementation MyPlaybackBuffer
@synthesize isMJPG;
-(id)init{
    self=[super init];
    mArr=[[NSMutableArray alloc]init];
    mLock=[[NSCondition alloc]init];
    maxsize=10;
    isFirstFrame=YES;
    isLeakOneFrame=NO;
    framenumber=0;
    return self;
}

-(void)writeOneFrame:(char *)data Len:(unsigned int)len Type:(int)type Timestamp:(unsigned int)timestamp FrameNumber:(int)frameno{
    
    if (mArr.count==maxsize) {
       //NSLog(@"writeOneFrame..buff已经满了");
        isLeakOneFrame=YES;
        
        return;
    }
//    if (framenumber>frameno) {
//        NSLog(@"writeOneFrame..回帧丢掉");
//        isLeakOneFrame=YES;
//        return;
//    }
    //NSLog(@"writeOneFrame..远程回放保存数据");
    framenumber=frameno;
    if (isMJPG) {
        PlaybackBean *bean=[[PlaybackBean alloc]init];
        bean.len=len;
        bean.type=type;
        bean.timestamp=timestamp;
        bean.pbuf=new char[len];
        memcpy(bean.pbuf,data,len);
        [mArr insertObject:bean atIndex:0];
//        [bean release];
        //NSLog(@"writeOneFrame...MJPG写入一帧");
    }else{
        if (isFirstFrame) {
            if (type==0) {//i
                PlaybackBean *bean=[[PlaybackBean alloc]init];
                bean.len=len;
                bean.type=type;
                bean.timestamp=timestamp;
                bean.pbuf=new char[len];
                memcpy(bean.pbuf,data,len);
                [mArr insertObject:bean atIndex:0];
//                [bean release];
                isFirstFrame=NO;
                
              // NSLog(@"writeOneFrame...写入一帧");
            }else{
               // NSLog(@"writeOneFrame... 第一帧 P");
            }
        }else{
            if (isLeakOneFrame) {//丢掉了一些帧后，保存的第一帧必须是i帧
                
                if (type==0) {
                    PlaybackBean *bean=[[PlaybackBean alloc]init];
                    bean.len=len;
                    bean.type=type;
                    bean.timestamp=timestamp;
                    bean.pbuf=new char[len];
                    memcpy(bean.pbuf,data,len);
                    [mArr insertObject:bean atIndex:0];
//                    [bean release];
                    isLeakOneFrame=NO;
                    //NSLog(@"writeOneFrame...写入一帧");
                    
                }else{
                    //NSLog(@"writeOneFrame... 溜帧 P");
                }
            }else{
                PlaybackBean *bean=[[PlaybackBean alloc]init];
                bean.len=len;
                bean.type=type;
                bean.timestamp=timestamp;
                bean.pbuf=new char[len];
                memcpy(bean.pbuf,data,len);
                
                [mArr insertObject:bean atIndex:0];
//                [bean release];
                //NSLog(@"writeOneFrame...写入一帧");
            
            }  
            
        }
    }
    
}

-(PlaybackBean *)readOneFrame{
    
    if ([mArr count]<=0) {
        //NSLog(@"buff 中没有数据");
        return nil;
    }
    //NSLog(@"从buff 读取一帧");
    return [mArr lastObject];
}
-(void)removeArrLastBean{
    
    [mArr removeLastObject];
    
}
-(BOOL)isBuffOver{

    if ([mArr count]>maxsize) {
        return YES;
    }else{
        return NO;
    }
}
-(void)dealloc{
    if (mArr!=nil) {
        [mArr removeAllObjects];
        mArr=nil;
        
    }
    
    
//    [super dealloc];
}
@end
