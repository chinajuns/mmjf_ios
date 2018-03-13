//
//  ClientMineIntegralListViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "ClientMineNetworkViewModel.h"

@interface ClientMineIntegralListViewModel : MMJFBaseViewModel

@property (nonatomic, strong)ClientMineNetworkViewModel *networdViewModel;
/**
 刷新
 */
@property (nonatomic, assign)BOOL isRefresh;
@end
