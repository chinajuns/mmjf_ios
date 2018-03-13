//
//  ClientEvaluationModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientEvaluationModel : NSObject
@property (nonatomic, copy)NSString * loan_id;
/**
 评分
 */
@property (nonatomic, copy)NSString *score_avg;
@property (nonatomic, copy)NSString *focus;
/**
 评价内容
 */
@property (nonatomic, copy)NSString *describe;
/**
 点评用户
 */
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *user_id;
/**
 发布时间
 */
@property (nonatomic, copy)NSString *create_time;
@end
