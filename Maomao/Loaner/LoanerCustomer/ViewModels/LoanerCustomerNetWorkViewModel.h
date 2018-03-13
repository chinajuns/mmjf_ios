//
//  LoanerCustomerNetWorkViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/26.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPublicBaseViewModel.h"

@interface LoanerCustomerNetWorkViewModel : ClientPublicBaseViewModel

/**
 B端：首页-抢单-列表
 */
@property (nonatomic, strong)RACCommand *orderIndexCommand;

/**
 B端：首页-抢单-检查抢单资格
 */
@property (nonatomic, strong)RACCommand *checkPurchaseCommand;

/**
 B端：首页-抢单-立即支付
 */
@property (nonatomic, strong)RACCommand *purchaseCommand;

/**
 B端：首页-抢单-详情
 */
@property (nonatomic, strong)RACCommand *orderDetailCommand;

/**
 B！抢单:配置
 */
@property (nonatomic, strong)RACCommand *grabConfigCommand;
@end
