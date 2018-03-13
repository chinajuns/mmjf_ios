//
//  LoanerCustomerModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/26.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanerCustomerModel : NSObject
/**
 是否是会员,1=>是,0=>否
 */
@property(nonatomic, copy)NSString * is_vip;
/**
 贷款时长
 */
@property(nonatomic, copy)NSString *period;
/**
 申请金额,单位万元,保留小数点一位
 */
@property(nonatomic, copy)NSString *apply_number;
/**
 抢单id
 */
@property(nonatomic, copy)NSString *Id;
/**
 抢单所需积分
 */
@property(nonatomic, copy)NSString *score;
/**
 贷款类型
 */
@property(nonatomic, copy)NSString *loan_type;
/**
 创建时间
 */
@property(nonatomic, copy)NSString *create_time;
/**
 客户姓名
 */
@property(nonatomic, copy)NSString *customer;
/**
 列表
 */
@property(nonatomic, copy)NSArray *info;

@end
