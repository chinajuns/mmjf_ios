//
//  LoanerStoreDetailViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "LoanerShopInfoModel.h"

@interface LoanerStoreDetailViewModel : MMJFBaseViewModel

@property (nonatomic, strong)RACSubject *slidingSubject;

@property (nonatomic, strong)RACSubject *clickSubject;

@property (nonatomic, strong)RACSubject *storeDetailSubject;

@property (nonatomic, strong)LoanerShopInfoModel *model;
//刷新
- (void)refresh:(NSArray *)dataArray;
@end
