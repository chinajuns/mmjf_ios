//
//  ClientMineOrderListViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "ClientMineNetworkViewModel.h"
@interface ClientMineOrderListViewModel : MMJFBaseViewModel

/**
 按钮点击
 */
@property (nonatomic, strong)RACSubject *clickSubject;
/**
 详情信号
 */
@property (nonatomic, strong)RACSubject *detailsSubject;

@property (nonatomic, strong)ClientMineNetworkViewModel *networkViewModel;

- (void)sliding:(NSInteger)number;
@end
