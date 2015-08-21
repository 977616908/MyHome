//
//  FileHelpers.m
//  AAPinChe
//
//  Created by Reese on 13-1-17.
//  Copyright (c) 2013年 Himalayas Technology&Science Company CO.,LTD-重庆喜玛拉雅科技有限公司. All rights reserved.
//

#import "FileHelpers.h"


FOUNDATION_EXPORT NSString *pathInDocumentDirectory(NSString *fileName){
    
    //获取沙盒中的文档目录
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    NSString *documentDirectory=[documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:fileName];
}


FOUNDATION_EXPORT NSString *pathInCacheDirectory(NSString *fileName){
    //获取沙盒中缓存文件目录
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    
    //将传入的文件名加在目录路径后面并返回
    return [cacheDirectory stringByAppendingPathComponent:fileName];
}


//根据URL的hash码为图片文件命名
FOUNDATION_EXPORT NSString *pathForURL(NSURL *aURL){
    return pathInCacheDirectory([NSString stringWithFormat:@"com.pifii/cachedImage-%u", [[aURL description] hash]]);
}

FOUNDATION_EXPORT NSString *pathForString(NSString *aString){
   return pathInCacheDirectory([NSString stringWithFormat:@"com.pifii/cachedImage-%u", [aString hash]]);
}

//判断是否已经缓存过这个URL
FOUNDATION_EXPORT BOOL hasCachedImage(NSURL *aURL){
    
NSFileManager *fileManager=[NSFileManager defaultManager];
    
if ([fileManager fileExistsAtPath:pathForURL(aURL)]) {
    return YES;
}
else return NO;
    
}


FOUNDATION_EXPORT BOOL hasCachedImageWithString(NSString *aURL){
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:pathForString(aURL)]) {
        return YES;
    }
    else return NO;
}

FOUNDATION_EXPORT NSString *hashCodeForURL(NSURL *aURL)
{
    return [NSString stringWithFormat:@"%u",[[aURL description]hash]];
}

FOUNDATION_EXPORT NSString *hashCodeForString(NSString *aURL){
    return [NSString stringWithFormat:@"%u",[aURL hash]];
}

