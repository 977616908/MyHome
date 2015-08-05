//
//  NCMusicEngine.h
//  NCMusicEngine
//
//  Created by nickcheng on 12-12-2.
//  Copyright (c) 2012年 NC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol NCMusicEngineDelegate;


typedef enum {
  NCMusicEnginePlayStateStopped,
  NCMusicEnginePlayStatePlaying,
  NCMusicEnginePlayStatePaused,
  NCMusicEnginePlayStateEnded,
  NCMusicEnginePlayStateError
} NCMusicEnginePlayState;


@interface NCMusicEngine : NSObject

@property (nonatomic, assign, readonly) NCMusicEnginePlayState playState;
@property (nonatomic, assign, readonly) BOOL backgroundPlayingEnabled;
@property (nonatomic, strong, readonly) NSError *error;
@property (assign) id<NCMusicEngineDelegate> delegate;
@property (nonatomic, strong) AVQueuePlayer *playerMusic;

- (id)initWithSetBackgroundPlaying:(BOOL)setBGPlay;
- (void)prepareBackgroundPlaying;
- (void)playUrl:(NSURL*)url;
- (void)pause;
- (void)resume;
- (void)stop; // Stop music and stop download.
- (NSTimeInterval)playerItemDuration;
@end


@protocol NCMusicEngineDelegate <NSObject>

//- (NSURL*)engineExpectsNextUrl:(NCMusicEngine *)engine;

@optional
- (void)engine:(NCMusicEngine *)engine didChangePlayState:(NCMusicEnginePlayState)playState;
- (void)engine:(NCMusicEngine *)engine playProgress:(CGFloat)progress;

@end
