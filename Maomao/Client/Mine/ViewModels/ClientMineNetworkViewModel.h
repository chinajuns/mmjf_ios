//
//  ClientMineNetworkViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/19.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPublicBaseViewModel.h"

@interface ClientMineNetworkViewModel : ClientPublicBaseViewModel

/**
  C端：个人中心:积分
 */
@property (nonatomic, strong)RACCommand *memberPointCommand;

/**
 C端：个人中心:积分流水
 */
@property (nonatomic, strong)RACCommand *pointListCommand;

/**
 我的：设置：意见反馈
 */
@property (nonatomic, strong)RACCommand *feedbackCommand;



/**
 我的：实名认证：填写资料
 */
@property (nonatomic, strong)RACCommand *documentCommand;

/**
 我的：实名认证：认证情况
 */
@property (nonatomic, strong)RACCommand *authDocumentCommand;

/**
 我的：订单
 */
@property (nonatomic, strong)RACCommand *historyCommand;

/**
 首页:信贷经理:详情:举报
 */
@property (nonatomic, strong)RACCommand *reportCommand;

/**
 我的：订单：基础类型
 */
@property (nonatomic, strong)RACCommand *scoreTypeCommand;

/**
 我的：订单：添加点评
 */
@property (nonatomic, strong)RACCommand *userAddScoreCommand;

/**
 退出登录
 */
@property (nonatomic, strong)RACCommand *logoutCommand;
///个人中心：第三方绑定
@property (nonatomic, strong)RACCommand *memberSetOauthBind;
///个人中心：个人：绑定记录
@property (nonatomic, strong)RACCommand *memberOauthBind;

/**
 个人中心：分享：二维码
 */
@property (nonatomic, strong)RACCommand *webGetQrcode;

/**
 个人中心推送状态：读取
 */
@property (nonatomic, strong)RACCommand *getPushStatus;

/**
 个人中心：推送状态设置
 */
@property (nonatomic, strong)RACCommand *setPushStatus;
/**
 个人中心：分享：邀请信息统计
 */
@property (nonatomic, strong)RACCommand *memberInviteInfo;
@end
