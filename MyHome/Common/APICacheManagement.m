//
//  APICacheManagement.m
//  FlowTT_Home
//
//  Created by Harvey on 14-4-17.
//  Copyright (c) 2014年 Harvey. All rights reserved.
//

#import "APICacheManagement.h"

@implementation APICacheManagement

+ (void)writeToCacheWithData:(id)data CacheName:(NSString *)cName
{
   NSData *_data = nil;
    if ([data isKindOfClass:[NSDictionary class]]) {
        
        _data = [data JSONData];
    }
    if ([data isKindOfClass:[NSString class]]) {
        
        _data = [data stringConvertData];
    }
    if ([data isKindOfClass:[NSData class]]) {
        
        _data = data;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/APIDataCaches",NSHomeDirectory()];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm isExecutableFileAtPath:path]) {
        
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    path = [path stringByAppendingPathComponent:cName];
    [fm createFileAtPath:path contents:_data attributes:nil];
}

+ (NSData *)readCacheWithCacheName:(NSString *)cName
{
    NSString *path = [NSString stringWithFormat:@"%@/Library/Caches/APIDataCaches/%@",NSHomeDirectory(),cName];
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
       
        return nil;
    }
    return [handle readDataToEndOfFile];
}
@end
