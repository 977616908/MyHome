//
//  CameraDBUtils.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DBSelectResultProtocol.h"

@interface CameraDBUtils : NSObject {
    
    
    sqlite3 *db;
    NSString *DatabaseName;
    NSString *TableName;
    NSString *IpTableName;
    id<DBSelectResultProtocol> selectDelegate;
}

@property (nonatomic, copy) NSString *DatabaseName;
@property (nonatomic, copy) NSString *TableName;
@property (nonatomic,copy) NSString *IpTableName;
@property (nonatomic, retain) id<DBSelectResultProtocol> selectDelegate;

- (BOOL)Open:(NSString *)dbName TblName:(NSString *)tblName  IPTblName:(NSString *)iptblName;

- (void)Close;
- (BOOL)OpenDatabase:(NSString *)dbName;
- (BOOL)CreateTable:(NSString *)tbName;
- (BOOL)CreateIpTable:(NSString *)tbName;
- (NSString *)DatabaseFilePath:(NSString *)dbName;
- (BOOL)InsertCamera:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd ;
- (BOOL)InsertIpCamera:(NSString *)name Ip:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd ;
- (BOOL) UpdateCamera:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd OldDID:(NSString *)olddid ;
- (BOOL) UpdateIpCamera:(NSString *)name Ip:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd OldIp:(NSString *)oldip ;
- (BOOL) RemoveCamera:(NSString *)did;
- (BOOL) RemoveCameraByIp:(NSString *)ip;
- (void) SelectAll;
- (void) SelectIpAll;

@end
