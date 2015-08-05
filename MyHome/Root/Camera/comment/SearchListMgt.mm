//
//  SearchListMgt.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchListMgt.h"
#import "obj_common.h"

@implementation SearchListMgt

- (id)init
{
    self = [super init];
    
    if (self != nil) {
        CameraArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (BOOL) AddCamera:(NSString *)mac Name:(NSString *)name Addr:(NSString *)addr Port:(NSString *)port DID:(NSString *)did
{
    if ([self CheckCamere:addr Port:port] == NO) {
        return NO;
    }
    NSDictionary *cameraDic = [NSDictionary dictionaryWithObjectsAndKeys:mac, @STR_MAC , addr, @STR_IPADDR, port, @STR_PORT, did, @STR_DID,name, @STR_NAME, nil];   
    [CameraArray addObject:cameraDic];
    return YES;
}

- (NSDictionary*) GetCameraAtIndex:(NSInteger)index
{
    if (index >= CameraArray.count)
    {
        return nil;
    }
    
    return [CameraArray objectAtIndex:index];
}

- (void) ClearList
{
    [CameraArray removeAllObjects];
}

- (int) GetCount
{
    return CameraArray.count;
}

- (BOOL) CheckCamere:(NSString *)addr Port:(NSString *)port
{
    for (NSDictionary *cameraDic in CameraArray)
    {
        NSString *_addr = [cameraDic objectForKey:@STR_IPADDR];
        NSString *_port = [cameraDic objectForKey:@STR_PORT];
        
        if ([_addr caseInsensitiveCompare:addr] == NSOrderedSame 
            && [_port caseInsensitiveCompare:port] == NSOrderedSame )
        {
            return NO;
        }
    }
    return YES;
}

- (void)dealloc
{
//    [CameraArray release];
    CameraArray = nil;
//    [super dealloc];
}

@end
