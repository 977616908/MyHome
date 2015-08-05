//
//  AudioPlayer.m
//  P2PCamera
//
//  Created by mac on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PCMPlayer.h"

static UInt32 gBufferSizeBytes = 2 * (_AVCODEC_MAX_AUDIO_FRAME_SIZE * 4);

CPCMPlayer::CPCMPlayer(PlaybackAudioBufferCallback BuffCallback, void *param)
{    
    m_bPlaying = 0;
    
    int i;
    
    for (int i=0; i<NUM_BUFFERS; i++) {
        AudioQueueEnqueueBuffer(m_queue, m_buffers[i], 0, nil);
    }
    
    m_dataFormat.mSampleRate=8000;//
    m_dataFormat.mFormatID=kAudioFormatLinearPCM;
    m_dataFormat.mFormatFlags=kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    m_dataFormat.mBytesPerFrame=2;
    m_dataFormat.mBytesPerPacket=2;
    m_dataFormat.mFramesPerPacket=1;//
    m_dataFormat.mChannelsPerFrame=1;//
    m_dataFormat.mBitsPerChannel=16;//
    m_dataFormat.mReserved=0;    
    
    AudioQueueNewOutput(&m_dataFormat, BuffCallback, param, nil, nil, 0, &m_queue);  
    
    for (i=0; i<NUM_BUFFERS; i++) {
        AudioQueueAllocateBuffer(m_queue, gBufferSizeBytes, &m_buffers[i]);   
        if (readPacketsIntoBuffer(m_buffers[i]) == 1) {
            break;
        }        
    }
    
    Float32 gain=1.0;
    AudioQueueSetParameter(m_queue, kAudioQueueParam_Volume, gain);     
}

CPCMPlayer::~CPCMPlayer()
{
    StopPlay();
}

void CPCMPlayer::StartPlay()
{
    if (m_bPlaying == 1) {
        return;        
    }
    AudioQueueStart(m_queue, nil);
    m_bPlaying = 1;
}

void CPCMPlayer::StopPlay()
{
    if (m_bPlaying == 0) {
        return;        
    }
    //AudioQueueFlush(m_queue);    
    AudioQueueStop(m_queue, YES);    
    AudioQueueDispose(m_queue, YES);
    m_bPlaying = 0;
    
}

//填充静音数据
int CPCMPlayer::readPacketsIntoBuffer(AudioQueueBufferRef buffer) 
{
    UInt32 numBytes;
    numBytes = _AVCODEC_MAX_AUDIO_FRAME_SIZE * 4;
    AudioQueueBufferRef outBufferRef = buffer;    
    memset(outBufferRef->mAudioData, 0, numBytes);      
    outBufferRef->mAudioDataByteSize = numBytes;
    AudioQueueEnqueueBuffer(m_queue, outBufferRef, 0, nil);
    return 1;
}

