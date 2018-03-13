//
//  LoanerStoreCreateViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "LoanerShowCreateModel.h"

@interface LoanerStoreCreateViewModel : MMJFBaseViewModel

@property (nonatomic, strong)RACSubject *clickSubject;
@property (nonatomic, strong)LoanerShowCreateModel *model;
//刷新
- (void)refresh;

//获取数据
- (NSDictionary *)getData;
@end
