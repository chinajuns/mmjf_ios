//
//  ClientMapModel.h
//  Maomao
//
//  Created by 御顺 on 2018/1/8.
//  Copyright © 2018年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientMapModel : NSObject

/**
 地区id
 */
@property (nonatomic, copy)NSString *Id;
/**
 区域名称
 */
@property (nonatomic, copy)NSString *name;
/**
 信贷经理数量
 */
@property (nonatomic, copy)NSString *counts;
/**
 经度
 */
@property (nonatomic, copy)NSString *lng;

/**
 纬度
 */
@property (nonatomic, copy)NSString *lat;

@end
