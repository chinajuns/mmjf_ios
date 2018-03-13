//
//  LoanerJiltSingleListViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"

@interface LoanerJiltSingleListViewModel : MMJFBaseViewModel

@property (nonatomic, strong)RACSubject *clickSubject;

@property (nonatomic, assign)NSInteger number;
@end
