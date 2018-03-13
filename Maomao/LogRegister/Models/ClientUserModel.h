//
//  ClientUserModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/15.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientUserModel : NSObject<NSCoding, NSCopying>

/**
 电话
 */
@property(nonatomic, copy)NSString* mobile;
/**
 1普通用户2信贷经理
 */
@property(nonatomic, copy)NSString* type;
/**
 用户名
 */
@property(nonatomic, copy)NSString* username;
/**
 头像
 */
@property(nonatomic, copy)NSString* header_img;
/**
 是否认证：1是2否
 */
@property(nonatomic, copy)NSString* is_auth;
/**
 性别：1男2女3未知
 */
@property(nonatomic, copy)NSString* sex;

@property (nonatomic, copy)NSString *Id;
/**
 积分
 */
@property(nonatomic, copy)NSString* integral;
@property (nonatomic, copy)NSString *introduce;
/**
 最后登录时间
 */
@property(nonatomic, copy)NSString* last_login_time;
@end
