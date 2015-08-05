//
//  NCMusicEngine.m
//  NCMusicEngine
//
//  Created by nickcheng on 12-12-2.
//  Copyright (c) 2012年 NC. All rights reserved.
//

#import "NCMusicEngine.h"



@interface NCMusicEngine () {
    //
    BOOL _backgroundPlayingEnabled;
    //
    NSString *_localFilePath;
    NSTimer *_playCheckingTimer;
}

@property (nonatomic, assign, readwrite) NCMusicEnginePlayState playState;

@property (nonatomic, assign, readwrite) BOOL backgroundPlayingEnabled;



@property (nonatomic, assign) BOOL _pausedByUser;


@end

@implementation NCMusicEngine
//@synthesize player = _player;
@synthesize playState = _playState;
@synthesize delegate;
@synthesize _pausedByUser;
@synthesize backgroundPlayingEnabled = _backgroundPlayingEnabled;

#pragma mark -
#pragma mark Init


-(instancetype)init{
    if (self=[super init]) {
        _playState = NCMusicEnginePlayStateStopped;
        _pausedByUser = NO;
        _backgroundPlayingEnabled = NO;
        [self prepareBackgroundPlaying];
    }
    return self;
}

- (id)initWithSetBackgroundPlaying:(BOOL)setBGPlay {
  //
	if((self = [super init]) == nil) return nil;
  
  // Custom initialization
  _playState = NCMusicEnginePlayStateStopped;
  _pausedByUser = NO;
  _backgroundPlayingEnabled = NO;

  //
  if (setBGPlay) {
    [self prepareBackgroundPlaying];
  }
  return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)prepareBackgroundPlaying {
  [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
  [[AVAudioSession sharedInstance] setActive: YES error: nil];
  [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
  _backgroundPlayingEnabled = YES;
}

- (void)playUrl:(NSURL*)url {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.playerMusic=[[AVQueuePlayer alloc]initWithURL:url];
        [self.playerMusic play];
        self.playState = NCMusicEnginePlayStatePlaying;
        [self startPlayCheckingTimer];
    });


}


- (void)pause {
  if (self.playerMusic && [self.playerMusic rate]!=0.f) {
    [self.playerMusic pause];
    _pausedByUser = YES;
    self.playState = NCMusicEnginePlayStatePaused;
    [_playCheckingTimer invalidate];
  }
}

- (void)resume {
  if (self.playerMusic && [self.playerMusic rate]==0.f) {
    [self.playerMusic play];
    self.playState = NCMusicEnginePlayStatePlaying;
    [self startPlayCheckingTimer];
  }
}

// Stop music and stop download.
- (void)stop {
  if (self.playerMusic) {
    [self.playerMusic pause];
    self.playState = NCMusicEnginePlayStateStopped;
    [_playCheckingTimer invalidate];
  }
}

#pragma mark -
#pragma mark Private

- (void)handlePlayCheckingTimer:(NSTimer *)timer {
  //
  NSTimeInterval playerCurrentTime = CMTimeGetSeconds(self.playerMusic.currentTime);
  NSTimeInterval playerDuration = [self playerItemDuration];
  if (self.delegate &&
      [self.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
      [self.delegate respondsToSelector:@selector(engine:playProgress:)]) {
    if (playerDuration <= 0)
      [self.delegate engine:self playProgress:0];
    else
      [self.delegate engine:self playProgress:playerCurrentTime / playerDuration];
  }

}

- (NSTimeInterval)playerItemDuration
{
    NSError *err = nil;
    if ([_playerMusic.currentItem.asset statusOfValueForKey:@"duration" error:&err] == AVKeyValueStatusLoaded) {
        AVPlayerItem *playerItem = [_playerMusic currentItem];
        NSArray *loadedRanges = playerItem.seekableTimeRanges;
        if (loadedRanges.count > 0)
        {
            CMTimeRange range = [[loadedRanges objectAtIndex:0] CMTimeRangeValue];
            //Float64 duration = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);
            return CMTimeGetSeconds(range.duration);
        }else {
            return CMTimeGetSeconds(kCMTimeInvalid);
        }
    }else{
        return CMTimeGetSeconds(kCMTimeInvalid);
    }
}


- (void)startPlayCheckingTimer {
  //
  if (_playCheckingTimer) {
    [_playCheckingTimer invalidate];
    _playCheckingTimer = nil;
  }
  _playCheckingTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(handlePlayCheckingTimer:)
                                                      userInfo:nil
                                                    repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_playCheckingTimer forMode:NSRunLoopCommonModes];
}


- (void)setPlayState:(NCMusicEnginePlayState)playState {
  _playState = playState;
  if (self.delegate &&
      [self.delegate conformsToProtocol:@protocol(NCMusicEngineDelegate)] &&
      [self.delegate respondsToSelector:@selector(engine:didChangePlayState:)])
    [self.delegate engine:self didChangePlayState:_playState];
}



@end
