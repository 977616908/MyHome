

#ifndef _PPPP_CHANNEL_MANAGEMENT_H_
#define _PPPP_CHANNEL_MANAGEMENT_H_

#import <Foundation/Foundation.h>
#import "PPPPChannel.h"
#import "PPPPStatusProtocol.h"


#define MAX_DID_LENGTH 64
#define MAX_PPPP_CHANNEL_NUM 64

typedef struct _PPPP_CHANNEL
{
    char szDID[MAX_DID_LENGTH] ;
    CPPPPChannel *pPPPPChannel;
    CCircleBuf *pVideoBuf;
//    CEGLDisplay *pEglDisplay;
    CCircleBuf *pPlaybackVideoBuf;
    int bValid;    
}PPPP_CHANNEL, *PPPPPCHANNEL;

//using namespace android;

class CPPPPChannelManagement
{
public:
    CPPPPChannelManagement();
    ~CPPPPChannelManagement();
    int Start(const char *szDID, const char *user, const char *pwd);
    int Stop(const char *szDID);
    void StopAll();    
    int StartPPPPLivestream(const char *szDID, int streamid, id delegate);
    int StopPPPPLivestream(const char * szDID);
    int GetCGI(const char * szDID, int cgi);
    int PTZ_Control(const char *szDID, int command);
    int CameraControl(const char *szDID, int param, int value);
    int Snapshot(const char* szDID);
    int StartPPPPAudio(const char *szDID);
    int StopPPPPAudio(const char *szDID);
    int StartPPPPTalk(const char *szDID);
    int StopPPPPTalk(const char *szDID);
    int TalkAudioData(const char *szDID, const char *data,  int len);
    int PPPPSetSystemParams(char * szDID,int type,char * msg,int len);
    int SetWifiParamDelegate(char *szDID, id delegate);
    int SetWifi(char *szDID, int enable, char *szSSID, int channel, int mode, int authtype, int encrypt, int keyformat, int defkey, char *strKey1, char *strKey2, char *strKey3, char *strKey4, int key1_bits, int key2_bits, int key3_bits, int key4_bits, char *wpa_psk);
    
    int SetSDCardSearchDelegate(char *szDID, id delegate);
    int PPPPGetSDCardRecordFileList(char *szDID, int startTime, int endTime);
    
    void SetPlaybackDelegate(char *szDID, id delegate);
    int PPPPStartPlayback(char *szDID, char *szFileName, int offset);
    int PPPPStopPlayback(char *szDID);
    
    int SetUserPwd(char *szDID,char *user1,char *pwd1,char *user2,char *pwd2,char *user3,char *pwd3);
    int SetUserPwdParamDelegate(char *szDID, id delegate);
    
    int SetDateTimeDelegate(char *szDID, id delegate);
    int SetDateTime(char *szDID,int now,int tz,int ntp_enable,char *ntp_svr);
    
    int SetFTPDelegate(char *szDID, id delegate);
    int SetFTP(char *szDID, char *szSvr, char *szUser, char *szPwd, char *dir, int port, int uploadinterval, int mode);
    
    int SetMailDelegate(char *szDID, id delegate);
    int SetMail(char *szDID,
                char *sender,
                char *smtp_svr,
                int smtp_port,
                int ssl,
                int auth,
                char *user,
                char *pwd,
                char *recv1,
                char *recv2,
                char *recv3,
                char *recv4);
    
    
    int SetAlarmDelegate(char *szDID, id delegate);
    int SetAlarm(char *szDID,    
                 int motion_armed,
                 int motion_sensitivity,
                 int input_armed,
                 int ioin_level,
                 int alarmpresetsit,
                 int iolinkage,
                 int ioout_level,
                 int mail,
                 int upload_interval,
                 int record);
    
    int SetSDcardScheduleDelegate(char *szDID,id delegate);
    int SetSDcardScheduleParams(
                                char *szDID,
                                int cover_enable,
                                int timeLength,
                                int fixed_enable,
                                int record_schedule_sun_0,
                                int record_schedule_sun_1,
                                int record_schedule_sun_2,
                                int record_schedule_mon_0,
                                int record_schedule_mon_1,
                                int record_schedule_mon_2,
                                int record_schedule_tue_0,
                                int record_schedule_tue_1,
                                int record_schedule_tue_2,
                                int record_schedule_wed_0,
                                int record_schedule_wed_1,
                                int record_schedule_wed_2,
                                int record_schedule_thu_0,
                                int record_schedule_thu_1,
                                int record_schedule_thu_2,
                                int record_schedule_fri_0,
                                int record_schedule_fri_1,
                                int record_schedule_fri_2,
                                int record_schedule_sat_0,
                                int record_schedule_sat_1,
                                int record_schedule_sat_2);
    
    int FormatSDCard(char *szDID);
    
public:
    
    id pCameraViewController;

private:
    PPPP_CHANNEL m_PPPPChannel[MAX_PPPP_CHANNEL_NUM];
    NSCondition *m_Lock;
};

#endif
