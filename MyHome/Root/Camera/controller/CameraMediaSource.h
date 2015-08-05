


#ifndef _CAMERA_MEDIA_SOURCE_H_
#define _CAMERA_MEDIA_SOURCE_H_

#include <pthread.h>
#include <memory.h>
#include <string.h>
#include <stdio.h>
#include <sys/socket.h>
#include <netinet/tcp.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/unistd.h>
#include <sys/fcntl.h>
#include <sys/time.h>
#include <netdb.h>

#include "CircleBuf.h"
#include "defineutility.h"

#import "NotifyMessageProtocol.h"

#import "ImageNotifyProtocol.h"
class CCameraMediaSource
{
public:
    CCameraMediaSource(char *ipaddr, int port, ENUM_VIDEO_MODE videomode, char* user, char* pwd, CCircleBuf* pVideoBuf);
    ~CCameraMediaSource();

	int Start();
	int Stop();
    
    id<NotifyMessageProtocol> msgDelegate;
    
    
    id<ImageNotifyProtocol> m_PlayViewImageNotifyDelegate;
 
private:
    int indeed_send(int sock, char *buf, int n);
    int indeed_recv(int sock, char *buf, int n);
	void GetRequestText(char *pbuf, int len);

    void StartAVThread();
    static void* RecvAVThread(void* param);      
    void RecvAVProcess();
	void MessageNotify(int MsgType);
	void CloseSocket();  
    void StopVideoPlay();
    void PlayProcess();
    void AVNofity(char *buf, int len,int timestamp);
    static void* PlayThread(void* param);
    void StartVideoPlay();
    void H264DataNotify(unsigned char* h264Data, int length, int type, unsigned int timestamp);
private:
    int m_bFindIFrame;
    CCircleBuf *m_pVideoBuf;
	pthread_t m_RecvThreadID;
	int m_RecvSocket;
	char m_szIpAddr[128] ;
	int m_nPort;
	ENUM_VIDEO_MODE m_EnumVideoMode;
	char  m_szUser[64] ;
	char m_szPwd[64] ;
	int m_bRecvThreadRuning;    
    int m_bPlayThreadRuning;
    pthread_t m_PlayThreadID;
    NSCondition *m_PlayViewAVDataDelegateLock;
};

#endif