//
//  ClientMineIntegralModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/19.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientMineIntegralModel : NSObject

@property (nonatomic, copy)NSString * Id;
/**
 积分变化数量
 */
@property (nonatomic, copy)NSString *number;
/**
 时间
 */
@property (nonatomic, copy)NSString *create_time;
/**
 积分类型名称
 */
@property (nonatomic, copy)NSString *type_name;
/**
 
 */
@property (nonatomic, copy)NSString *integral_id;

@property (nonatomic, copy)NSString *description;
@end
