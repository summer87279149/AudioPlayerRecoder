//
//  RecordViewController.h
//  AudioPlayer
//
//  Created by Admin on 2017/5/8.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import "XTAudioPlayer.h"
#import "XTAudioRecoder.h"
#import <UIKit/UIKit.h>

@interface RecordViewController : UIViewController
@property (nonatomic, strong) XTAudioPlayer *player;
@property (nonatomic, strong) XTAudioRecoder *recorder;
@end
