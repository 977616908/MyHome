//
//  CPathManagement.m
//  P2PCamera
//
//  Created by mac on 12-11-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PicPathManagement.h"


#define STR_DIC_DID "did"
#define STR_DIC_DATE_ARRAY "date"
#define STR_DIC

@implementation PicPathManagement

- (id) init {
    self = [super init];
    if (self) {
        IDArray = [[NSMutableArray alloc] init];

        //database
        picPathDBUtil = [[PicPathDBUtils alloc] init];
        picPathDBUtil.selectDelegate = self;
        [picPathDBUtil Open:@"OBJ_P2P_CAMERA_DB" TblName:@"OBJ_P2P_PICPATH_TABLE"];
        [picPathDBUtil SelectAll];
    }
   
    return self;
}

- (void) dealloc
{
    if (IDArray != nil) {
//        [IDArray release];
        IDArray = nil;
    }

//    [super dealloc];
}
-(void)reSelectAll{
    [IDArray removeAllObjects];
    [picPathDBUtil SelectAll];

}
- (BOOL)InsertPicPath:(NSString *)did PicDate:(NSString *)strDate PicPath:(NSString *)strPath
{
    //NSLog(@"InsertPicPath  did: %@, strDate: %@, strPath: %@", did, strDate, strPath);
    
    for (NSDictionary *IDDic in IDArray) {
        //查找是否有该ID号对应的日期数组
        NSMutableArray *dateArray = [IDDic objectForKey:did];
        //如果ID存在
        if (dateArray != nil) {
            for (NSDictionary *DateDic in dateArray) {
                NSMutableArray *picArray = [DateDic objectForKey:strDate];
                //日期在日期数组中已经存在
                if (picArray != nil) {
                    for(NSString *_path in picArray){
                        //图片路径在路径数组中已经存在
                        if ([_path caseInsensitiveCompare:strPath] == NSOrderedSame) {
                       
                            return NO;
                        }
                    }
                    
                    //图片在路径数组中不存在
                    [picArray addObject:strPath];
                    return [picPathDBUtil InsertPath:did PicDate:strDate Path:strPath];
                }
                
            }
            
            //如果日期数组中不存在该日期
            NSMutableArray *_picArray = [[NSMutableArray alloc] init];
            [_picArray addObject:strPath];
            NSDictionary *_dateDic = [NSDictionary dictionaryWithObject:_picArray forKey:strDate];
            [dateArray addObject:_dateDic];
//            [_picArray release];
            return [picPathDBUtil InsertPath:did PicDate:strDate Path:strPath];
            
        }
        
    }
    
    //如果ID数组中不存在该ID号
    NSMutableArray *_dateArray = [[NSMutableArray alloc] init];
    NSMutableArray *_picArray = [[NSMutableArray alloc] init];
    [_picArray addObject:strPath];
    NSDictionary *_dateDic = [NSDictionary dictionaryWithObject:_picArray forKey:strDate];
    [_dateArray addObject:_dateDic];
    
    NSDictionary *_idDic = [NSDictionary dictionaryWithObject:_dateArray forKey:did];
    [IDArray addObject:_idDic];
    
//    [_picArray release];
//    [_dateArray release];
    
    return [picPathDBUtil InsertPath:did PicDate:strDate Path:strPath];
    
}

- (BOOL)InitInsertPicPath:(NSString *)did PicDate:(NSString *)strDate PicPath:(NSString *)strPath
{
    //NSLog(@"InsertPicPath  did: %@, strDate: %@, strPath: %@", did, strDate, strPath);
    
    for (NSDictionary *IDDic in IDArray) {
        //查找是否有改ID号对应的日期数组
        NSMutableArray *dateArray = [IDDic objectForKey:did];
        //如果ID存在
        if (dateArray != nil) {
            for (NSDictionary *DateDic in dateArray) {
                NSMutableArray *picArray = [DateDic objectForKey:strDate];
                //日期在日期数组中已经存在
                if (picArray != nil) {
                    for(NSString *_path in picArray){
                        //图片路径在路径数组中已经存在
                        if ([_path caseInsensitiveCompare:strPath] == NSOrderedSame) {
                            
                            return NO;
                        }
                    }
                    
                    //图片在路径数组中不存在
                    [picArray addObject:strPath];
                    //return [picPathDBUtil InsertPath:did PicDate:strDate Path:strPath];
                    return TRUE;
                }
                
                
            }
            
            //如果日期数组中不存在该日期
            NSMutableArray *_picArray = [[NSMutableArray alloc] init];
            [_picArray addObject:strPath];
            NSDictionary *_dateDic = [NSDictionary dictionaryWithObject:_picArray forKey:strDate];
            [dateArray addObject:_dateDic];
//            [_picArray release];
            //return [picPathDBUtil InsertPath:did PicDate:strDate Path:strPath];
            return TRUE;
            
        }
        
    }
    
    //如果ID数组中不存在该ID号
    NSMutableArray *_dateArray = [[NSMutableArray alloc] init];
    NSMutableArray *_picArray = [[NSMutableArray alloc] init];
    [_picArray addObject:strPath];
    NSDictionary *_dateDic = [NSDictionary dictionaryWithObject:_picArray forKey:strDate];
    [_dateArray addObject:_dateDic];
    
    NSDictionary *_idDic = [NSDictionary dictionaryWithObject:_dateArray forKey:did];
    [IDArray addObject:_idDic];
    
//    [_picArray release];
//    [_dateArray release];
    
    //return [picPathDBUtil InsertPath:did PicDate:strDate Path:strPath];
    return TRUE;
    
}

- (NSMutableArray*) GetTotalPicDataArray:(NSString *)did
{
    //NSLog(@"GetTotalPicDataArray %@", did);
    
    for(NSDictionary *idDic in IDArray){
        NSMutableArray *_dateArray = [idDic objectForKey:did];
        if (_dateArray != nil) {
            return _dateArray;
        }
    }
    
    return nil;
}

- (NSMutableArray*) GetTotalPathArray: (NSString*)did date:(NSString*)date
{
    //NSLog(@"GetTotalPathArray did:%@, date: %@", did, date);
    
    NSMutableArray *dateArray = [self GetTotalPicDataArray:did];
    if (dateArray == nil) {
        return nil;
    }
    
    for (NSDictionary *dateDic in dateArray)
    {
        //NSArray *arr = [dateDic allKeys];
        //NSLog(@"arr: %@", [arr objectAtIndex:0]);
        
        NSMutableArray *picArray = [dateDic objectForKey:date];
        if (picArray != nil) {
            return picArray;
        }
    }
    
    return nil;
}

- (BOOL) DeleteFileByName : (NSString*) did fileName: (NSString*)fileName
{
    @try {
        //创建文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];    
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
        
        NSString *strPath = [documentsDirectory stringByAppendingPathComponent:did];

        //更改到待操作的目录下
        [fileManager changeCurrentDirectoryPath: strPath];
        
        //删除
        [fileManager removeItemAtPath:fileName error:nil];

    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        
    }
    
    return YES;
}

- (BOOL)RemovePicPath:(NSString *)did PicDate:(NSString *)strDate PicPath:(NSString *)strPath
{
    for (NSDictionary *IDDic in IDArray) 
    {
        //查找是否有改ID号对应的日期数组
        NSMutableArray *dateArray = [IDDic objectForKey:did];
        if (dateArray != nil) 
        {
            for (NSDictionary *DateDic in dateArray) 
            {
                NSMutableArray *pathArray = [DateDic objectForKey:strDate];
                if (pathArray != nil) 
                {
                    for (NSString *fileName in pathArray)
                    {
                        if ([strPath caseInsensitiveCompare:fileName] == NSOrderedSame) 
                        {                            
                            //delete file
                            [self DeleteFileByName:did fileName:fileName];
                            
                            //dalete info in database
                            [picPathDBUtil RemovePath: fileName];
                            
                            //find the file
                            [pathArray removeObject:fileName];
                  
                            
                            return YES;
                            
                        }
                    }
                }
            }
        }
    }
    
    return NO;
}

- (BOOL) DeleteFileByID: (NSString*)did
{
    NSLog(@"DeleteFileByID did: %@", did);
    @try {
        //创建文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];    
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
        
        //NSString *strPath = [documentsDirectory stringByAppendingPathComponent:did];
        
        //更改到待操作的目录下
        [fileManager changeCurrentDirectoryPath: documentsDirectory];
        
        //删除
        [fileManager removeItemAtPath:did error:nil];
        
    }
    @catch (NSException *exception) {
        NSLog(@"DeleteFileByID return NO");
        return NO;
    }
    @finally {
        
    }
    
    return YES;
    
}
//kaven 
-(NSDictionary *) GetPicCountAndFirstPicByID:(NSString *)strDID{
    //NSLog(@"GetPicCountAndFirstPicByID 111111111111");

    int count=[self GetTotalNumByID:strDID];
    NSNumber *sum=[NSNumber numberWithInt:count];
    UIImage *img=nil;
    for (NSDictionary *IDDic in IDArray) {
        //查找是否有改ID号对应的日期数组
        NSMutableArray *dateArray = [IDDic objectForKey:strDID];
        if(dateArray!=nil){
            img=[IDDic objectForKey:@"img"];
            break;
        }
    }
    NSDictionary *picDic=[NSDictionary dictionaryWithObjectsAndKeys:sum,@"sum",img,@"img",nil];
//    [picDic retain];
//    [picDic autorelease];
    return picDic;
}
-(void)updateImgByDID:(UIImage *)myImg DID:(NSString *)did{
   // NSLog(@"updateImgByDID 00000000000");
    int count=IDArray.count;
    int i;
    for (i=0;i<count;i++) {
        //查找是否有改ID号对应的日期数组
        NSDictionary *IDDic=[IDArray objectAtIndex:i];
        NSMutableArray *dateArray = [IDDic objectForKey:did];
        if(dateArray!=nil){
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:dateArray,did,myImg,@"img", nil];
            
            [IDArray replaceObjectAtIndex:i withObject:dic];
            return;
        }
    }

}
//kaven
- (NSInteger) GetTotalNumByID:(NSString *)strDID
{
    
    int nTotalNum = 0;
    
    for (NSDictionary *idDic in IDArray)
    {
        NSMutableArray *dateArray = [idDic objectForKey:strDID];
        if (dateArray != nil) {
            for (NSDictionary *dateDic in dateArray)
            {
                NSMutableArray *pathArray = [[dateDic allValues] objectAtIndex:0];
                if (pathArray != nil) {
                    nTotalNum += [pathArray count]; 
                }
                
            }
            
            return nTotalNum;
        }
    }
    
    return 0;
}

- (NSInteger) GetTotalNumByIDAndDate:(NSString *)strDID Date:(NSString *)strDate
{
    
    for (NSDictionary *idDic in IDArray)
    {
        NSMutableArray *dateArray = [idDic objectForKey:strDID];
        if (dateArray != nil) {
            for (NSDictionary *dateDic in dateArray)
            {
                NSMutableArray *pathArray = [dateDic objectForKey:strDate];
                if (pathArray != nil) {
                    return [pathArray count];
                }
                
            }
            
            return 0;
            
        }
    }
    
    return 0;
}

- (NSString*) GetFirstPathByID:(NSString *)strDID
{
    for (NSDictionary *idDic in IDArray)
    {
        NSMutableArray *dateArray = [idDic objectForKey:strDID];
        if (dateArray != nil) {
            for (NSDictionary *dateDic in dateArray)
            {
                NSMutableArray *pathArray = [[dateDic allValues] objectAtIndex:0];
                if (pathArray != nil && pathArray.count > 0) {
                    NSString *strPath = [pathArray objectAtIndex:0];
                    if (strPath != nil) {
                        return strPath;
                    }
                }
                
            }
            
            return nil;
            
            
        }
    }
    
    return nil;
    
}

- (NSString*) GetFirstPathByIDAndDate:(NSString *)strDID Date:(NSString *)strDate
{
    for (NSDictionary *idDic in IDArray)
    {
        NSMutableArray *dateArray = [idDic objectForKey:strDID];
        if (dateArray != nil) {
            for (NSDictionary *dateDic in dateArray)
            {
                NSMutableArray *pathArray = [dateDic objectForKey:strDate];
                if (pathArray != nil && pathArray.count > 0) {
                    NSString *strPath = [pathArray objectAtIndex:0];
                    return strPath;
                }
                
                
            }
            
            return nil;
   
            
        }
    }
    
    return nil;
}

- (BOOL) RemovePicPathByID:(NSString *)did
{
    NSLog(@"RemovePicPathByID did: %@", did);
    
    [picPathDBUtil RemovePathByID:did];
    [self DeleteFileByID:did];
    
    for (NSDictionary *idDic in IDArray)
    {
        NSMutableArray *dateArray = [idDic objectForKey:did];
        if (dateArray != nil) {
            //NSLog(@"111111");
            [IDArray removeObject:idDic];
            //[picPathDBUtil RemovePathByID:did];
            //[self DeleteFileByID:did];
            return YES;
        }
        
    }
    return NO;
}

#pragma mark -
#pragma mark PathSeleteDelegate

- (void) PathSelectResult:(NSString *)did Date:(NSString *)Date Path:(NSString *)Path
{
    //NSLog(@"PathSelectResult... did: %@  Date: %@ Path: %@", did, Date, Path);
    
    [self InitInsertPicPath:did PicDate:Date PicPath:Path];
    
}

@end
