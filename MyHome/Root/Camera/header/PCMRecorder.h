//
//  AudioRecorder.h
//  TestAudioRecorder
//
//  Created by mac on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>
#include <AudioToolbox/AudioQueue.h>
#include <AudioToolbox/AudioServices.h>

#define NUM_BUFFERS 3

#ifndef TestAudioRecorder_AudioRecorder_h
#define TestAudioRecorder_AudioRecorder_h

typedef  void (*RecordAudioBufferCallback)(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime, UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc);

class CPCMRecorder
{
public:
    CPCMRecorder(RecordAudioBufferCallback BuffCallback, void *param);
    ~CPCMRecorder();    
    int StartRecord();
    
private:
    int StopRecord();
    void DeriveBufferSize (AudioQueueRef audioQueue, AudioStreamBasicDescription ASBDescription, Float64 seconds, UInt32 *outBufferSize);    
    
private:
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef               queue;
    AudioQueueBufferRef         buffers[NUM_BUFFERS];    
    UInt32                      bufferByteSize;  
    int m_bRecordStarted;
};


#endif
