//
//  XTJSONResponseSerializer.m
//  AudioPlayer
//
//  Created by Admin on 2017/5/6.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "XTJSONResponseSerializer.h"
/*** MD5 ***/
#define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */
#define CC_MD5_BLOCK_BYTES      64          /* block size in bytes */
#define CC_MD5_BLOCK_LONG       (CC_MD5_BLOCK_BYTES / sizeof(CC_LONG))
@implementation XTJSONResponseSerializer
- (nullable id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing  _Nullable *)error
{
    NSLog(@"response 是:%@",response);
    
    NSUInteger responseStatusCode = 200;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger)[(NSHTTPURLResponse *)response statusCode];
    }
    
    id responseObject;
    
    if (responseStatusCode == 304) {
        
        // 获得缓存内容
        NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:self.xtCurrentRequest];
        NSLog(@"缓存是%@",cachedResponse.data);
        if (cachedResponse) {
            responseObject = [super responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:error];
            NSLog(@"responseStatusCode == 304，使用缓存");
        } else {
            // cached response was cleared, need to clear cached etag
            NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"etags"];
            NSString *fileName = [self cachedFileNameForKey:response.URL.absoluteString];
            NSString *cachedFileName = [directory stringByAppendingPathComponent:fileName];
            [[NSFileManager defaultManager] removeItemAtPath:cachedFileName error:nil];
            NSLog(@"responseStatusCode == 304，使用缓存,但是缓存加载失败,缓存没有保存成功，清除etags");
        }
        return responseObject;
    } else if (responseStatusCode >= 200 && responseStatusCode <= 299) {
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.allHeaderFields[@"Etag"]) {
                NSString *etag = httpResponse.allHeaderFields[@"Etag"];
                if (etag && etag.length > 0) {
                    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"etags"];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
                        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:nil];
                        
                    }
                    NSString *fileName = [self cachedFileNameForKey:response.URL.absoluteString];
                    NSString *cachedFileName = [directory stringByAppendingPathComponent:fileName];
                    BOOL success = [NSKeyedArchiver archiveRootObject:etag toFile:cachedFileName];
                    if(success){
//                        [[NSURLCache sharedURLCache] storeCachedResponse:response forRequest:self.xtCurrentRequest];
                        NSLog(@"responseStatusCode在200～299之间，保存etag成功,地址:%@",cachedFileName);
                    }else{
                         NSLog(@"responseStatusCode在200～299之间，保存etag失败");
                    }
                    
                }
            }
        }
        responseObject = [super responseObjectForResponse:response data:data error:error];
        
        return responseObject;
    } else {
        id responseObject = [super responseObjectForResponse:response data:data error:error];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            *error = [NSError errorWithDomain:NSURLErrorDomain code:responseStatusCode userInfo:responseObject];
        } else {
            *error = [NSError errorWithDomain:NSURLErrorDomain code:responseStatusCode userInfo:nil];
        }
        return nil;
    }
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
