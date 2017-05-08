//
//  XTJSONRequestSerializer.m
//  AudioPlayer
//
//  Created by Admin on 2017/5/6.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "XTJSONRequestSerializer.h"

@implementation XTJSONRequestSerializer
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing  _Nullable *)error
{
    self.xtrequest = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    //发起请求的时候如果本地有etag，就把etag加到header里面
    NSString *absoluteUrl = self.xtrequest.URL.absoluteString;
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"etags"];
    NSString *fileName = [directory stringByAppendingPathComponent:[self cachedFileNameForKey:absoluteUrl]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSString *etag = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        if (etag && etag.length > 0) {
            [self.xtrequest addValue:etag forHTTPHeaderField:@"If-None-Match"];
        }
    }
//    NSLog(@"absoluteUrl=%@,\n fileName=%@\n",absoluteUrl,directory);
    return self.xtrequest;
}
- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [[key pathExtension] isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", [key pathExtension]]];
    
    return filename;
}
@end
