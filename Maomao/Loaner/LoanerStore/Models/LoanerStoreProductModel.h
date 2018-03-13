//
//  LoanerStoreProductModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanerStoreProductModel : NSObject
/**
 产品id
 */
@property (nonatomic, copy)NSString * Id;
/**
 所属分类
 */
@property (nonatomic, copy)NSString *cate_name;
/**
 贷款金额
 */
@property (nonatomic, copy)NSString *loan_number;

/**
 贷款周期
 */
@property (nonatomic, copy)NSString *time_limit;

/**
 利率
 */
@property (nonatomic, copy)NSString *rate;

/**
 已代理人数
 */
@property (nonatomic, copy)NSString *apply_people;

/**
 发布时间
 */
@property (nonatomic, copy)NSString *create_time;

/**
 来源,sys=>系统数据,other=>第三方数据
 */
@property (nonatomic, copy)NSString *source;


@end
