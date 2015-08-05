//
//  MyAudioSession.mm
//  P2PCamera
//
//  Created by mac on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>
#include <AudioToolbox/AudioQueue.h>
#include <AudioToolbox/AudioServices.h>
#include <iostream>

void MyInterruptionListener(void *inClientData, UInt32  inInterruptionState ) 
{
}

void InitAudioSession()
{
    //OSStatus status;
    AudioSessionInitialize(NULL, NULL, MyInterruptionListener, NULL);    
    AudioSessionSetActive(true);    
    UInt32 inDataSize = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(inDataSize), &inDataSize);    
    
    inDataSize = 1;
    /*status = */AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(inDataSize), &inDataSize);    
    //NSLog(@"status1:%c%c%c%c",status >> 24 & 0XFF,status>>16 & 0XFF,status>>8&0XFF, status & 0XFF);    
    inDataSize = 1;
    /*status = */AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(inDataSize), &inDataSize);
    //NSLog(@"status2:%c%c%c%c",status >> 24 & 0XFF,status>>16 & 0XFF,status>>8&0XFF,status & 0XFF);    
    inDataSize = 1;
    /*status = */AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(inDataSize), &inDataSize);
    //NSLog(@"status3:%c%c%c%c",status >> 24 & 0XFF,status>>16 & 0XFF,status>>8&0XFF,status & 0XFF);    

}



