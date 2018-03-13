//
//  LoanerCustomerViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoanerCustomerNetWorkViewModel.h"

@interface LoanerCustomerViewModel : MMJFBaseViewModel

@property (nonatomic, strong)LoanerCustomerNetWorkViewModel *netWorkViewModel;
@property (nonatomic, strong)RACSubject *clickSubject;

@property (nonatomic, strong)RACSubject *listClickSubject;

- (void)setParameter:(NSString *)is_vip region_id:(NSString *)region_id has_house:(NSString *)has_house has_car:(NSString *)has_car;
@end
