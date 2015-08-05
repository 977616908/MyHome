
#include "CameraMediaSource.h"
#include "H264Decoder.h"
CCameraMediaSource::CCameraMediaSource(char *ipaddr, int port, ENUM_VIDEO_MODE videomode, char* user, char* pwd, CCircleBuf *pVideoBuf)
{
    //-------------------------------------------------------------//
    printf("ipaddr: %s, port: %d, user: %s, pwd: %s\n", ipaddr, port, user, pwd);
    //ipaddr
    memset(m_szIpAddr, 0, sizeof(m_szIpAddr));
    strcpy(m_szIpAddr, ipaddr);
    
    //port
    m_nPort = port ;
    
    //videomode
    m_EnumVideoMode = videomode ;
    
    //user
    memset(m_szUser, 0, sizeof(m_szUser));
    strcpy(m_szUser, user);
    
    //pwd
    memset(m_szPwd, 0, sizeof(m_szPwd));
    strcpy(m_szPwd, pwd);
    
    //---init ---------------------//
    m_RecvThreadID = NULL;
    m_bRecvThreadRuning = 0;
    m_pVideoBuf = NULL;
    m_RecvSocket = -1;
    m_bFindIFrame = 0;
    msgDelegate = nil;
    
    m_PlayThreadID = NULL;
    m_bPlayThreadRuning = 0;
    
    //-------------------------------------------//
    m_pVideoBuf = pVideoBuf;
    m_PlayViewAVDataDelegateLock=[[NSCondition alloc]init];
}

CCameraMediaSource::~CCameraMediaSource()
{
    
    Stop();
}

void CCameraMediaSource::CloseSocket()
{
    shutdown(m_RecvSocket, SHUT_RDWR);
    close(m_RecvSocket);
}

int CCameraMediaSource::Start()
{
    StartVideoPlay();
    StartAVThread();
    return 1;
}

int CCameraMediaSource::Stop()
{
    StopVideoPlay();
    
    m_bRecvThreadRuning = 0;
    CloseSocket();
    
    if(m_RecvThreadID > 0)
    {
        pthread_join(m_RecvThreadID, NULL);
        m_RecvThreadID = NULL;
    }
//    [m_PlayViewAVDataDelegateLock release];
    m_PlayViewAVDataDelegateLock=nil;
    return 1;
}

void CCameraMediaSource::StartAVThread()
{
    //start recv thread
    m_bRecvThreadRuning = true;
    pthread_create(&m_RecvThreadID, NULL, RecvAVThread, (void*)this);
    
}

void CCameraMediaSource::MessageNotify(int MsgType)
{
    if (msgDelegate != nil)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [msgDelegate NotifyMessage:MsgType];
//        [pool release];
    }
}

void CCameraMediaSource::GetRequestText(char *pbuf, int len)
{
    memset(pbuf, 0, len);
    
    int streamID;
    if(m_EnumVideoMode == ENUM_VIDEO_MODE_H264)
    {
        streamID =  ENUM_STREAM_SUB_H264;
    }
    else
    {
        streamID = ENUM_STREAM_SUB_JPEG ;
    }
    streamID=10;
    char szTemp[128] ;
    memset(szTemp, 0, sizeof(szTemp));
    
#ifndef TEST_APP
    sprintf(szTemp, "GET /livestream.cgi?user=%s&pwd=%s&streamid=%d&audio=0& HTTP/1.1\r\n", m_szUser, m_szPwd, streamID);
#else
    sprintf(szTemp, "GET /livestream.cgi?user=%s&pwd=%s& HTTP/1.1\r\n", m_szUser, m_szPwd);
#endif
    
    strcpy(pbuf,szTemp);
    strcat(pbuf,"Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/QVOD, */*\r\n");
    strcat(pbuf,"Accept-Language: zh-cn\r\n");
    strcat(pbuf,"UA-CPU: x86\r\n");
    strcat(pbuf,"Accept-Encoding: gzip,deflate\r\n");
    strcat(pbuf,"User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; windows NT 5.1; .NET CLR 1.1.4222; .NET CLR 2.0.50727)\r\n");
    
    memset(szTemp, 0, sizeof(szTemp));
    sprintf(szTemp, "Host: %s:%d\r\nConnection: Keep-Alive\r\n\r\n", m_szIpAddr, m_nPort);
    strcat(pbuf, szTemp);
    
    // Log("pbuf: \n%s, length: %d\n",pbuf, strlen(pbuf));
}

void CCameraMediaSource::RecvAVProcess()
{
    struct hostent *ent = gethostbyname(m_szIpAddr);
    if (ent == NULL)
    {
        MessageNotify(MSG_TYPE_INIT_NET_ERROR);
        return ;
    }
    
    m_RecvSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if(m_RecvSocket < 0)
    {
        MessageNotify(MSG_TYPE_INIT_NET_ERROR);
        return ;
    }
    
    //    #if 0
    //
    //    int flags;
    //    flags = fcntl(m_RecvSocket, F_GETFL);
    //    if (flags != -1)
    //    {
    //        fcntl(m_RecvSocket, F_SETFL, flags | O_NONBLOCK);
    //    }
    //
    //    #endif
    
    struct sockaddr_in remote;
    memset(remote.sin_zero, 0, sizeof(remote.sin_zero));
    remote.sin_family = AF_INET;
    remote.sin_addr.s_addr = *(in_addr_t *)ent->h_addr;
    remote.sin_port = htons(m_nPort);
    
    int err = connect(m_RecvSocket, (struct sockaddr *)&remote, sizeof(sockaddr_in)) ;
    if(err < 0)
    {
        MessageNotify(MSG_TYPE_CONNECT_FAILED);
        printf("connect to server failed....\n");
        CloseSocket();
        return ;
    }
    //
    //    #if 0
    //
    //	struct   timeval   timeout   ;
    //	fd_set   r,w;
    //
    //	FD_ZERO(&r);
    //	FD_SET(m_RecvSocket,   &r);
    //    w = r;
    //	timeout.tv_sec   =   CONNECT_TIME_OUT;   /*¡¨Ω”≥¨ ±*/
    //	timeout.tv_usec  =0;
    //	int err = select(m_RecvSocket + 1, &r, &w, NULL, &timeout);
    //	if(err <= 0)
    //	{
    //        MessageNotify(MSG_TYPE_CONNECT_FAILED);
    //		printf("connect to server failed....\n");
    //		CloseSocket();
    //		return ;
    //	}
    //
    //
    //    if (flags != -1)
    //    {
    //        fcntl(m_RecvSocket, F_SETFL, flags & ~O_NONBLOCK);
    //    }
    //
    //    #endif
    
    int nFlag = 0 ;
    setsockopt(m_RecvSocket,IPPROTO_TCP,TCP_NODELAY, (char *)&nFlag, sizeof(int));
    
    struct timeval timeout = {10,0};
    setsockopt(m_RecvSocket, SOL_SOCKET,SO_SNDTIMEO,(char *)&timeout,sizeof(struct timeval));
    setsockopt(m_RecvSocket, SOL_SOCKET,SO_RCVTIMEO,(char *)&timeout,sizeof(struct timeval));
    
    char sendbuf[1024] = {0};
    GetRequestText(sendbuf,1024);
    
    if(0 == indeed_send(m_RecvSocket, sendbuf, strlen(sendbuf)))
    {
        MessageNotify(MSG_TYPE_SEND_ERROR);
        printf("send livestream request failed...!!!\n");
        CloseSocket();
        return ;
    }
    
    int headLen = sizeof(VIDEO_BUF_HEAD);
    while(m_bRecvThreadRuning)
    {
        //recv head
        AV_HEAD avhead;
        memset(&avhead, 0, sizeof(avhead));
        //Log("indeed_recv  start...");
        if(0 == indeed_recv(m_RecvSocket, (char*)&avhead, sizeof(avhead)))
        {
            printf("recv head error!\n");
            if(m_bRecvThreadRuning)
            {
                MessageNotify(MSG_TYPE_RECV_ERROR);
            }
            CloseSocket();
            return ;
        }
        
        //printf("avhead.type:%d, avhead.streamid:%d, avhead.militime:%d, avhead.sectime:%d, avhead.len:%d, avhead.frameno:%d\n",
        //avhead.type, avhead.streamid, avhead.militime, avhead.sectime, avhead.len, avhead.frameno);
        
        if(avhead.type < 0 || avhead.type > 8 || avhead.len > MAX_FRAME_LENGTH)
        {
            NSLog(@"recv data is invalid!!\n");
            MessageNotify(MSG_TYPE_RECV_ERROR);
            CloseSocket();
            return;
            
        }
        if (avhead.streamid==0) {
            m_EnumVideoMode=ENUM_VIDEO_MODE_H264;
        }else if(avhead.streamid==3){
            m_EnumVideoMode=ENUM_VIDEO_MODE_MJPEG;
        }
        
        char *pbuf = NULL;
        int Length = headLen + avhead.len;
        pbuf = new char[Length] ;
        VIDEO_BUF_HEAD *phead = (VIDEO_BUF_HEAD*)pbuf;
        phead->head = VIDEO_HEAD_VALUE;
        phead->timestamp = 0;
        phead->len = avhead.len;
        phead->frametype = avhead.type ;
        
        if(0 == indeed_recv(m_RecvSocket ,(char*)(pbuf + headLen), avhead.len))
        {
            MessageNotify(MSG_TYPE_RECV_ERROR);
            printf("recv data error!!\n");
            CloseSocket();
            return;
        }
        
        //---------H.264------------------------------
        if(m_EnumVideoMode == ENUM_VIDEO_MODE_H264)
        {
            
            if(m_bFindIFrame)
            {
                if(avhead.type == ENUM_FRAME_TYPE_I)
                {
                    m_bFindIFrame = 1;
                    m_pVideoBuf->Write(pbuf, Length);
                }
            }
            else
            {
                if(avhead.type == ENUM_FRAME_TYPE_P || avhead.type == ENUM_FRAME_TYPE_I)
                {
                    if(avhead.type == ENUM_FRAME_TYPE_I)
                    {
                        m_pVideoBuf->Reset();
                        m_pVideoBuf->Write(pbuf, Length) ;
                    }
                    else {
                        if(0 == m_pVideoBuf->Write(pbuf, Length))
                        {
                            m_bFindIFrame = 0;
                        }
                    }
                    
                }
                
            }
        }
        else/*-------------------------MJPEG----------------------- */
        {
            
            if(avhead.type == ENUM_FRAME_TYPE_MJPEG)
            {
                m_pVideoBuf->Reset();
                m_pVideoBuf->Write(pbuf, Length);
            }
        }
        
        delete pbuf;
        pbuf = NULL;
    }
    
}

void* CCameraMediaSource::RecvAVThread(void* param)
{
    CCameraMediaSource *pMediaSource = (CCameraMediaSource*)param ;
    pMediaSource->RecvAVProcess();
    return NULL;
}

int CCameraMediaSource::indeed_send(int sock, char *buf, int n)
{
    int send_cnt = n;
    char *p = buf;
    
    do
    {
        int nRet = send(sock, p, send_cnt, 0);
        if (nRet <= 0)
        {
            return 0;
        }
        
        send_cnt  -= nRet;
        
    } while (send_cnt != 0);
    
    return 1;
}

int CCameraMediaSource::indeed_recv(int sock, char *buf, int n)
{
    int nRecvSize = n;
    char *p = buf;
    
    do
    {
        int nRet = recv(sock, p, nRecvSize, 0);
        if (nRet <= 0)
        {
            return 0;
        }
        
        nRecvSize -= nRet;
        p += nRet;
    } while (nRecvSize != 0);
    
    return 1;
}

void CCameraMediaSource::StopVideoPlay()
{
    m_bPlayThreadRuning = 0;
    if(m_PlayThreadID != NULL)
    {
        pthread_join(m_PlayThreadID, NULL);
        m_PlayThreadID = NULL;
    }
}

void CCameraMediaSource::PlayProcess()
{
    CH264Decoder *pH264Decoder = new CH264Decoder();//创建h264的解码库
    while(m_bPlayThreadRuning)
    {
        if(m_pVideoBuf->GetStock() == 0)
        {
            usleep(10000);
            continue;
        }
        
        char *pbuf = NULL;
        int videoLen = 0;
        VIDEO_BUF_HEAD videohead;
        memset(&videohead, 0, sizeof(videohead));
        pbuf=m_pVideoBuf->ReadOneFrame1(videoLen, videohead);
        //pbuf = m_pVideoBuf->ReadOneFrame(videoLen) ;
        unsigned int untimestamp = videohead.timestamp;
        //NSLog(@"untimestamp=%d",untimestamp);
        if(NULL == pbuf)
            
        {
            usleep(10000);
            continue;
        }
        
        // NSLog(@"get one frame");
        if(ENUM_VIDEO_MODE_H264 == m_EnumVideoMode)
        {
            // NSLog(@"ENUM_VIDEO_MODE_H264  高清");
            
//            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            
            
            int yuvlen = 0;
            int nWidth = 0;
            int nHeight = 0;
            if (pH264Decoder->DecoderFrame((uint8_t*)pbuf, videoLen, nWidth, nHeight)) {
                yuvlen=nWidth*nHeight*3/2;
                uint8_t *pYUVBuffer = new uint8_t[yuvlen];
                if (pYUVBuffer != NULL) {
                    int nRec=pH264Decoder->GetYUVBuffer(pYUVBuffer, yuvlen);
                    
                    if (nRec>0) {
                        if (m_PlayViewImageNotifyDelegate!=nil) {
                            if ([m_PlayViewImageNotifyDelegate respondsToSelector:@selector(YUVNotify:length:width:height:timestamp:DID:)]) {
                                [m_PlayViewImageNotifyDelegate YUVNotify:pYUVBuffer length:yuvlen width:nWidth height:nHeight timestamp:untimestamp DID:@""];
                            }
                        }
                        
                        
                    }
                    
                    delete pYUVBuffer;
                    pYUVBuffer = NULL;
                }
                
            }
            
            // NSLog(@"CameraMediaSource PlayProcess() ");
            H264DataNotify((unsigned char*)pbuf, videoLen, videohead.frametype, untimestamp);
            
//            [pool release];
            
        }
        else /* JPEG */
        {
            AVNofity(pbuf, videoLen,untimestamp);
        }
        
        SAFE_DELETE(pbuf) ;
        
        usleep(10000);
        
    }
    
}

void CCameraMediaSource::H264DataNotify(unsigned char *h264Data, int length, int type, unsigned int timestamp)
{
    //NSLog(@"CameraMediaSource  H264DataNotify() type=%d",type);
    [m_PlayViewAVDataDelegateLock lock];
    if (m_PlayViewImageNotifyDelegate!=nil) {
        if ([m_PlayViewImageNotifyDelegate respondsToSelector:@selector(H264Data:length:type:timestamp:DID:)]) {
            [m_PlayViewImageNotifyDelegate H264Data:h264Data length:length type:type timestamp:timestamp DID:@""];
        }
    }
    
    [m_PlayViewAVDataDelegateLock unlock];
}
void CCameraMediaSource::AVNofity(char *buf, int len,int timestamp)
{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (m_PlayViewImageNotifyDelegate!=nil) {
        if ([m_PlayViewImageNotifyDelegate respondsToSelector:@selector(AVData:length:Timestamp:)]) {
            [m_PlayViewImageNotifyDelegate AVData:buf length:len Timestamp:timestamp];
        }
    }
    
//    [pool release];    
    
}

void* CCameraMediaSource::PlayThread(void* param)
{
    CCameraMediaSource *pSource = (CCameraMediaSource*)param ;	    
    pSource->PlayProcess();	    
    return NULL;	
}

void CCameraMediaSource::StartVideoPlay()
{
    //StartPlayThread
    m_bPlayThreadRuning = 1;
    pthread_create(&m_PlayThreadID, NULL, PlayThread, (void*)this);
}



