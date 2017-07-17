



//
//  RecordViewController.m
//  AudioPlayer
//
//  Created by Admin on 2017/5/8.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()
@property (weak, nonatomic) IBOutlet UIButton *kaishibtn;
@property (nonatomic, strong) NSURL *currentUrl;
@property (nonatomic, strong) NSMutableArray *cellArr;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recorder = [[XTAudioRecoder alloc]initWithRate:XTFormatRateBest];
    self.cellArr = [NSMutableArray array];
    
}

- (IBAction)start:(UIButton *)sender {
    [self.recorder record];
}

- (IBAction)pause:(id)sender {
    [self.recorder pause];
}

- (IBAction)stop:(id)sender {
    [self.recorder stopWithCompleteHandler:^(BOOL flag) {
        if (flag) {
            NSLog(@"停止");
        }else{
            NSLog(@"未停止");
        }
    }];
}

- (IBAction)save:(id)sender {
    [self.recorder saveWithCompletionHander:^(BOOL flag, id response) {
        if (flag) {
            NSLog(@"保存成功");
            self.currentUrl = response;
            [self.cellArr addObject:response];
            [self.tableview reloadData];
        }else{
            NSLog(@"保存失败,%@",response);
        }
        
    }];
    NSArray *arr = [self.recorder getAllMySavedAudiosPathString];
    for (NSString *str in arr) {
        NSLog(@"数组里面是:%@",str);
    }
    
}

- (IBAction)player:(id)sender {
    if (!self.currentUrl) {
        return;
    }
    self.player = [XTAudioPlayer playerWithUrl:self.currentUrl];
    [self.player play];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击的是:%@",self.cellArr[indexPath.row]);
    self.player = [XTAudioPlayer playerWithUrl:self.cellArr[indexPath.row]];
    [self.player play];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableCell = @"CellIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableCell];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:tableCell];
    }
    if (self.cellArr) {
        NSURL *url = self.cellArr[indexPath.row];
        cell.textLabel.text = url.lastPathComponent;
    }
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
