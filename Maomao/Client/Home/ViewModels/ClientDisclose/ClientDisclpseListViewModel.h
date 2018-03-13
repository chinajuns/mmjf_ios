//
//  ClientDisclpseListViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientQuickApplyModel.h"

@interface ClientDisclpseListViewModel : MMJFBaseViewModel

@property (nonatomic, strong)RACCommand *recommendCommand;

- (void)setUpData:(ClientQuickApplyModel *)model;
/**
 获取选择的贷款
 */
- (NSString *)getData;
@end
