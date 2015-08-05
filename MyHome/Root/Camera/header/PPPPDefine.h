
#ifndef _PPPP_DEFINE_H_
#define _PPPP_DEFINE_H_

//PPPP Channel definition
#define P2P_CMDCHANNEL   0
#define P2P_VIDEOCHANNEL    1
#define P2P_AUDIOCHANNEL    2
#define P2P_TALKCHANNEL  3
#define P2P_PLAYBACK     4


//Command buffer size
#define COMMAND_BUFFER_SIZE         32*1024

//Command head
typedef struct _CMD_BUF_HEAD
{
    int head;
    int len;
    int res1;
    int res2;
}CMD_BUF_HEAD, *PCMD_BUF_HEAD;

//buffer head
#define BUFFER_HEAD_CODE 0xffffff

//Command Channel head
typedef struct _CMD_CHANNEL_HEAD
{
    unsigned short startcode;
    unsigned short cmd;
    unsigned short len;
    unsigned short version;
}CMD_CHANNEL_HEAD, *PCMD_CHANNEL_HEAD;

//startcode
#define CMD_START_CODE 0x0a01

#define MIN_PCM_AUDIO_SIZE 1024

#define TALK_WRITE_BUFFER_MAX_SIZE 32*1024

//pppp write buffer max size
#define PPPP_WRITE_BUFFER_MAX_SIZE  1024 * 1024

//msgtype
#define MSG_NOTIFY_TYPE_PPPP_STATUS 0   /* pppp status */
#define MSG_NOTIFY_TYPE_PPPP_MODE 1   /* pppp mode */

//pppp status
#define PPPP_STATUS_CONNECTING 0 /* connecting */
#define PPPP_STATUS_INITIALING 1 /* initialing */
#define PPPP_STATUS_ON_LINE 2 /* on line */
#define PPPP_STATUS_CONNECT_FAILED 3 /* connect failed */
#define PPPP_STATUS_DISCONNECT 4 /*connect is off*/
#define PPPP_STATUS_INVALID_ID 5 /* invalid id */
#define PPPP_STATUS_DEVICE_NOT_ON_LINE 6
#define PPPP_STATUS_CONNECT_TIMEOUT 7 /* connect timeout */
#define PPPP_STATUS_INVALID_USER_PWD 8
#define PPPP_STATUS_UNKNOWN 0xffffff //未知

//pppp mode
#define PPPP_MODE_P2P 1
#define PPPP_MODE_RELAY 2
#define PPPP_MODE_UNKNOWN 0xffffff



#endif
