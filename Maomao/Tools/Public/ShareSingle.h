//
//  ShareSingle.h
//  BanDouApp
//
//  Created by waycubeIOSb on 16/3/27.
//  Copyright © 2016年 waycubeOXA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface ShareSingle : NSObject

@property (nonatomic, copy)NSString *lat;//纬度
@property (nonatomic, copy)NSString *lng;//经度

@property (nonatomic, strong)NSOperationQueue *queue;

/**
 失效次数
 */
@property (nonatomic, assign)NSInteger number;

/**
 判断url
 */
@property (nonatomic, copy)NSString *url;


/**
 推送角标
 */
@property (nonatomic, assign)NSInteger badge;
/**
 手机唯一标识
 */
@property (nonatomic, copy)NSString *phoneId;

/**
 错误提示
 */
@property (nonatomic, copy)NSString *errorStatus;
/**
 是否失效301
 */
@property (nonatomic, assign)BOOL isFailure;

/**
 用户id
 */
@property (nonatomic, copy)NSString *uid;

/**
 信贷经理id
 */
@property (nonatomic, copy)NSString *loaner_id;
/**
 接口的token
 */
@property (nonatomic, copy)NSString *token;
/**
 api_url
 */
@property (nonatomic, copy)NSString *api_url;
/**
 image_url
 */
@property (nonatomic, copy)NSString *image_url;

/**
 是否认证 1未认证 2认证中 3已认证 4认证失败
 */
@property (nonatomic, copy)NSString *is_auth;
/**
 定位城市
 */
@property (nonatomic, copy)NSString *locatingCity;

/**
 判断是否是客户端退出登录
 */
@property (nonatomic, assign)BOOL isCustomer;
+ (ShareSingle *)shareInstance;
@end
