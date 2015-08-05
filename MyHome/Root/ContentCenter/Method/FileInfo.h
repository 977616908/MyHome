//
//  FileInfo.h
//  MyHome
//
//  Created by HXL on 15/1/13.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileInfo : NSObject
@property (nonatomic,copy)NSString      *fileName;
@property (nonatomic,copy)NSString      *filePath;
@property (nonatomic,assign)NSInteger      fileErrorCode;
@property (nonatomic,copy)NSString      *fileDownloadProgress;
@property (nonatomic,copy)NSString      *fileStatus;
@property (nonatomic,assign)NSInteger      fileLength;
@property (nonatomic,copy)NSString      *fileTaskID;
@property (nonatomic,copy)NSString      *fileSuffix;
@property (nonatomic,copy)NSString      *fileSize;
@property (nonatomic,copy)NSString      *fileUpDate;
@property (nonatomic,assign)BOOL           isCanPlayOrOpen;
@property (nonatomic,copy)NSString      *fileAddTime;
@property (nonatomic,copy)NSString      *fileFinishPercent;    /**<文件完成百分比*/
@property (nonatomic,assign)long long     fileFinishedSize;     /**<文件已经缓存的大小*/

@end
