//
//  ClientLoanNetWorkViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/19.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPublicBaseViewModel.h"

@interface ClientLoanNetWorkViewModel : ClientPublicBaseViewModel

/**
 C端：贷款：搜索 配置
 */
@property (nonatomic, strong)RACCommand *configCommand;

/**
  C端：贷款：搜索
 */
@property (nonatomic, strong)RACCommand *loanSearchCommand;
/**
 C端：贷款：首页
 */
//@property (nonatomic, strong)RACCommand *loanCommand;
@end
