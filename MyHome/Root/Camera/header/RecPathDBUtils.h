//
//  CameraDBUtils.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PathSelectResultProtocol.h"

@interface RecPathDBUtils : NSObject {

    sqlite3 *db;
    NSString *DatabaseName;
    NSString *TableName;
    
    id<PathSelectResultProtocol> selectDelegate;
}

@property (nonatomic, copy) NSString *DatabaseName;
@property (nonatomic, copy) NSString *TableName;
@property (nonatomic, retain) id<PathSelectResultProtocol> selectDelegate;

- (BOOL)Open:(NSString *)dbName TblName:(NSString *)tblName;
- (void)Close;
- (BOOL)InsertPath:(NSString *)did Date:(NSString*)strDate Path:(NSString *)strPath;
- (BOOL)RemovePath:(NSString *)strPath;
- (BOOL)RemovePathByID: (NSString*)did;
- (void)SelectAll;

                                                                                                          

@end
