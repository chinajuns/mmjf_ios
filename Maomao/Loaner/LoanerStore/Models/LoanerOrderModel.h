//
//  LoanerOrderModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/29.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanerOrderModel : NSObject
/**
 是否是vip订单,0=>否,1=>是
 */
@property (nonatomic, copy)NSString *is_vip;
/**
 贷款周期
 */
@property (nonatomic, copy)NSString *period;
/**
 贷款金额
 */
@property (nonatomic, copy)NSString *apply_number;
/**
 订单id
 */
@property (nonatomic, copy)NSString *Id;
/**
 出生年月
 */
@property (nonatomic, copy)NSString *age;
/**
 现居
 */
@property (nonatomic, copy)NSString *current_place;
/**
 贷款类型
 */
@property (nonatomic, copy)NSString *loan_type;
/**
 手机号
 */
@property (nonatomic, copy)NSString *mobile;
/**
 订单时间
 */
@property (nonatomic, copy)NSString *create_time;
/**
 顾客名字
 */
@property (nonatomic, copy)NSString *customer;
/**
 属性信息)
 */
@property (nonatomic, copy)NSArray *info;

/**
 办理进度,11=>申请贷款,12=>资料提交,36=>审批资料,37=>审批放款,38=>申请失败
 */
@property (nonatomic, copy)NSString *process;

/**
 办理进度id合集
 */
@property (nonatomic, copy)NSArray *processIds;

/**
 2 已评价 
 */
@property (nonatomic, copy)NSString *is_comment;

/**
 1=>审核中,2=>进行中,3=>已成交,4=>已过期 ,-1=>审核失败
 */
@property (nonatomic, copy)NSString *order_status;

/**
 积分
 */
@property (nonatomic, copy)NSString *price;
@end
