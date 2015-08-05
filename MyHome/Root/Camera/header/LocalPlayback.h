//
//  LocalPlayback.h
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaybackProtocol.h"

#ifndef P2PCamera_LocalPlayback_h
#define P2PCamera_LocalPlayback_h

class CLocalPlayback
{
public:
    CLocalPlayback();
    ~CLocalPlayback();
    
    void SetPlaybackDelegate(id<PlaybackProtocol> playbackDelegate);
    BOOL StartPlayback(char *szFilePath);
    void Pause(BOOL bPause);
    
protected:
    static void* PlaybackThread(void* param);
    void PlaybackProcess();
    
    void StopPlayback();
    BOOL CustomSleep(int uNum);
    BOOL GetIndexInfo();
    BOOL isPlayOver;
    static void* UpdateTimeThread(void* param);
    void updateTimeProcess();
private:
    FILE *m_pfile;
    pthread_t m_UpdateTimeThreadID;
    pthread_t m_PlaybackThreadID;
    int m_bPlaybackThreadRuning;
    
    id<PlaybackProtocol> m_playbackDelegate;
    unsigned int m_nTotalTime;
    unsigned int m_nTotalKeyFrame;
    
    BOOL m_bPause;
    
    NSCondition *m_playbackLock;
    int sumTime;
    int startposition;
    
};


#endif
