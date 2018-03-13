//
//  LoanerStoreNetWorkViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/27.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPublicBaseViewModel.h"

@interface LoanerStoreNetWorkViewModel : ClientPublicBaseViewModel

/**
 B端：店铺-创建店铺界面展示用户基本信息
 */
@property (nonatomic, strong)RACCommand *showCreateCommand;

/**
 B端：店铺-创建店铺
 */
@property (nonatomic, strong)RACCommand *shopShowCreateCommand;

/**
 B端：店铺-主页
 */
@property (nonatomic, strong)RACCommand *shopIndexCommand;

/**
 B端：店铺-客户订单列表-个人中心抢的订单列表(共用该接口)
 */
@property (nonatomic, strong)RACCommand *shopOrderCommand;

/**
 B端：店铺-尚未代理的产品列表
 */
@property (nonatomic, strong)RACCommand *otherTypeCommand;


/**
 B端：店铺-已代理的产品列表|可代理产品
 */
@property (nonatomic, strong)RACCommand *myProductCommand;


/**
 B端：店铺-代理产品详情(未代理和已代理产品详情共用该接口)
 */
@property (nonatomic, strong)RACCommand *detailCommand;

/**
 B端：店铺-客户订单详情-个人中心订单详情(共用该接口)
 */
@property (nonatomic, strong)RACCommand *orderDetailCommand;

/**
 B端：店铺-客户订单-详情执行流程审批
 */
@property (nonatomic, strong)RACCommand *orderProcessCommand;

/**
 B端：店铺-客户订单-拒绝申请
 */
@property (nonatomic, strong)RACCommand *customerOrderRefuseCommand;

/**
 B端：店铺-客户订单-甩单(用户申请的订单甩出去)
 */
@property (nonatomic, strong)RACCommand *orderJunkCommand;

/**
 B端：店铺-客户订单-评价界面用户印象
 */
@property (nonatomic, strong)RACCommand *orderCommentLabelCommand;

/**
 B端：店铺-客户订单-评价提交
 */
@property (nonatomic, strong)RACCommand *orderCommentCommand;

/**
 B端：店铺-个人中心-订单举报(共用该接口)
 */
@property (nonatomic, strong)RACCommand *shopReportCommand;

/**
 B端：店铺-产品-代理|取消代理
 */
@property (nonatomic, strong)RACCommand *setAgentCommand;
@end
