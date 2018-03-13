//
//  LoanerMineViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"

@interface LoanerMineViewModel : MMJFBaseViewModel
@property (nonatomic, strong)RACSubject *clickSubject;

- (void)refresh;
/**
 滚动到头部
 */
- (void)top;
@end
