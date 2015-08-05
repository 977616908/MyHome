//
//  SDCardRecordFileSearchProtocol.h
//  P2PCamera
//
//  Created by mac on 12-11-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDCardRecordFileSearchProtocol <NSObject>

- (void) SDCardRecordFileSearchResult: (NSString *) strFileName fileSize: (NSInteger) fileSize fileTime:(NSInteger)fileTime bEnd: (BOOL) bEnd PageCount:(int)pagecount;

@end
