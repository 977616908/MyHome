//
//  NSString+MD5Encrypt.h
//  Smile
//
//  Created by Harvey on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

#import "CocoaSecurity.h"
#import "CCGTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation CocoaSecurity

+ (NSString*)encryptString:(NSString*)plainText
{
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
	size_t plainTextBufferSize = [data length];
	const void *vplainText = (const void *)[data bytes];
    
    //CCCryptorStatus ccStatus = 0;// uncomment by Harvey
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [APP_PUBLIC_PASSWORD UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    /* ccStatus = */CCCrypt(kCCEncrypt,// uncomment by Harvey
                            kCCAlgorithm3DES,
                            kCCOptionPKCS7Padding,
                            vkey,
                            kCCKeySize3DES,
                            vinitVec,
                            vplainText,
                            plainTextBufferSize,
                            (void *)bufferPtr,
                            bufferPtrSize,
                            &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);// add by Harvey
	NSString *result = [CCGTMBase64 stringByEncodingData:myData];
    return result;
}

+ (NSString*)decryptString:(NSString*)encryptText
{
    NSData *encryptData = [CCGTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
	size_t plainTextBufferSize = [encryptData length];
	const void *vplainText = [encryptData bytes];
    
    //CCCryptorStatus ccStatus;// uncomment by Harvey
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [APP_PUBLIC_PASSWORD UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    /* ccStatus = */CCCrypt(kCCDecrypt,// uncomment by Harvey
                            kCCAlgorithm3DES,
                            kCCOptionPKCS7Padding,
                            vkey,
                            kCCKeySize3DES,
                            vinitVec,
                            vplainText,
                            plainTextBufferSize,
                            (void *)bufferPtr,
                            bufferPtrSize,
                            &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    free(bufferPtr);// add by Harvey
    return result;
}

@end


@implementation NSString (MD5)

- (NSString *)md5Encrypt
{
//    const char *cStr = [self UTF8String];
//    unsigned char result[32];
//    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
//    return [NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)md5EncryptLower
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (NSString *)encodeBase64String
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)decodeBase64String
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data decodeBase64Data];
}

@end


#import <CommonCrypto/CommonCryptor.h>
@implementation NSData (Base64)

- (NSString *)decodeBase64Data
{
	NSData *data = [CCGTMBase64 decodeData:self];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return base64String;
}

- (NSData *)AES256Encrypt
{//加密
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [APP_PUBLIC_PASSWORD getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES256Decrypt
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [APP_PUBLIC_PASSWORD getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

- (NSString *)md5Encrypt
{
    NSString *str = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return [str md5Encrypt];
}

- (NSString *)md5EncryptLower
{
    NSString *str = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    return [str md5EncryptLower];
}
@end



