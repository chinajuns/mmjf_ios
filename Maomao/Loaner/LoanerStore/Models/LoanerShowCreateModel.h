//
//  LoanerShowCreateModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanerShowCreateModel : NSObject

/**
 头像
 */
@property(nonatomic, copy)NSString * header_img;
/**
 姓名
 */
@property(nonatomic, copy)NSString *true_name;
/**
 所在城市
 */
@property(nonatomic, copy)NSDictionary *address;

/**
 机构名称
 */
@property(nonatomic, copy)NSString *mechanism;

@end
