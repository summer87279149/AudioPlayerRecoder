//
//  ViewController.m
//  AudioPlayer
//
//  Created by Admin on 2017/5/5.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import "ViewController.h"
#import "XTAudioPlayer.h"
@interface ViewController ()
{
    XTAudioPlayer*XTPlayer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"薛之谦-我害怕.mp3" withExtension:nil];
    XTPlayer = [XTAudioPlayer playerWithUrl:url];   
}
-(void)injected{
    [self viewDidLoad];
}

- (IBAction)urlPlay:(id)sender {
    [XTPlayer play];
   
}
- (IBAction)stop2:(id)sender {
    [XTPlayer.player pause];
}

- (IBAction)stop:(id)sender {
    [XTPlayer stop];
}
- (IBAction)adjustRate:(UISlider *)sender {
    //播放速度
    [XTPlayer adjustRate:sender.value];
}
- (IBAction)volume:(UISlider*)sender {
    [XTPlayer adjustVolume:sender.value];
}

- (IBAction)pan:(UISlider*)sender {
    [XTPlayer adjustPan:sender.value];
}




@end
