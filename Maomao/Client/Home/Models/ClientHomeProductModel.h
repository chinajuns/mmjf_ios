//
//  ClientHomeProductModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/18.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientHomeProductModel : NSObject

/**
 产品id
 */
@property (nonatomic, copy)NSString * Id;
/**
 产品类型
 */
@property (nonatomic, copy)NSString *category;
/**
 申请人数
 */
@property (nonatomic, copy)NSString *apply_people;
/**
 需要资料
 */
@property (nonatomic, copy)NSString *need_data;
/**
 申请条件
 */
@property (nonatomic, copy)NSArray *options;
/**
 平均放款天数
 */
@property (nonatomic, copy)NSString *loan_day;
/**
 信贷经理id
 */
@property (nonatomic, copy)NSString *loaner_id;
/**
 标题
 */
@property (nonatomic, copy)NSString *title;
/**
 放款总计：万元
 */
@property (nonatomic, copy)NSString *loan_number;
/**
 期限
 */
@property (nonatomic, copy)NSString *time_limit;
/**
 平台
 */
@property (nonatomic, copy)NSString *platform;
/**
 代理时间
 */
@property (nonatomic, copy)NSString *agent_time;
/**
 月利率
 */
@property (nonatomic, copy)NSString *rate;
@end
