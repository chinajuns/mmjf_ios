//
//  ClientMineProductModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientMineProductModel : NSObject

/**
 <#Description#>
 */
@property (nonatomic, copy)NSString *is_hot;
/**
 综合评分
 */
@property (nonatomic, copy)NSString *score;
/**
 贷款额度
 */
@property (nonatomic, copy)NSString *max_loan;
/**
 是否认证：1未认证2审核中3审核通过4失败
 */
@property (nonatomic, copy)NSString *is_auth;
/**
 收藏id
 */
@property (nonatomic, copy)NSString *Id;
/**
 标签
 */
@property (nonatomic, copy)NSString *tag;
/**
 头像
 */
@property (nonatomic, copy)NSString *header_img;
/**
 信贷经理id
 */
@property (nonatomic, copy)NSString *object_id;
/**
 
 */
@property (nonatomic, copy)NSString *loan_day;
@property (nonatomic, copy)NSString *is_focus;
/**
 名称
 */
@property (nonatomic, copy)NSString *name;
@end
