//
//  CameraDBUtils.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraDBUtils.h"


@implementation CameraDBUtils

@synthesize DatabaseName;
@synthesize TableName;
@synthesize selectDelegate;
@synthesize IpTableName;
- (BOOL)Open:(NSString *)dbName TblName:(NSString *)tblName IPTblName:(NSString *)iptblName
{
    self.DatabaseName = dbName;
    self.TableName = tblName;
    self.IpTableName=iptblName;
    if (NO == [self OpenDatabase:dbName])
    {
        return NO;
    }
    
    if (NO == [self CreateTable:tblName])
    {
        [self Close];
        return NO;
    }
    if (NO==[self CreateIpTable:iptblName]) {
        [self Close];
        return NO;
    }
    return YES;
}

- (void)Close
{
    sqlite3_close(db);
}


- (NSString *)DatabaseFilePath:(NSString *)dbName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask
                                                         , YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentDirectory stringByAppendingPathComponent:dbName];
    
    //NSLog(@"databasePath: %@", databasePath);
    
    return databasePath;
    
}
-(BOOL)CreateIpTable:(NSString *)tbName{
    char createTableSql[256];
    memset(createTableSql, 0, sizeof(createTableSql));
    sprintf(createTableSql, "CREATE TABLE IF NOT EXISTS %s(ID INTEGER PRIMARY KEY AUTOINCREMENT,name text, ip text,port text, user text, pwd text)",
            [tbName UTF8String]);
    sqlite3_stmt *statement;
    NSInteger SqlOK = sqlite3_prepare(db,
                                      createTableSql,
                                      -1,
                                      &statement,
                                      NULL);
    if (SqlOK == SQLITE_OK) {
        //NSLog(@"prepare sql is success!");
    }else {
        //NSLog(@"prepare sql is failed!");
        return NO;
    }
    
    int sqlCorrent = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (sqlCorrent == SQLITE_DONE) {
        //NSLog(@"create table success!");
    }else {
        //NSLog(@"create table failed!");
    }
    
    return YES;
}
- (BOOL) CreateTable:(NSString *)tbName
{
    //NSLog(@"CreateTable.....tbName: %@",tbName);
    char createTableSql[256];
    memset(createTableSql, 0, sizeof(createTableSql));
    sprintf(createTableSql, "CREATE TABLE IF NOT EXISTS %s(ID INTEGER PRIMARY KEY AUTOINCREMENT,name text, did text, user text, pwd text)",
            [tbName UTF8String]);
    sqlite3_stmt *statement;
    NSInteger SqlOK = sqlite3_prepare(db,
                                      createTableSql,
                                      -1,
                                      &statement,
                                      NULL);
    if (SqlOK == SQLITE_OK) {
        //NSLog(@"prepare sql is success!");
    }else {
        //NSLog(@"prepare sql is failed!");
        return NO;
    }
    
    int sqlCorrent = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (sqlCorrent == SQLITE_DONE) {
        //NSLog(@"create table success!");
    }else {
        //NSLog(@"create table failed!");
    }
    
    return YES;
}

- (BOOL) OpenDatabase:(NSString *)dbName
{
    NSString *dbPath = [self DatabaseFilePath:dbName];
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK)
    {
        //NSLog(@"database open success!");
        return YES;
    }else
    {
        //NSLog(@"database open failed!");
        return NO;
    }
    return YES;
}
-(BOOL)InsertIpCamera:(NSString *)name Ip:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd{
    sqlite3_stmt *statement;
    char insertSql[256];
    memset(insertSql, 0, sizeof(insertSql));
    sprintf(insertSql, "INSERT INTO %s(name,ip,port,user,pwd) VALUES(?,?,?,?,?)",[IpTableName UTF8String]);
    
    int preOK = sqlite3_prepare(db,
                                insertSql,
                                -1,
                                &statement,
                                nil);
    if (preOK == SQLITE_OK) {
        NSLog(@"prepare insert sql ipcamera is  success!");
    }else {
        NSLog(@"prepare insert sql ipcamera is failed");
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [name UTF8String], -1, nil);
    sqlite3_bind_text(statement, 2, [ip  UTF8String], -1, nil);
    sqlite3_bind_text(statement, 3, [port UTF8String], -1, nil);
    sqlite3_bind_text(statement, 4, [user UTF8String], -1, nil);
    sqlite3_bind_text(statement, 5, [pwd UTF8String], -1, nil);
    int sqlOK = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (sqlOK == SQLITE_DONE) {
        //NSLog(@"insert success!");
        return YES;
    }else {
        //NSLog(@"insert failed!");
        sqlOK = sqlite3_step(statement);
        if (sqlOK == SQLITE_DONE) {
            return YES;
        }
        return NO;
    }
    
}
- (BOOL)InsertCamera:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd
{
    sqlite3_stmt *statement;
    char insertSql[256];
    memset(insertSql, 0, sizeof(insertSql));
    sprintf(insertSql, "INSERT INTO %s(name,did,user,pwd) VALUES(?,?,?,?)",[TableName UTF8String]);
    
    int preOK = sqlite3_prepare(db,
                                insertSql,
                                -1,
                                &statement,
                                nil);
    if (preOK == SQLITE_OK) {
        //NSLog(@"prepare insert sql is success!");
    }else {
        //NSLog(@"prepare insert sql is failed");
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [name UTF8String], -1, nil);
    sqlite3_bind_text(statement, 2, [did UTF8String], -1, nil);
    sqlite3_bind_text(statement, 3, [user UTF8String], -1, nil);
    sqlite3_bind_text(statement, 4, [pwd UTF8String], -1, nil);
    
    int sqlOK = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (sqlOK == SQLITE_DONE) {
        //NSLog(@"insert success!");
        return YES;
    }else {
        //NSLog(@"insert failed!");
        sqlOK = sqlite3_step(statement);
        if (sqlOK == SQLITE_DONE) {
            return YES;
        }
        return NO;
    }
    
}
- (BOOL)UpdateIpCamera:(NSString *)name Ip:(NSString *)ip Port:(NSString *)port User:(NSString *)user Pwd:(NSString *)pwd OldIp:(NSString *)oldip{
    char updateSql[256];
    memset(updateSql, 0, sizeof(updateSql));
    sprintf(updateSql, "UPDATE %s SET name=? , ip=? , port=?, user=? , pwd=?  WHERE ip=?", [IpTableName UTF8String]);
    
    sqlite3_stmt *statement;
    int preOK = sqlite3_prepare(db,
                                updateSql,
                                -1,
                                &statement,
                                nil);
    if (preOK == SQLITE_OK) {
        //NSLog(@"prepare update sql success!");
    }else {
        //NSLog(@"prepare updata sql failed!");
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [ip UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [port UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [user UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [pwd UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 6, [oldip UTF8String], -1, SQLITE_TRANSIENT);
    
    int sqlOK = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (sqlOK == SQLITE_DONE) {
        //NSLog(@"update success!");
    }else {
        //NSLog(@"update failed!");
        return NO;
    }
    
    return YES;
    
}
- (BOOL)UpdateCamera:(NSString *)name DID:(NSString *)did User:(NSString *)user Pwd:(NSString *)pwd OldDID:(NSString *)olddid
{
    char updateSql[256];
    memset(updateSql, 0, sizeof(updateSql));
    sprintf(updateSql, "UPDATE %s SET name=? , did=? , user=? , pwd=?  WHERE did=?", [TableName UTF8String]);
    
    sqlite3_stmt *statement;
    int preOK = sqlite3_prepare(db,
                                updateSql,
                                -1,
                                &statement,
                                nil);
    if (preOK == SQLITE_OK) {
        //NSLog(@"prepare update sql success!");
    }else {
        //NSLog(@"prepare updata sql failed!");
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [did UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, [user UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 4, [pwd UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 5, [olddid UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int sqlOK = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (sqlOK == SQLITE_DONE) {
        //NSLog(@"update success!");
    }else {
        //NSLog(@"update failed!");
        return NO;
    }
    
    return YES;
}
-(BOOL) RemoveCameraByIp:(NSString *)ip{
    char deleteSql[128];
    memset(deleteSql, 0, sizeof(deleteSql));
    
    sprintf(deleteSql, "DELETE FROM %s WHERE ip=?", [IpTableName UTF8String]);
    
    sqlite3_stmt *statement;
    int preOK = sqlite3_prepare(db,
                                deleteSql,
                                -1,
                                &statement,
                                nil);
    
    if (preOK == SQLITE_OK) {
        //NSLog(@"prepare delete sql success!");
    }else {
        //NSLog(@"prepare delete sql failed!");
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [ip UTF8String], -1, SQLITE_TRANSIENT);
    
    int sqlOK = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (sqlOK == SQLITE_DONE) {
        //NSLog(@"delete success!");
    }else {
        //NSLog(@"delete failed!");
        return NO;
    }
    
    return YES;
}
- (BOOL) RemoveCamera:(NSString *)did
{
    char deleteSql[128];
    memset(deleteSql, 0, sizeof(deleteSql));
    sprintf(deleteSql, "DELETE FROM %s WHERE did=?", [TableName UTF8String]);
    
    sqlite3_stmt *statement;
    int preOK = sqlite3_prepare(db,
                                deleteSql,
                                -1,
                                &statement,
                                nil);
    
    if (preOK == SQLITE_OK) {
        //NSLog(@"prepare delete sql success!");
    }else {
        //NSLog(@"prepare delete sql failed!");
        return NO;
    }
    
    sqlite3_bind_text(statement, 1, [did UTF8String], -1, SQLITE_TRANSIENT);
    
    int sqlOK = sqlite3_step(statement);
    sqlite3_finalize(statement);
    
    if (sqlOK == SQLITE_DONE) {
        //NSLog(@"delete success!");
    }else {
        //NSLog(@"delete failed!");
        return NO;
    }
    
    return YES;
}
- (void)SelectIpAll{
    char selectSql[128];
    if (selectDelegate == nil)
    {
        //NSLog(@"selectDelegate == nil");
        return ;
    }
    memset(selectSql, 0, sizeof(selectSql));
    sprintf(selectSql, "SELECT * from %s", [IpTableName UTF8String]);
    
    sqlite3_stmt *statement;
    int preOK = sqlite3_prepare(db,
                                selectSql,
                                -1,
                                &statement,
                                nil);
    if (preOK == SQLITE_OK) {
        //NSLog(@"prepare select sql success!");
    }else {
        //NSLog(@"prepare select sql failed!");
        return ;
    }
    
    while(sqlite3_step(statement)== SQLITE_ROW)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        
        char *str_name = (char*)sqlite3_column_text(statement, 1);
        char *str_ip = (char*)sqlite3_column_text(statement, 2);
        char *str_port = (char*)sqlite3_column_text(statement, 3);
        char *str_user = (char*)sqlite3_column_text(statement, 4);
        char *str_pwd = (char*)sqlite3_column_text(statement, 5);
        
        
        NSString *nsName = [NSString stringWithUTF8String:str_name];
        NSString *nsIp = [NSString stringWithUTF8String:str_ip];
        NSString *nsPort=[NSString stringWithUTF8String:str_port];
        NSString *nsUser = [NSString stringWithUTF8String:str_user];
        NSString *nsPwd = [NSString stringWithUTF8String:str_pwd];
        
        [self.selectDelegate SelectDDNSResult:nsName IP:nsIp Port:nsPort User:nsUser Pwd:nsPwd];
        
//        [pool release];
        
    }
    
    sqlite3_finalize(statement);
}
- (void) SelectAll
{
    char selectSql[128];
    
    //NSLog(@"Call SelectAll");
    
    if (selectDelegate == nil)
    {
        //NSLog(@"selectDelegate == nil");
        return ;
    }
    
    memset(selectSql, 0, sizeof(selectSql));
    sprintf(selectSql, "SELECT * from %s", [TableName UTF8String]);
    
    sqlite3_stmt *statement;
    int preOK = sqlite3_prepare(db,
                                selectSql,
                                -1,
                                &statement,
                                nil);
    if (preOK == SQLITE_OK) {
        //NSLog(@"prepare select sql success!");
    }else {
        //NSLog(@"prepare select sql failed!");
        return ;
    }
    
    while(sqlite3_step(statement)== SQLITE_ROW)
    {
//        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        //  int _id = (int)sqlite3_column_int(statement, 0);
        char *str_name = (char*)sqlite3_column_text(statement, 1);
        char *str_did = (char*)sqlite3_column_text(statement, 2);
        char *str_user = (char*)sqlite3_column_text(statement, 3);
        char *str_pwd = (char*)sqlite3_column_text(statement, 4);
        //        char *str_ip=(char *)sqlite3_column_text(statement, 5);
        //        char *str_port=(char *)sqlite3_column_text(statement, 6);
        //NSLog(@"result.. _id: %d name: %s  pwd: %s", _id, str_name,str_pwd);
        
        NSString *nsName = [NSString stringWithUTF8String:str_name];
        NSString *nsDID = [NSString stringWithUTF8String:str_did];
        NSString *nsUser = [NSString stringWithUTF8String:str_user];
        NSString *nsPwd = [NSString stringWithUTF8String:str_pwd];
        //        NSString *nsIp=[NSString stringWithUTF8String:str_ip];
        //        NSString *nsPort=[NSString stringWithUTF8String:str_port];
        
        [self.selectDelegate SelectP2PResult:nsName DID:nsDID User:nsUser Pwd:nsPwd];
        
//        [pool release];
        
    }
    
    sqlite3_finalize(statement);
    
}

- (void) dealloc
{
    self.DatabaseName = nil;
    self.TableName = nil;
    self.IpTableName=nil;
    self.selectDelegate = nil;
//    [super dealloc];
}

@end
