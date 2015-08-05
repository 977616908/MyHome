//
//  APICommon.m
//  P2PCamera
//
//  Created by Tsang on 12-12-11.
//
//

#import "APICommon.h"

#import "CustomAVRecorder.h"


@implementation APICommon

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    NSData *dataImg = UIImageJPEGRepresentation(newImage, 1);
    UIImage *imgOK = [UIImage imageWithData:dataImg];
    
    // Return the new image.
    return imgOK;
}

+ (UIImage*) GetImageByNameFromImage: (NSString*)did filename:(NSString*)filename
{
    //NSLog(@"APICommon   GetImageByNameFromImage 11111111111");
    if (did == nil || filename == nil) {
        return nil;
    }
     
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:did];
    strPath = [strPath stringByAppendingPathComponent:filename];
    //NSLog(@"strPath: %@", strPath);
    
    UIImage *image = [UIImage imageWithContentsOfFile:strPath];
    if (image==nil) {
        NSLog(@"APICommon...image==nil");
        return nil;
    }
    return [self imageWithImage:image scaledToSize:CGSizeMake(75, 75)];
    
}

+ (UIImage*) GetImageByName: (NSString*)did filename:(NSString*)filename
{
    NSLog(@"GetImageByName did=%@ fileName=%@",did,filename);
    if (did == nil || filename == nil) {
        
        return nil;
    }
    
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    
    NSString *strPath = [documentsDirectory stringByAppendingPathComponent:did];
    strPath = [strPath stringByAppendingPathComponent:filename];
    //NSLog(@"strPath: %@", strPath);
    
    UIImage *image = [self GetFirstImageFromRecordFile:strPath];
    if (image == nil) {
        NSLog(@"APICommon GetImageByName()  image==nil");
        return nil;
    }
    
    
    return [self imageWithImage:image scaledToSize:CGSizeMake(75, 75)];
    
}

#define RGB565_MASK_RED        0xF800
#define RGB565_MASK_GREEN                         0x07E0
#define RGB565_MASK_BLUE                         0x001F

void rgb565_2_rgb24(unsigned char *rgb24, unsigned short rgb565)
{
    //extract RGB
    rgb24[0] = (rgb565 & RGB565_MASK_RED) >> 11;
    rgb24[1] = (rgb565 & RGB565_MASK_GREEN) >> 5;
    rgb24[2] = (rgb565 & RGB565_MASK_BLUE);
    
    //plify the image
    rgb24[0] <<= 3;
    rgb24[1] <<= 2;
    rgb24[2] <<= 3;
}

void RGB565toRGB888(unsigned char *rgb565, unsigned char* rgb888, int width, int height)
{
    int i;
    int j;
    for (i = 0; i < height; i++) {
        unsigned char *pSrc = rgb565 + (width * 2) * i;
        unsigned char *pDes = rgb888 + (width * 3) * i;
        for (j = 0; j < width ; j++) {
            rgb565_2_rgb24(pDes + j * 3, *((unsigned short*)(pSrc + j * 2)));
        }
    }
    
}

+ (UIImage*) RGB888toImage: (Byte*)rgb888 width:(int)width height:(int)height
{
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    
    CFDataRef dataRef = CFDataCreate(kCFAllocatorDefault, rgb888, width*height*3);
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(dataRef);
    
    //CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, rgb888, width*height*3, NULL);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImage = CGImageCreate(width,
                                       height,
                                       8,
                                       24,
                                       width*3,
                                       colorSpace,
                                       bitmapInfo,
                                       provider,
                                       NULL,
                                       NO,
                                       kCGRenderingIntentDefault);
    CGColorSpaceRelease(colorSpace);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    //UIImage *image = [[[UIImage alloc] initWithCGImage:cgImage] autorelease];
    
    CGImageRelease(cgImage);
    CGDataProviderRelease(provider);
    CFRelease(dataRef);
    
    //NSLog(@"width: %f, height: %f", image.size.width, image.size.height);
    return image;
    
    
}

+ (UIImage*) YUV420ToImage: (Byte*)yuv width:(int)width height:(int)height
{
  
    //yuv420-->rgb565
    unsigned char *pRGB = new unsigned char[width * height * 2];

    CH264Decoder *pH264Decoder=new CH264Decoder();
   
    pH264Decoder->YUV4202RGB565(yuv, pRGB, width, height);
    //rgb565-->rgb888
    unsigned char * pRGB888 = new unsigned char[width * height * 3];
    
    RGB565toRGB888(pRGB, pRGB888, width, height);
    
    //rgb888-->image
    UIImage *image = [self RGB888toImage:pRGB888 width:width height:height];
    
    SAFE_DELETE(pRGB);
    SAFE_DELETE(pRGB888);
    delete pH264Decoder;
    pH264Decoder=NULL;
    return image;

}
+ (UIImage*) GetFirstImageFromRecordFile: (NSString*) strRecPath
{
    
    FILE *pfile = NULL;
    pfile = fopen([strRecPath UTF8String], "rb");
    if (pfile == NULL) {
        return nil;
    }
    
    STRU_REC_FILE_HEAD filehead;
    memset(&filehead, 0, sizeof(filehead));
    
    if (sizeof(filehead) != fread((char*)&filehead, 1, sizeof(filehead), pfile)) {
        fclose(pfile);
        pfile = NULL;
        return nil;
    }
    
    if (filehead.head != 0xff00ff00) {
        fclose(pfile);
        pfile = NULL;
        return nil;
    }
    
    STRU_DATA_HEAD datahead;
    memset(&datahead, 0, sizeof(datahead));
    if (sizeof(datahead) != fread((char*)&datahead, 1, sizeof(datahead), pfile)) {
        fclose(pfile);
        pfile = NULL;
        return nil;
    }
    
    if (datahead.head != 0xffff0000) {
        fclose(pfile);
        pfile = NULL;
        return nil;
    }
    
    char *pbuf = new char[datahead.datalen];
    if (pbuf == NULL) {
        fclose(pfile);
        pfile = NULL;
        return nil;
    }
    
    if (datahead.datalen != fread(pbuf, 1, datahead.datalen, pfile)) {
        SAFE_DELETE(pbuf);
        fclose(pfile);
        pfile = NULL;
        return nil;
    }
    
    
    
    fclose(pfile);
    pfile = NULL;
    
    UIImage *image = nil;
    
    if (filehead.videoformat == 0) {//MJPEG
        NSData *imageData = [NSData dataWithBytes:pbuf length:datahead.datalen];
        image = [UIImage imageWithData:imageData];
    }else if(filehead.videoformat == 2){
       
         if (datahead.dataformat == 0) { //必须是I帧
             NSLog(@"APICommon  GetFirstImageFromRecordFile  创建H264Decoder");
             CH264Decoder *pH264Decoder = new CH264Decoder();
           
             int nWidth=0;
             int nHeight=0;
             if (pH264Decoder->DecoderFrame((unsigned char*)pbuf, datahead.datalen, nWidth, nHeight)) {
                 
                 int yuvlen=nWidth*nHeight*3/2;
                  uint8_t *pYUVBuffer = new uint8_t[yuvlen];
                 if (pYUVBuffer!=NULL) {
                    int nRet= pH264Decoder->GetYUVBuffer(pYUVBuffer, yuvlen);//得到h264->yuv420的数据
                     if (nRet>0) {//decode success
                         //yuv420->rgb565
                          unsigned char *pRGB = new unsigned char[nWidth * nHeight * 2];
                         pH264Decoder->YUV4202RGB565(pYUVBuffer, pRGB, nWidth, nHeight);
                         unsigned char * pRGB888 = new unsigned char[nWidth * nHeight * 3];
                         RGB565toRGB888(pRGB, pRGB888, nWidth, nHeight);
                         image = [self RGB888toImage:pRGB888 width:nWidth height:nHeight];
                         SAFE_DELETE(pRGB);
                         SAFE_DELETE(pRGB888);
                     }
                     
                 }
                 SAFE_DELETE(pYUVBuffer);
             }
             delete pH264Decoder;
             pH264Decoder=NULL;
         }
    
    }
    
    SAFE_DELETE(pbuf);
    return image;

}

@end
