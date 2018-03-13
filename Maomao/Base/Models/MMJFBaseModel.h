//
//  MMJFBaseMode.h
//  Maomao
//
//  Created by 御顺 on 2017/11/16.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMJFBaseModel : NSObject

/**
 数据
 */
@property (nonatomic, strong)id data;

/**
 提示
 */
@property (nonatomic, copy)NSString *msg;

/**
 状态码
 */
@property (nonatomic, copy)NSString *status;
@end
