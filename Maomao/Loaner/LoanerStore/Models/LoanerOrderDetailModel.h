//
//  LoanerOrderDetailModel.h
//  Maomao
//
//  Created by 御顺 on 2018/1/2.
//  Copyright © 2018年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanerOrderDetailModel : NSObject

/**
 流程
 */
@property (nonatomic, copy)NSArray *processHistory;

/**
 所有流程
 */
@property (nonatomic, copy)NSArray *processAll;

/**
 订单id
 */
@property (nonatomic, copy)NSString * Id;
/**
 订单编号
 */
@property (nonatomic, copy)NSString *order_num;
/**
 客户姓名
 */
@property (nonatomic, copy)NSString *customer;

/**
 积分
 */
@property (nonatomic, copy)NSString *price;
/**
 订单时间
 */
@property (nonatomic, copy)NSString *create_time;
/**
 是否是vip订单,0=>否,1=>是
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
 出生年月
 */
@property (nonatomic, copy)NSString *age;
/**
 现居地
 */
@property (nonatomic, copy)NSString *current_place;
/**
 手机号
 */
@property (nonatomic, copy)NSString *mobile;
/**
 办理进度,11=>申请贷款,12=>资料提交,36=>审批资料,37=>审批放款,38=>申请失败
 */
@property (nonatomic, copy)NSString *process;
/**
 配置
 */
@property (nonatomic, copy)NSArray *info;


@end
