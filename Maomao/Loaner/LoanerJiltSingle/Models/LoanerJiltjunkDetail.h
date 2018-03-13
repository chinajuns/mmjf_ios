//
//  LoanerJiltjunkDetail.h
//  Maomao
//
//  Created by 御顺 on 2018/1/3.
//  Copyright © 2018年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanerJiltjunkDetail : NSObject

/**
 订单id
 */
@property (nonatomic, copy)NSString *Id;
/**
 时间
 */
@property (nonatomic, copy)NSString *create_time;

@property (nonatomic, copy)NSString *price;
/**
 顾客姓名
 */
@property (nonatomic, copy)NSString *customer;
/**
 现居
 */
@property (nonatomic, copy)NSString *current_place;
/**
 是否vip订单,0=>否,1=>是
 */
@property (nonatomic, copy)NSString *is_vip;
/**
 申请金额
 */
@property (nonatomic, copy)NSString *apply_number;
/**
 贷款类型
 */
@property (nonatomic, copy)NSString *loan_type;
/**
 贷款周期
 */
@property (nonatomic, copy)NSString *period;
/**
 年龄
 */
@property (nonatomic, copy)NSString *age;
/**
 手机号
 */
@property (nonatomic, copy)NSString *mobile;
/**
 婚否,0=>否,1=>是
 */
@property (nonatomic, copy)NSString *is_marry;
/**
 备注
 */
@property (nonatomic, copy)NSString * description1;
/**
 状态标签
 */
@property (nonatomic, copy)NSString *label;
/**
 状态,1=>审核中,2=>进行中,3=>已成交,4=>已过期,-1=>审核失败
 */
@property (nonatomic, copy)NSString *junk_status;
/**
 过期时间,该字段仅在junk_status=>2时返回
 */
@property (nonatomic, copy)NSString *expire_time;


@end
