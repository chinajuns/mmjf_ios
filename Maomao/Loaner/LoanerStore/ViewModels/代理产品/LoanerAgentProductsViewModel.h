//
//  LoanerAgentProductsViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "LoanerStoreNetWorkViewModel.h"

@interface LoanerAgentProductsViewModel : MMJFBaseViewModel
@property (nonatomic, strong)RACSubject *clickSubject;
@property (nonatomic, strong)LoanerStoreNetWorkViewModel *netWorkViewModel;
@property (nonatomic, copy)NSString *cate_id;

/**
 加载
 */
- (void)loading;

/**
 返回参数
 */
- (NSDictionary *)getListDic;
@end
