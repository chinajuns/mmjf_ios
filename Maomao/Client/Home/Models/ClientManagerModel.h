//
//  ClientManagerModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/16.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientManagerModel : NSObject

/**
 信贷经理id
 */
@property (nonatomic,copy)NSString * Id;
/**
 信贷经理名字
 */
@property (nonatomic,copy)NSString *name;
/**
 头像
 */
@property (nonatomic,copy)NSString *header_img;
/**
 最大贷款金额
 */
@property (nonatomic,copy)NSString *max_loan;
/**
 平均放款天数
 */
@property (nonatomic,copy)NSString *loan_day;
/**
 放款总计：万元
 */
@property (nonatomic,copy)NSString *loan_number;
/**
 万元
 */
@property (nonatomic,copy)NSString *all_number;
/**
 用户评分：平均
 */
@property (nonatomic,copy)NSString *score;

@property (nonatomic, copy)NSString *tags;
/**
 是否认证：1未认证2已认证
 */
@property (nonatomic,copy)NSString *is_auth;

/**
 信贷经理电话
 */
@property (nonatomic, copy)NSString *loanername_mobile;

/**
 专业
 */
@property (nonatomic, copy)NSString *tag;
@end
