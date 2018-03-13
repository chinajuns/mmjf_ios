//
//  loanerJiltSingleViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoanerJiltSingleNetWorkViewModel.h"

@interface loanerJiltSingleViewModel : MMJFBaseViewModel

@property (nonatomic, strong)NSMutableDictionary * mutDict;
@property (nonatomic, strong)LoanerJiltSingleNetWorkViewModel *netWorkViewModel;

/**
 清空数据
 */
- (void)empty;
@end
