//
//  XTAudioRecoder.m
//  AudioPlayer
//
//  Created by Admin on 2017/5/8.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import "XTAudioRecoder.h"

NSString *const XTFormatRateKeyBest = @"XTFormatRateKeyBest";
NSString *const XTFormatRateKeyHigh = @"XTFormatRateKeyHigh";
NSString *const XTFormatRateKeyMedium = @"XTFormatRateKeyMedium";
NSString *const XTFormatRateKeyLow = @"XTFormatRateKeyLow";

@interface XTAudioRecoder ()
{
    BOOL isSaved;
}
@property (nonatomic, strong) NSDictionary *rateKeys;
@property (nonatomic, copy) XTRecordingStopCompletionHandler completionHandler;
@end

@implementation XTAudioRecoder
- (instancetype)init
{
    return [self initWithRate:XTFormatRateBest];
}
-(instancetype)initWithRate:(XTFormatRate)rateType{
    self = [super init];
    if (self) {
        NSNumber* rateValue;
        switch (rateType) {
            case XTFormatRateBest:
                rateValue = self.rateKeys[XTFormatRateKeyBest];
                break;
            case XTFormatRateHigh:
                rateValue = self.rateKeys[XTFormatRateKeyHigh];
                break;
            case XTFormatRateMedium:
                rateValue = self.rateKeys[XTFormatRateKeyMedium];
                break;
            case XTFormatRateLow:
                rateValue = self.rateKeys[XTFormatRateKeyLow];
                break;
            default:
                rateValue = self.rateKeys[XTFormatRateKeyBest];
                break;
            }
        //保存在Library/Cache中
        NSTimeInterval str = [NSDate timeIntervalSinceReferenceDate];
        NSString *fileName = [NSString stringWithFormat:@"%f.caf",str];
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        NSURL *fileUrl = [[NSURL alloc]initFileURLWithPath:path];
        NSDictionary *settings = @{AVFormatIDKey:@(kAudioFormatAppleIMA4),
                                   AVSampleRateKey:rateValue,
                                   AVNumberOfChannelsKey:@1,
                                   AVEncoderBitDepthHintKey:@16,
                                   AVEncoderAudioQualityKey:@(AVAudioQualityMax)
                                   };
        NSError *error;
        self.recorder = [[AVAudioRecorder alloc]initWithURL:fileUrl settings:settings error:&error];
        if (self.recorder) {
            self.recorder.delegate = self;
            [self.recorder prepareToRecord];
        }else{
            NSLog(@"Error: %@",[error localizedDescription]);
        }
    }
    return self;
}

-(BOOL)record{
    if ([self.recorder isRecording]) {
        return NO;
    }else{
        BOOL isOK =[self.recorder record];
        return isOK;
    }
    
}

-(void)pause{
    [self.recorder pause];
}

-(void)stopWithCompleteHandler:(XTRecordingStopCompletionHandler)hander{
    self.completionHandler = hander;
        [self.recorder stop];
        isSaved = NO;
    
    
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (self.completionHandler) {
        self.completionHandler(flag);
    }
}

-(NSDictionary*)rateKeys{
    if(!_rateKeys){
        _rateKeys = @{XTFormatRateKeyBest:@44100.0f,
                      XTFormatRateKeyHigh:@22050.0f,
                      XTFormatRateKeyMedium:@16000.0f,
                      XTFormatRateKeyLow:@8000.0f
                      };
    }
    return _rateKeys;
}

-(void)saveWithCompletionHander:( XTRecordingSaveCompletionHandler _Nonnull)hander{
    if (isSaved) {
        NSLog(@"当前录音已保存过");
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:10110101 userInfo:@{@"info":@"当前录音已保存过"}];
        hander(NO,error);
        return;
    }
    isSaved = YES;
    NSTimeInterval timestap = [NSDate timeIntervalSinceReferenceDate];
    NSString *fileName = [NSString stringWithFormat:@"%f.caf",timestap];
    NSString *docsDir = [self documentsDirectory];
    NSString *XTPath = [docsDir stringByAppendingPathComponent:@"XTAudios"];
    NSString *destPath = [XTPath stringByAppendingPathComponent:fileName];
    NSURL *destUrl = [NSURL fileURLWithPath:destPath];
    NSError*error;
    BOOL youma = [[NSFileManager defaultManager]fileExistsAtPath:XTPath];
    if (!youma) {
        [[NSFileManager defaultManager] createDirectoryAtPath:XTPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:self.recorder.url.path] toURL:destUrl error:&error];
    if (success) {
        hander(YES,destUrl);
    }else{
        hander(NO,error);
    }
}

-(NSArray*)getAllMySavedAudiosName{
    NSString *docsDir = [self documentsDirectory];
    NSString *destPath = [docsDir stringByAppendingPathComponent:@"XTAudios"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:destPath]){
        NSLog(@"目录：%@,不存在",destPath);
        return nil;
    }
    NSError*error;
    NSArray *allAudiosArr = [[NSArray alloc]initWithArray:[[NSFileManager defaultManager]contentsOfDirectoryAtPath:destPath error:&error]];
    return allAudiosArr;
}
-(NSArray*)getAllMySavedAudiosPathString{
    NSString *docsDir = [self documentsDirectory];
    NSString *destPath = [docsDir stringByAppendingPathComponent:@"XTAudios"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:destPath]){
        NSLog(@"目录：%@,不存在",destPath);
        return nil;
    }
    NSError*error;
    NSArray *arr = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:destPath error:&error];
    NSMutableArray *URLsArr = [NSMutableArray array];
    for (NSString *name in arr) {
        [URLsArr addObject: [destPath stringByAppendingPathComponent:name]];
    }
    return URLsArr;
}
-(NSString*)documentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
@end
