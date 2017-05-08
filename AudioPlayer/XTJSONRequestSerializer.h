//
//  XTJSONRequestSerializer.h
//  AudioPlayer
//
//  Created by Admin on 2017/5/6.
//  Copyright © 2017年 Admin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface XTJSONRequestSerializer : AFJSONRequestSerializer
@property (nonatomic, strong) NSMutableURLRequest *xtrequest;
@end
