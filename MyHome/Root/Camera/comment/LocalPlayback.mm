//
//  LocalPlayback.mm
//  P2PCamera
//
//  Created by mac on 12-11-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocalPlayback.h"
#import "obj_common.h"
#import "defineutility.h"
#import "pthread.h"
//#import "libH264Dec.h"
#include "H264Decoder.h"
#import <sys/time.h>
#import <UIKit/UIKit.h>
CLocalPlayback::CLocalPlayback()
{
    m_pfile = NULL;
    m_playbackDelegate = nil;
    m_PlaybackThreadID = NULL;
    m_bPlaybackThreadRuning = 0;
    m_bPause = NO;
    sumTime=0;
    m_playbackLock = [[NSCondition alloc] init];
    isPlayOver=NO;
    
}

CLocalPlayback::~CLocalPlayback()
{
    StopPlayback();
    if (m_playbackLock != nil) {
//        [m_playbackLock release];
        m_playbackLock = nil;
    }
    sumTime=0;
}
void* CLocalPlayback::UpdateTimeThread(void *param){
    
    CLocalPlayback *pPlayback = (CLocalPlayback*)param;
//    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    pPlayback->updateTimeProcess();
    
//    [apool release];
    return  NULL;
}
void CLocalPlayback::updateTimeProcess(){
    
    while (m_bPlaybackThreadRuning) {
        //NSLog(@"updateTimeProcess....sumTime=%d",sumTime/1000);
        if (isPlayOver) {
            return;
        }
        [m_playbackDelegate PlaybackPos:sumTime/1000];
        
        // [m_playbackDelegate PlaybackPos:sumTime];
        sleep(1);
        
        if ((sumTime/1000)>=m_nTotalTime) {
            NSLog(@"updateTimeProcess...结束");
            return;
        }
        //        if (sumTime>=m_nTotalTime) {
        //            NSLog(@"updateTimeProcess...结束");
        //             [m_playbackDelegate PlaybackStop];
        //            return;
        //        }
        //        sumTime++;
    }
}
void* CLocalPlayback::PlaybackThread(void *param)
{
    CLocalPlayback *pPlayback = (CLocalPlayback*)param;
//    NSAutoreleasePool *apool = [[NSAutoreleasePool alloc] init];
    pPlayback->PlaybackProcess();
//    [apool release];
    
    // NSLog(@"PlaybackThread end");
    return NULL;
}

void CLocalPlayback::StopPlayback()
{
    //  NSLog(@"CCCCCCCCCCC");
    m_bPlaybackThreadRuning = 0;
    if (m_PlaybackThreadID != NULL) {
        //      NSLog(@"DDDDDDDDDDDD");
        pthread_join(m_PlaybackThreadID, NULL);
        m_PlaybackThreadID = NULL;
    }
    if (m_UpdateTimeThreadID!=NULL) {
        pthread_join(m_UpdateTimeThreadID, NULL);
    }
    //  NSLog(@"EEEEEEEEEE");
    
    if (m_pfile) {
        fclose(m_pfile);
        m_pfile = NULL;
    }
}

BOOL CLocalPlayback::CustomSleep(int uNum)
{    sumTime+=1;
    int i = 0;
    for (i = 0; i < uNum; i++) {
        sumTime+=1;
        if (!m_bPlaybackThreadRuning) {
            return NO;
        }
        
        usleep(1000);
    }
    return YES;
}

BOOL CLocalPlayback::GetIndexInfo()
{
    //read the total time
    fseek(m_pfile, 0, SEEK_END);
    long fileLen = ftell(m_pfile);
    NSLog(@"fileLen: %ld", fileLen);
    int nEndIndexLen = strlen("ENDINDEX");
    fseek(m_pfile, fileLen - nEndIndexLen, 0);
    //NSLog(@"aaaa: %ld", ftell(m_pfile));
    char tempBuf[1024];
    memset(tempBuf, 0, sizeof(tempBuf));
    if(nEndIndexLen != fread(tempBuf, 1, nEndIndexLen, m_pfile))
    {
        m_nTotalKeyFrame = 0;
        m_nTotalTime= 0;
        return NO;
    }
    
    //NSLog(@"tempBuf: %s", tempBuf);
    if (strcmp("ENDINDEX", tempBuf) != 0) {
        m_nTotalKeyFrame = 0;
        m_nTotalTime= 0;
        return NO;
    }
    
    fseek(m_pfile, fileLen - nEndIndexLen - 8, 0);
    
    if(4 != fread((char*)&m_nTotalKeyFrame, 1, 4, m_pfile))
    {
        m_nTotalKeyFrame = 0;
        m_nTotalTime= 0;
        return NO;
    }
    if (4 != fread((char*)&m_nTotalTime, 1, 4, m_pfile))
    {
        m_nTotalKeyFrame = 0;
        m_nTotalTime= 0;
        return NO;
    }
    
    return YES;
}

void CLocalPlayback::PlaybackProcess()
{
    
    GetIndexInfo();
    [m_playbackLock lock];
    // NSLog(@"m_nTotalTime=%d",m_nTotalTime);
    [m_playbackDelegate PlaybackTotalTime:m_nTotalTime];
    [m_playbackLock unlock];
    
    fseek(m_pfile, SEEK_SET, 0);
    
    //read file head
    STRU_REC_FILE_HEAD filehead;
    memset(&filehead, 0, sizeof(filehead));
    if (sizeof(filehead) != fread((char*)&filehead, 1, sizeof(filehead), m_pfile))
    {
        [m_playbackLock lock];
        [m_playbackDelegate PlaybackStop];
        [m_playbackLock unlock];
        return;
    }
    
    if (filehead.head != 0xff00ff00) {
        [m_playbackLock lock];
        [m_playbackDelegate PlaybackStop];
        [m_playbackLock unlock];
        return;
    }
    
    
    
    unsigned int oldtimestamp = 0;
    
    //unsigned int startTimestamp = 0;
    
    CH264Decoder *pH264Decoder=new CH264Decoder();
    while (m_bPlaybackThreadRuning) {
        if (m_bPause) {
            usleep(10000);
            continue;
        }
        //read data head
        STRU_DATA_HEAD datahead;
        memset(&datahead, 0, sizeof(datahead));
        if(sizeof(datahead) != fread((char*)&datahead, 1, sizeof(datahead), m_pfile))
        {
            NSLog(@"datahead is error");
            [m_playbackLock lock];
            isPlayOver=YES;
            [m_playbackDelegate PlaybackStop];
            [m_playbackLock unlock];
            return;
        }
        if (datahead.head != 0xffff0000) {
            NSLog(@"datahead.head != 0xffff0000");
            [m_playbackLock lock];
            isPlayOver=YES;
            [m_playbackDelegate PlaybackStop];
            [m_playbackLock unlock];
            return;
        }
        
        //read data
        char *p = new char[datahead.datalen];
        if (p == NULL) {
            NSLog(@"p == NULL");
            [m_playbackLock lock];
            isPlayOver=YES;
            [m_playbackDelegate PlaybackStop];
            [m_playbackLock unlock];
            return;
        }
        
        if (datahead.datalen != fread(p, 1, datahead.datalen, m_pfile)) {
            SAFE_DELETE(p);
            [m_playbackLock lock];
            isPlayOver=YES;
            [m_playbackDelegate PlaybackStop];
            [m_playbackLock unlock];
            NSLog(@"read data error");
            return;
        }
        
        //        if (startTimestamp == 0) {
        //            startTimestamp = datahead.timestamp;
        //        }else{
        //            int nPos = datahead.timestamp - startTimestamp ;
        //            NSLog(@"nPos1 =%d",nPos);
        //            nPos = nPos / 1000;
        //            if (nPos <= 0) {
        //                nPos = 0;
        //            }
        //
        //            if (nPos > m_nTotalTime) {
        //                nPos = m_nTotalTime;
        //            }
        //            NSLog(@"nPos2  =%d",nPos);
        //            [m_playbackLock lock];
        //            [m_playbackDelegate PlaybackPos:nPos];
        //            [m_playbackLock unlock];
        //
        //        }
        
        //NSLog(@"timestamp: %d", datahead.timestamp);
        
        
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        if (filehead.videoformat == 0) {//MJPEG
            NSData *imgData = [NSData dataWithBytes:p length:datahead.datalen];
            UIImage *image = [UIImage imageWithData:imgData];
            [m_playbackLock lock];
            [m_playbackDelegate PlaybackData:image Timestamp:datahead.devicetime TimeZone:datahead.timezone];
            [m_playbackLock unlock];
        }else if(filehead.videoformat == 2){ //H264
            
            
            int yuvlen = 0;
            int nWidth = 0;
            int nHeight = 0;
            if (pH264Decoder->DecoderFrame((uint8_t*)p, datahead.datalen, nWidth, nHeight)) {
                yuvlen=nWidth*nHeight*3/2;
                uint8_t *pYUVBuffer = new uint8_t[yuvlen];
                if (pYUVBuffer != NULL) {
                    int nRec=pH264Decoder->GetYUVBuffer(pYUVBuffer, yuvlen);
                    
                    if (nRec>0) {
                        [m_playbackLock lock];
                        //NSLog(@"LocalPlayback....1帧");
                        [m_playbackDelegate PlaybackData:pYUVBuffer length:yuvlen width:nWidth height:nHeight Timestamp:datahead.devicetime TimeZone:datahead.timezone];
                        [m_playbackLock unlock];
                    }
                    
                    delete pYUVBuffer;
                    pYUVBuffer = NULL;
                }
                
            }
            
        }
        
//        [pool release];
        
        if (oldtimestamp == 0) {
            oldtimestamp = datahead.timestamp;
        }else {
            unsigned int timestamp1 = datahead.timestamp;
            int timeoff = timestamp1 - oldtimestamp;
            if (timeoff > 20000 || timeoff <= 0) {
                timeoff = 10;
            }
            //NSLog(@"timeoff=%d",timeoff);
            oldtimestamp = timestamp1;
            
            
            if (!CustomSleep(timeoff)) {
                SAFE_DELETE(p);
                
                return;
            }
            
        }
        
        
        SAFE_DELETE(p);
        
    }
    delete pH264Decoder;
    pH264Decoder=NULL;
}

void CLocalPlayback::Pause(BOOL bPause)
{
    m_bPause = bPause;
}

BOOL CLocalPlayback::StartPlayback(char *szFilePath)
{
    if (m_pfile != NULL) {
        return NO;
    }
    
    m_pfile = fopen(szFilePath, "rb");
    if (m_pfile == NULL) {
        return NO;
    }
    
    m_bPlaybackThreadRuning = 1;
    isPlayOver=NO;
    pthread_create(&m_PlaybackThreadID, NULL, PlaybackThread, this);
    pthread_create(&m_UpdateTimeThreadID, NULL, UpdateTimeThread, this);
    return YES;
}

void CLocalPlayback::SetPlaybackDelegate(id<PlaybackProtocol> playbackDelegate)
{
    [m_playbackLock lock];
    m_playbackDelegate = playbackDelegate;
    [m_playbackLock unlock];
}
