//
//  LoanerMineNetWorkViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/26.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPublicBaseViewModel.h"

@interface LoanerMineNetWorkViewModel : ClientPublicBaseViewModel

/**
 B端：我的-实名认证-提交认证资料
 */
@property (nonatomic, strong)RACCommand *submitProfileCommand;

/**
 B端：我的-实名认证-认证资料展示
 */
@property (nonatomic, strong)RACCommand *profileCommand;
@end
