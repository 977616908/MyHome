//
//  CustomAVRecorder.h
//  P2PCamera
//
//  Created by mac on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef P2PCamera_CustomAVRecorder_h
#define P2PCamera_CustomAVRecorder_h


#import "obj_common.h"
#import "CircleBuf.h"

class CCustomAVRecorder
{
public:
    CCustomAVRecorder();
    ~CCustomAVRecorder();
    
    int StartRecord(char *path, int videoformat, char *szosd);
    void SendOneFrame(char *pbuf, unsigned int len, unsigned int timestamp,int frametype,int timezone ,int deviceTime );
    
protected:
    
    static void* RecordThread(void* param);
    void RecordProcess();
    
private:
    int StopRecord();
    void GetRecordPath(char *szPath, char *did);
    
    CCircleBuf *m_pCircleBuf;
    pthread_t m_RecordThreadID;
    int m_bRecordThreadRuning;
    
    FILE *m_pfile;
    
    unsigned int m_nFilePos;
    
    NSMutableArray *indexArray;
    unsigned int m_nRecordStartTime;
    unsigned int m_nRecordEndTime;
    
    NSCondition *m_stopLock;
    
    int m_bWaitKeyFrame;
    
};



#endif
