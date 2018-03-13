//
//  ShareSingle.m
//  BanDouApp
//
//  Created by waycubeIOSb on 16/3/27.
//  Copyright © 2016年 waycubeOXA. All rights reserved.
//

#import "ShareSingle.h"

@implementation ShareSingle
// GCD 创建单例
+ (ShareSingle *)shareInstance{
    static ShareSingle *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ShareSingle alloc] init];
        share.queue = [[NSOperationQueue alloc]init];
        share.number = 0;
        share.phoneId = share.token = @"";
        share.errorStatus = @"暂无内容";
        share.is_auth = @"0";
    });
    return share;
}
@end
