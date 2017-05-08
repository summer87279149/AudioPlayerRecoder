//
//  ViewController.m
//  AudioPlayer
//
//  Created by Admin on 2017/5/5.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import "XTRequestManager.h"
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
   
//    
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = CGRectMake(0, 0, 10, 10);
//   
//    CAShapeLayer *borderLayer = [CAShapeLayer layer];
//    borderLayer.frame = CGRectMake(0, 0, 10, 20);
//    borderLayer.lineWidth = 1.f;
//    borderLayer.strokeColor = [UIColor blueColor].CGColor;
//    borderLayer.fillColor = [UIColor yellowColor].CGColor;
//    
//    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 64, 200, 300) cornerRadius:10];
//    maskLayer.path = bezierPath.CGPath;
//    borderLayer.path = bezierPath.CGPath;
//    
//    [self.view.layer insertSublayer:borderLayer atIndex:0];
//    [self.view.layer setMask:maskLayer];
//    UIView*rblue = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
//    rblue.backgroundColor = [UIColor brownColor];
//    [self.view addSubview:rblue];
}
-(void)injected{
    [self viewDidLoad];
}

- (IBAction)urlPlay:(id)sender {
    [XTPlayer play];
    [XTRequestManager GET:@"http://myadmin.all-360.com:8080/Admin/AppApi/shopCartList/uid/12774" parameters:nil responseSeializerType:NHResponseSeializerTypeDefault success:^(id responseObject) {
        NSLog(@"测试结果:\n %@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"测试失败结果:\n %@",error);
    }];
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
