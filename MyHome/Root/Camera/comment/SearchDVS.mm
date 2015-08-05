// SearchDVS.cpp: implementation of the CSearchDVS class.
//
//////////////////////////////////////////////////////////////////////


#import <UIKit/UIKit.h>
#include "SearchDVS.h"

#define MY_BROADCAST
#define _MY_MULTICAST_IP		"224.2.2.9"


static CSearchDVS *pSearchDVS = NULL;

CSearchDVS::CSearchDVS()
{
    m_bRecvThreadRuning = false;	
    m_nSocket = -1;
    m_RecvThreadID = 0 ;

    pSearchDVS = this;
    
    searchResultDelegate =  nil;
    m_bSendThreadRuning = 0;
    m_SendThreadID = 0;
}

CSearchDVS::~CSearchDVS()
{
	Close();
}

void CSearchDVS::CloseSocket()
{
    //int flag = fcntl(m_nSocket, F_GETFL, 0);
    //fcntl(m_nSocket, F_SETFL, flag | O_NONBLOCK);
    
    shutdown(m_nSocket, SHUT_RDWR);
    close(m_nSocket);
}

void my_alarm_handler(int a)
{  
    alarm(0);

    pSearchDVS->SearchDVS();
}


int CSearchDVS::Open()
{    
	int		iRet;
	m_nSocket = socket(AF_INET, SOCK_DGRAM, IPPROTO_IP);
	if (m_nSocket < 0)
	{
        printf("m_nSocket < 0\n");
		return 0;
	}
#ifdef MY_BROADCAST
	const int fBroadcast = 1;
	iRet = setsockopt(m_nSocket, SOL_SOCKET, SO_BROADCAST, (const void *)&fBroadcast, sizeof(int));
	if (iRet < 0)
	{
        printf("setsocketopt < 0\n");
		CloseSocket();
		return 0;
	}
#else
	const int routenum = 255;
	iRet = setsockopt(m_nSocket, IPPROTO_IP, IP_MULTICAST_TTL, (char*)&routenum, sizeof(routenum));
	if (iRet < 0)
	{
		CloseSocket();
		return 0;
	}

	const int loopback = 1; 
	iRet = setsockopt(m_nSocket, IPPROTO_IP, IP_MULTICAST_LOOP, (char*)&loopback, sizeof(loopback));
	if (iRet < 0)
	{
		CloseSocket();
		return 0;
	}
#endif

    
    struct sockaddr_in servaddr;
    memset((char *)&servaddr, 0, sizeof(servaddr));  

    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	
    int i;
    for(i=0;i<MAX_BIND_TIME;i++)
    {
        servaddr.sin_port = htons(BROADCAST_RECV_PORT + i);
    	iRet = bind(m_nSocket, (sockaddr *)&servaddr, sizeof(servaddr));
    	if (iRet < 0)
    	{		
    		continue ;
    	}
        break;
    }

    if (iRet < 0)
    {
        printf("bind failed\n");
        CloseSocket();
        return 0;
    }
    
    printf("seraddr.sin_port: %d\n", htons(servaddr.sin_port));
    

#ifndef MY_BROADCAST
	ip_mreq mreq;
	memset(&mreq, 0, sizeof(mreq));
	mreq.imr_interface.S_un.S_addr = INADDR_ANY;
	mreq.imr_multiaddr.S_un.S_addr = inet_addr(_MY_MULTICAST_IP);

	
	iRet = setsockopt(m_nSocket, IPPROTO_IP, IP_ADD_MEMBERSHIP, (char*)&mreq, sizeof(mreq));
	if (iRet < 0)
	{
		CloseSocket();
		return 0;
	}
#endif   
    
    

    m_bRecvThreadRuning = true  ;
    pthread_create(&m_RecvThreadID, NULL, CSearchDVS::ReceiveThread, this);
    
    m_bSendThreadRuning = 1;
    pthread_create(&m_SendThreadID, NULL, SendThread, this);
    
    
//    signal( SIGALRM, my_alarm_handler );    
//    alarm(1);

    return 1;
}

void* CSearchDVS::SendThread(void *pParam)
{
    CSearchDVS *pSearchDVS = (CSearchDVS*)pParam;
    pSearchDVS->SendProcess();
    return NULL;
}

void CSearchDVS::SendProcess()
{
    int i;
    for (i = 0; i < 10 && m_bSendThreadRuning; i++) {
        SearchDVS();
        usleep(200000);
    }
}

void CSearchDVS::Close()
{
    m_bRecvThreadRuning = false;
    m_bSendThreadRuning = 0;
    CloseSocket();
    
    m_nSocket = -1;	
    
    if (m_SendThreadID != 0) {
        pthread_join(m_SendThreadID, NULL);
        m_SendThreadID = 0;
    }
    
    if (m_RecvThreadID != 0) 
    {
        //pthread_join(m_RecvThreadID, NULL);
        pthread_cancel(m_RecvThreadID);
        m_RecvThreadID = 0;
    }   
	
}

int CSearchDVS::SearchDVS()
{   
    char sendBuf[128];
    char *p;
    struct sockaddr_in servAddr;
    
    memset(sendBuf, 0, sizeof(sendBuf));
    p = sendBuf;
    *((short*)p) = (short)STARTCODE;
    p += sizeof(short);
    *((short*)p) = (short)CMD_GET;
	
	memset(&servAddr, 0, sizeof(servAddr));
	servAddr.sin_family      = AF_INET;
#ifdef MY_BROADCAST
	servAddr.sin_addr.s_addr = htonl(INADDR_BROADCAST);
#else
	servAddr.sin_addr.s_addr = inet_addr(_MY_MULTICAST_IP);
#endif
	servAddr.sin_port        = htons(BROADCAST_SEND_PORT);

	sendto(m_nSocket, sendBuf, sizeof(short) * 2, 0, (sockaddr *)&servAddr, sizeof(servAddr)); 
    
	return 1;
}

void* CSearchDVS::ReceiveThread(void *pParam)
{
    CSearchDVS* pSearchDVS = (CSearchDVS*)pParam ;
    
    pSearchDVS->ReceiveProcess() ;  

    return NULL;
    
}

void CSearchDVS::ReceiveProcess()
{
    
    struct sockaddr_in  cliAddr;
    int					bytes = 0;
    socklen_t		cliAddrLen = sizeof(sockaddr_in);
    char				szBuffer[1024];
    
    SearchDVS();

    while (m_bRecvThreadRuning)
    {  
        memset(&cliAddr, 0, sizeof(sockaddr_in));
        memset(szBuffer, 0, sizeof(szBuffer));
        printf("CSearchDVS::ReceiveProcess.....\n");
        bytes = recvfrom(m_nSocket, szBuffer, 1024, 0, (sockaddr*)&cliAddr, (socklen_t *)&cliAddrLen);
        printf("recvfrom...end..\n");
        if (bytes <= 0)
        {
            m_bRecvThreadRuning = false;
        }
        else
        {
            char *pStr = inet_ntoa(cliAddr.sin_addr);            
            OnMessageProc(szBuffer, bytes, pStr);
        }
    }
    
}

void CSearchDVS::GetNetParam(PBCASTPARAM pstParam)
{
    char mac[32],szport[32] ;
    memset(mac, 0, sizeof(mac));    
    memset(szport, 0, sizeof(szport));   
    sprintf(mac,"%02x%02x%02x%02x%02x%02x", 
            (unsigned char)(pstParam->szMacAddr[0]),
            (unsigned char)(pstParam->szMacAddr[1]),
            (unsigned char)(pstParam->szMacAddr[2]),
            (unsigned char)(pstParam->szMacAddr[3]),
            (unsigned char)(pstParam->szMacAddr[4]),
            (unsigned char)(pstParam->szMacAddr[5]));
    
    sprintf(szport,"%d", pstParam->nPort);
    
    printf("szport: %s\n", szport);
    printf("szIpAddr: %s\n", pstParam->szIpAddr);
    
    char szTmpIpAddr[16] = {0};
    memcpy(szTmpIpAddr, pstParam->szIpAddr, 15);
    
    printf("addr: %s, port: %s, mac: %s\n", pstParam->szIpAddr, szport, mac);    
    
    if (searchResultDelegate != nil)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
       
        [searchResultDelegate SearchCameraResult:[NSString stringWithUTF8String:mac] 
                                            Name:[NSString stringWithUTF8String:pstParam->szDevName] 
                                            Addr:[NSString stringWithUTF8String:pstParam->szIpAddr]
                                            Port:[NSString stringWithUTF8String:szport]
                                            DID:[NSString stringWithUTF8String:pstParam->dwDeviceID]];
//        [pool release];
    }
}

void CSearchDVS::ProcMessage(short sCmdID, unsigned short nMessageLen, char *pszMessage)
{
    printf("ProcMessage..nMessageLen: %d\n", nMessageLen);
    switch(sCmdID)
    {
        case CMD_GET_RESPONSE:
            printf("CMD_GET_RESPONSE..\n");
            if(nMessageLen<sizeof(BCASTPARAM))
                return;
            GetNetParam((PBCASTPARAM)pszMessage);
            break;
    }
    
    
}


void CSearchDVS::OnMessageProc(char *pszBuffer, int iBufferSize,  char *pszIp)
{
     printf("OnMessageProc...\n");
    short st = *((short*)pszBuffer);
    if(st != STARTCODE)
        return;

    short sCmdID = *((short*)(pszBuffer+2));
    ProcMessage(sCmdID, iBufferSize - 4, pszBuffer + 4 );        

}


