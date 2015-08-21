//
//  FileHelpers.h
//  AAPinChe
//
//  Created by Reese on 13-1-17.
//  Copyright (c) 2013年 Himalayas Technology&Science Company CO.,LTD-重庆喜玛拉雅科技有限公司. All rights reserved.
//  这是一个纯C函数，用于获取应用沙盒文件路径
//

#import <Foundation/Foundation.h>


FOUNDATION_EXPORT NSString *pathInDocumentDirectory(NSString *fileName);
FOUNDATION_EXPORT NSString *pathInCacheDirectory(NSString *fileName);
FOUNDATION_EXPORT NSString *pathForURL(NSURL *aURL);
FOUNDATION_EXPORT BOOL hasCachedImage(NSURL *aURL);
FOUNDATION_EXPORT NSString *hashCodeForURL(NSURL *aURL);


FOUNDATION_EXPORT NSString *pathForString(NSString *aString);
FOUNDATION_EXPORT BOOL hasCachedImageWithString(NSString *aURL);
FOUNDATION_EXPORT NSString *hashCodeForString(NSString *aURL);