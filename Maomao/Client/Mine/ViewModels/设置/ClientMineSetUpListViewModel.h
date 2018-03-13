//
//  ClientMineSetUpListViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"

@interface ClientMineSetUpListViewModel : MMJFBaseViewModel

@property (nonatomic, strong)RACSubject *clickSubject;

@property (nonatomic, strong)RACSubject *swithSubject;
/**
 0关 1开
 */
@property (nonatomic, assign)NSInteger number;

/**
 刷新
 */
- (void)refresh;
@end
