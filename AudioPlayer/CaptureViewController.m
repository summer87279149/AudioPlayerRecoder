



//
//  CaptureViewController.m
//  AudioPlayer
//
//  Created by Admin on 2017/5/11.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "CaptureViewController.h"

@interface CaptureViewController ()

@end

@implementation CaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    AVCaptureDevice *devive = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = [NSError errorWithDomain:NSLocalizedDescriptionKey code:1 userInfo:@{@"info":@"出错了"}];
    AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:devive error:&error];
    if ([session canAddInput:cameraInput]) {
        [session addInput:cameraInput];
    }
    AVCaptureStillImageOutput *output = [[AVCaptureStillImageOutput alloc]init];
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
   
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = self.view.frame;
    [self.view.layer addSublayer:layer];
     [session startRunning];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
