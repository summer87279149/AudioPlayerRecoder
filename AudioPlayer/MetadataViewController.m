//
//  MetadataViewController.m
//  AudioPlayer
//
//  Created by Admin on 2017/5/8.
//  Copyright © 2017年 Admin. All rights reserved.
//
#import "AVMetadataItem+THAdditions.h"
#import "MetadataViewController.h"

@interface MetadataViewController ()

@end

@implementation MetadataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"Hubblecast.mov" withExtension:nil];
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSMutableArray *arr2 = [NSMutableArray array];
    [asset loadValuesAsynchronouslyForKeys:@[@"availableMetadataFormats"] completionHandler:^{
        NSError *error=nil;
        //如果直接调用这个asset.availableMetadataFormats是同步的，会卡界面，上面的loadValuesAsynchronouslyForKeys：方法就是先异步加载好这个availableMetadataFormats属性，然后现在就可以直接读了。这是apple的优化。
        AVKeyValueStatus state=[asset statusOfValueForKey:@"availableMetadataFormats" error:&error];
        switch (state) {
            case AVKeyValueStatusLoaded:
                for (NSString *format in asset.availableMetadataFormats)
                {
                    NSLog(@"format=%@",format);
                    NSArray *meatataArray=[asset metadataForFormat:format];
//                    NSLog(@"meatataArray里面%@",meatataArray);
                    NSArray *artisArray=[AVMetadataItem metadataItemsFromArray:meatataArray withKey:AVMetadataCommonKeyArtist keySpace:AVMetadataKeySpaceCommon];
                    for (AVMetadataItem *item in meatataArray)
                    {
                        NSLog(@"key=%@,value=%@",item.commonKey,item.value);
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            
                        });
                    }
                }
                NSLog(@"%@",@"加载成功");
                break;
            case AVKeyValueStatusFailed:
                NSLog(@"%@",@"加载失败");
                break;
            default:
                break;
        }
    }];
   
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
