//
//  LoanerTheAgentListViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "LoanerStoreNetWorkViewModel.h"

@interface LoanerTheAgentListViewModel : MMJFBaseViewModel
@property (nonatomic, strong)RACSubject *clickSubject;


@property (nonatomic, strong)LoanerStoreNetWorkViewModel *netWorkViewModel;

//返回参数传入下一页
- (NSDictionary *)getListDic;

/**
 加载
 */
- (void)loading;
@end
