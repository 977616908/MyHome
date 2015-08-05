//
//  SdcardScheduleProtocol.h
//  P2PCamera
//
//  Created by Tsang on 13-1-14.
//
//

#import <Foundation/Foundation.h>

@protocol SdcardScheduleProtocol <NSObject>
-(void)sdcardScheduleParams:(NSString *)did Tota:(int)total  RemainCap:(int)remain SD_status:(int)status Cover:(int) cover_enable TimeLength:(int)timeLength FixedTimeRecord:(int)ftr_enable RecordSize:(int)recordSize;
@end
