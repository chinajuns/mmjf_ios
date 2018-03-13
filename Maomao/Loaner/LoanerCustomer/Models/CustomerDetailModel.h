//
//  CustomerDetailViewModel.h
//  Maomao
//
//  Created by 御顺 on 2018/1/4.
//  Copyright © 2018年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerDetailModel : NSObject
/**
 抢单id
 */
@property (nonatomic, copy)NSString *Id;
/**
 客户姓名
 */
@property (nonatomic, copy)NSString *customer;
/**
 创建时间
 */
@property (nonatomic, copy)NSString *create_time;
/**
 现居地
 */
@property (nonatomic, copy)NSString *current_place;
/**
 是否是会员,1=>是,0=>否
 */
@property (nonatomic, copy)NSString *is_vip;
/**
 申请金额,单位万元,保留小数点一位
 */
@property (nonatomic, copy)NSString *apply_number;
/**
 贷款类型
 */
@property (nonatomic, copy)NSString *loan_type;
/**
 贷款时长
 */
@property (nonatomic, copy)NSString *period;
/**
 抢单所需积分
 */
@property (nonatomic, copy)NSString *score;

@end
