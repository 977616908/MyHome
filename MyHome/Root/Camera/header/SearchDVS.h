// SearchDVS.h: interface for the CSearchDVS class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SEARCHDVS_H__C7BA1053_FF01_4C07_A732_0AD16CE7DB7B__INCLUDED_)
#define AFX_SEARCHDVS_H__C7BA1053_FF01_4C07_A732_0AD16CE7DB7B__INCLUDED_


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

#include "cmdhead.h"

#import "SearchCameraResultProtocol.h"

#define MAX_BIND_TIME 10
#define BROADCAST_SEND_PORT			8600
#define BROADCAST_RECV_PORT			9600

///
#define STARTCODE  0x4844  //HD
#define CMD_GET  0x0101
#define CMD_GET_RESPONSE  0x0801 
#define CMD_SET  0x0102
#define CMD_SET_RESPONSE  0x0802


class CSearchDVS  
{
public:
	CSearchDVS();
	virtual ~CSearchDVS();
    
    id<SearchCameraResultProtocol> searchResultDelegate;

public:
	int Open();
	void Close();		
	int SearchDVS();
private:
        void OnMessageProc(char *pszMessage, int iBufferSize,  char *pszIp);
        void ProcMessage(short nType, unsigned short nMessageLen, char *pszMessage);
        void GetNetParam(PBCASTPARAM pstParam);
        void CloseSocket();
	

private:
	static void* ReceiveThread(void * pParam);
	void ReceiveProcess();
    
    static void* SendThread(void * pParam);
    void SendProcess();

private:
	int			m_nSocket;
	bool		m_bRecvThreadRuning;
	pthread_t 	m_RecvThreadID;
    
    int m_bSendThreadRuning;
    pthread_t m_SendThreadID;

	
};

#endif // !defined(AFX_SEARCHDVS_H__C7BA1053_FF01_4C07_A732_0AD16CE7DB7B__INCLUDED_)
