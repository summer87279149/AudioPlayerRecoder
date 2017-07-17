//
//  XTAudioRecoder.h
//  AudioPlayer
//
//  Created by Admin on 2017/5/8.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger,XTFormatRate){
    XTFormatRateBest,
    XTFormatRateHigh,
    XTFormatRateMedium,
    XTFormatRateLow
};

@interface XTAudioRecoder : NSObject<AVAudioRecorderDelegate>

typedef void(^XTRecordingStopCompletionHandler)(BOOL flag);
typedef void(^XTRecordingSaveCompletionHandler)(BOOL flag,id _Nullable response);

@property (nonatomic,strong) AVAudioRecorder * _Nonnull recorder;
/**
 init
 */
-(instancetype _Nonnull )initWithRate:(XTFormatRate)rateType;

/**
 开始录音
 */
-(BOOL)record;
/**
 暂停（通过record方法恢复录音）
 */
-(void)pause;

-(void)stopWithCompleteHandler:(XTRecordingStopCompletionHandler _Nullable  )hander;

/**
 保存录音（会强制停止当前正在进行的录音）
 */
-(void)saveWithCompletionHander:(XTRecordingSaveCompletionHandler _Nullable )hander;

/**
 获取所有本地已保存的录音名称
 */
-(NSArray*_Nullable)getAllMySavedAudiosName;

/**
 获取所有本地已保存的录音URL
 */
-(NSArray*_Nullable)getAllMySavedAudiosPathString;


/**
  获取当前播放时间

  @param needFormat 是否需要格式化成00:00:00样式
  @return 格式化后的时间活着未格式化的时间
*/

-(NSString *_Nullable)getCurrentTimeFormated:(BOOL)needFormat;

@end
