//
//  LoanerStoreDetailViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "LoanerOrderDetailModel.h"

@interface LoanerStoreOrderDetailViewModel : MMJFBaseViewModel

@property (nonatomic, strong)LoanerOrderDetailModel *model;
@property (nonatomic, assign)BOOL isRefer;
- (void)refresh;
@end
