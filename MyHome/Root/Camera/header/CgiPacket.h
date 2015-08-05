#pragma once

#include "P2P_API_Define.h"

class CCgiPacket
{
public:
	CCgiPacket();
	virtual ~CCgiPacket();

public:
	int SscanfString(const char *pszBuffer , const char *reg , char *szResult);
	int SscanfInt(const char *pszBuffer , const char *reg , int &nResult);

public:
	int UnpacketCameraParam(const char *pszBuffer,STRU_CAMERA_PARAMS &t);
	int UnpacketNetworkParam(const char *pszBuffer,STRU_NETWORK_PARAMS &t);
	int UnpacketUserinfo(const char *pszBuffer,STRU_USER_INFO &t);
	int UnpacketDatetimeParam(const char *pszBuffer,STRU_DATETIME_PARAMS &t);
	int UnpacketDdnsParam(const char *pszBuffer,STRU_DDNS_PARAMS &t);
	int UnpacketFtpParam(const char *pszBuffer,STRU_FTP_PARAMS &t);
	int UnpacketMailParam(const char *pszBuffer,STRU_MAIL_PARAMS &t);
	int UnpacketPtzParam(const char *pszBuffer,STRU_PTZ_PARAMS &t);
	int UnpacketWifiSearchResult(const char *pszBuffer,STRU_WIFI_SEARCH_RESULT_LIST &t);
    int UnpacketWifiParams(const char *pszBuffer, STRU_WIFI_PARAMS &t);
    int UnpacketStatusParam(const char *pszBuffer, STRU_CAMERA_STATUS &t);
    int UppacketAlarmParams(const char *pszBuffer, STRU_ALARM_PARAMS &t) ;
    int UnpacketSdCardRecordFileList(const char * pszBuffer,STRU_RECORD_FILE_LIST & t);
    int UnpacketSdCardRecordParam(const char * pszBuffer,STRU_SD_RECORD_PARAM & t);

	int  UnpacketSetResult(const char *pszBuffer);
    int UnpacketDDNSDatetimeParam(const char *pszBuffer,STRU_DATETIME_PARAMS &t);
};