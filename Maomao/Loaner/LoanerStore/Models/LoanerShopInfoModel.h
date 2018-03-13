//
//  LoanerShopInfoModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanerShopInfoModel : NSObject
/**
 头像
 */
@property(nonatomic, copy)NSString * header_img;

@property (nonatomic, copy)NSString *introduce;

@property (nonatomic, copy)NSString *loaner_id;
/**
 姓名
 */
@property(nonatomic, copy)NSString *username;
/**
 所在城市
 */
@property(nonatomic, copy)NSString *service_city;

/**
 综合评分
 */
@property(nonatomic, copy)NSString *score;
/**
 浏览量
 */
@property(nonatomic, copy)NSString *pageviews;
/**
 店铺状态, 1=>店铺开启 2=>店铺封停
 */
@property(nonatomic, copy)NSString *status;
@end
