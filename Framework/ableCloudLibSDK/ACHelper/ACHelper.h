//
//  ACHelper.h
//  ACloudLib
//
//  Created by zhourx5211 on 12/14/14.
//  Copyright (c) 2014 zcloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@interface ACHelper : NSObject

+ (NSData *)AES256EncryptWithData:(NSData *)data key:(NSString *)key;
+ (NSData *)AES256DecryptWithData:(NSData *)data key:(NSString *)key;

+ (NSString *)generateNonceWithLength:(NSInteger)length;

+ (NSString *)generateSignatureWithTimeout:(NSString *)timeout
                                 timestamp:(NSString *)timestamp
                                     nonce:(NSString *)nonce
                                     token:(NSString *)token;

+ (NSTimeInterval)getUTCFormateDate:(NSDate *)localDate;

+ (NSString *)currentWifiSSID;

@end
