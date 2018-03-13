//
//  ClientHomeLoanInputViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/11/29.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientHomeLoanInputViewModel : MMJFBaseViewModel

@property (nonatomic, strong)NSMutableDictionary *mutDict;

/**
 信贷经理id
 */
@property (nonatomic, copy)NSString *loaner_id;
/**
 产品id
 */
@property (nonatomic, copy)NSString *product_id;
/**
 选择
 */
@property (nonatomic, strong)RACSubject *chooseRACSubject;

/**
 点击下一步
 */
@property (nonatomic, strong)RACSubject *clickSubject;

/**
  C端： 首页:贷款申请:基本配置
 */
@property (nonatomic, strong)RACCommand *clientConfigCommand;

/**
  C端：首页:贷款申请:申请
 */
@property (nonatomic, strong)RACCommand *applyCommand;
@end
