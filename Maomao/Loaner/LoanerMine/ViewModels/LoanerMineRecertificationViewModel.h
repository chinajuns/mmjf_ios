//
//  LoanerMineRecertificationViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "LoanerManagerProfileModel.h"

@interface LoanerMineRecertificationViewModel : MMJFBaseViewModel

@property (nonatomic, strong)RACSubject *clickSubject;
@property (nonatomic, strong)LoanerManagerProfileModel *model;

- (void)refresh;
@end
