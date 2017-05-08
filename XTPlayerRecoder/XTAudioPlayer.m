//
//  XTAudioPlayer.m
//  AudioPlayer
//
//  Created by Admin on 2017/5/5.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "XTAudioPlayer.h"

@interface XTAudioPlayer()
@end

@implementation XTAudioPlayer

+(instancetype)playerWithUrl:(NSURL*)url{
    return [[[self class]alloc]initWithUrl:url  orData:nil];
}
+(instancetype)playerWithUrlString:(NSString*)urlStr{
    return [[[self class]alloc]initWithUrl:nil  orData:nil];
}
+(instancetype)playerWithData:(NSData*)data{
    return [[[self class]alloc]initWithUrl:nil  orData:data];
}
- (instancetype)initWithUrl:(NSURL*)url orData:(NSData*)data{
    self = [super init];
    if (self) {
        if (url!=nil&&data==nil) {
            NSURL *fileURL = url;
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
            [self configPlayer];
        }
        if (url==nil&&data!=nil) {
            self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
            [self configPlayer];
        }
    }
    return self;
}
-(void)configPlayer{
    self.player.enableRate = YES;
    if (self.loop!=NO) {
        self.player.numberOfLoops = -1;
    }
    if (self.player) {
        [self.player prepareToPlay];
    }
    NSNotificationCenter *nsnc = [NSNotificationCenter defaultCenter];
    [nsnc addObserver:self selector:@selector(handleInterruption:)
                 name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    [nsnc addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];

}
//拔出耳机
- (void)handleRouteChange:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        if (self.player.isPlaying) {
            [self stop];
        }
        if (self.delegate) {
            [self.delegate playbackStopped];
        }
    } else {
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            [self play];
            if (self.delegate) {
                [self.delegate playbackBegan];
            }
        }
    }
    
}
//播放被打断（电话，facetime）
- (void)handleInterruption:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan)
    {
    } else {
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume)
        {
            [self play];
        }
    }
}
-(void)setLoop:(BOOL)loop{
    _loop = loop;
    if (loop==YES) {
        self.player.numberOfLoops = -1;
    }else{
        self.player.numberOfLoops = 0;
    }
}

-(void)play{
    [self.player play];
}

-(void)stop{
    if (self.player.isPlaying) {
        [self.player stop];
    }
}

- (void)adjustRate:(float)rate{
    self.player.rate = rate;
}

- (void)adjustVolume:(float)volume{
    self.player.volume = volume;
}

- (void)adjustPan:(float)pan{
    if (pan==0) {
    }else if (pan<0){
        pan = -1;
    }else{
        pan = 1;
    }
    self.player.pan = pan;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
