//
//  ClientPublicBaseViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/11/25.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientPublicBaseViewModel : NSObject

/**
 图片上传
 */
@property (nonatomic, strong)RACCommand *imguploadCommand;

/**
 手机验证码：获取
 */
@property (nonatomic, strong)RACCommand *getCodeCommand;

/**
 手机验证码：验证
 */
@property (nonatomic, strong)RACCommand *checkCodeCommand;

/**
 忘记密码
 */
@property (nonatomic, strong)RACCommand *forgotCommand;

/**
 修改密码
 */
@property (nonatomic, strong)RACCommand *resetCommand;

/**
 首页:未读消息：检查
 */
@property (nonatomic, strong)RACCommand *checkNoticeCommand;
/**
 地址
 */
@property (nonatomic, strong)RACCommand *regionCommand;
/**
 C端： 首页:贷款申请:基本配置
 */
@property (nonatomic, strong)RACCommand *clientConfigCommand;

/**
 第三方绑定检查：如果已经绑定：直接返回用户信息
 */
@property (nonatomic, strong)RACCommand *setAuthCommand;

/**
 第三方绑定：成功直接返回用户信息
 */
@property (nonatomic, strong)RACCommand *setOauthBindCommand;

/**
 个人中心：个人：头像修改
 */
@property (nonatomic, strong)RACCommand *userAvatarCommand;
@end
