//
//  XTAudioPlayer.h
//  AudioPlayer
//
//  Created by Admin on 2017/5/5.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol XTAudioPlayerDelegate<NSObject>
@optional
/**
 播放被中断的时候调用
 */
- (void)playbackStopped;
/**
 恢复播放的时候调用
 */
- (void)playbackBegan;
@end

@interface XTAudioPlayer : NSObject

@property (nonatomic, strong) AVAudioPlayer *player;
/**设置是否循环，默认NO*/
@property (nonatomic, assign) BOOL loop;
@property (nonatomic, weak) id<XTAudioPlayerDelegate>delegate;

+(instancetype)playerWithUrl:(NSURL*)url;
+(instancetype)playerWithData:(NSData*)data;

/**播放*/
- (void)play;
/**停止播放*/
- (void)stop;
/**调整播放速度*/
- (void)adjustRate:(float)rate;
/**调整平衡 -1 left,0 center,1 right*/
- (void)adjustPan:(float)pan;
/**调整音量 0~1*/
- (void)adjustVolume:(float)volume;

@end
