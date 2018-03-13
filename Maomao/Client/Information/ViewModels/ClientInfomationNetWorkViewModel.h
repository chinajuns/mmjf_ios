//
//  ClientInfomationNetWorkViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPublicBaseViewModel.h"

@interface ClientInfomationNetWorkViewModel : ClientPublicBaseViewModel

/**
 咨询：咨询首页
 
 */
@property (nonatomic, strong)RACCommand *articleCommand;

/**
 咨询：咨询：列表
 */
@property (nonatomic, strong)RACCommand *articleListCommand;
@end
