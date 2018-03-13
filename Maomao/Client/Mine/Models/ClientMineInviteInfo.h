//
//  ClientMineInviteInfo.h
//  Maomao
//
//  Created by 御顺 on 2018/1/25.
//  Copyright © 2018年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientMineInviteInfo : NSObject
/**
 电话号码
 */
@property (nonatomic, copy)NSString *mobile;
/**
 邀请人数
 */
@property (nonatomic, copy)NSString *count;
/**
 获得积分数量
 */
@property (nonatomic, copy)NSString *number;

@end
