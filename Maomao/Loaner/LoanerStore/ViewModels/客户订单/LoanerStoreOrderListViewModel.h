//
//  LoanerStoreOrderListViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "LoanerStoreNetWorkViewModel.h"

@interface LoanerStoreOrderListViewModel : MMJFBaseViewModel

@property (nonatomic, strong)RACSubject *clickSubject;

@property (nonatomic, strong)RACSubject *butClickSubject;

@property (nonatomic, assign)BOOL isRefer;
@property (nonatomic, assign)NSInteger number;
@property (nonatomic, strong) LoanerStoreNetWorkViewModel *netWorkViewModel;

@end
