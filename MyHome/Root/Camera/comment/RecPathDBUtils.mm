//
//  CameraDBUtils.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-24.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RecPathDBUtils.h"


@implementation RecPathDBUtils

@synthesize DatabaseName;
@synthesize TableName;
@synthesize selectDelegate;



- (BOOL)Open:(NSString *)dbName TblName:(NSString *)tblName
{
    self.DatabaseName = dbName;
    self.TableName = tblName;
    
    if (NO == [self OpenDatabase:dbName])
    {
        return NO;
    }
    
    if (NO == [self CreateTable:tblName])
    {
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

- (BOOL) CreateTable:(NSString *)tbName
{
    char createTableSql[256];
    memset(createTableSql, 0, sizeof(createTableSql));
    sprintf(createTableSql, "CREATE TABLE IF NOT EXISTS %s(ID INTEGER PRIMARY KEY AUTOINCREMENT, did text, pictime text, path text)",
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



- (BOOL)InsertPath:(NSString *)did Date:(NSString*)strDate Path:(NSString *)strPath
{
    sqlite3_stmt *statement;
    char insertSql[256];
    memset(insertSql, 0, sizeof(insertSql));
    sprintf(insertSql, "INSERT INTO %s(did,pictime,path) VALUES(?,?,?)",[TableName UTF8String]);
    
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
  
    sqlite3_bind_text(statement, 1, [did UTF8String], -1, nil);
    sqlite3_bind_text(statement, 2, [strDate UTF8String], -1, nil);
    sqlite3_bind_text(statement, 3, [strPath UTF8String], -1, nil);
    
    int sqlOK = sqlite3_step(statement);
    sqlite3_finalize(statement);
    if (sqlOK == SQLITE_DONE) {
        //NSLog(@"insert success!");
        return YES;
    }else {
        //NSLog(@"insert failed!");
        return NO;
    }

}

- (BOOL) RemovePath:(NSString *)strPath
{
    char deleteSql[128];
    memset(deleteSql, 0, sizeof(deleteSql));
    sprintf(deleteSql, "DELETE FROM %s WHERE path=?", [TableName UTF8String]);    
   
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
    
    sqlite3_bind_text(statement, 1, [strPath UTF8String], -1, SQLITE_TRANSIENT);
    
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

- (BOOL) RemovePathByID:(NSString *)did
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
    
    //NSLog(@"RemovePathByID deleteSql: %s", deleteSql);
    
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
        char *str_did = (char*)sqlite3_column_text(statement, 1);
        char *str_date = (char*)sqlite3_column_text(statement, 2);
        char *str_path = (char*)sqlite3_column_text(statement, 3);
        
        //NSLog(@"result.. _id: %d name: %s  pwd: %s", _id, str_name,str_pwd);
        
        NSString *nsDID = [NSString stringWithUTF8String:str_did];
        NSString *nsDate = [NSString stringWithUTF8String:str_date];
        NSString *nsPath = [NSString stringWithUTF8String:str_path];        
        
        [self.selectDelegate PathSelectResult:nsDID Date:nsDate Path:nsPath];
        
//        [pool release];        

    }
    
    sqlite3_finalize(statement);
        
}



- (void) dealloc
{
    self.DatabaseName = nil;
    self.TableName = nil;
    self.selectDelegate = nil;
//    [super dealloc];
}

@end
