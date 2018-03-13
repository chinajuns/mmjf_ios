//
//  LoanerJiltSingleNetWorkViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/26.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPublicBaseViewModel.h"

@interface LoanerJiltSingleNetWorkViewModel : ClientPublicBaseViewModel

/**
 B端：首页-甩单-展示发布甩单界面相关属性
 */
@property (nonatomic, strong)RACCommand *junkAttrCommand;

/**
 B端：首页-甩单发布(经理填写发布)
 */
@property (nonatomic, strong)RACCommand *junkPublishCommand;

/**
 B端：首页-我的甩单详情
 */
@property (nonatomic, strong)RACCommand *junkDetailCommand;

/**
 B端：首页-我的甩单列表(个人中心甩单列表共用该接口)
 */
@property (nonatomic, strong)RACCommand *junkListCommand;

/**
 B端：首页-甩单-重新甩单
 */
@property (nonatomic, strong)RACCommand *junkAgainCommand;
@end
