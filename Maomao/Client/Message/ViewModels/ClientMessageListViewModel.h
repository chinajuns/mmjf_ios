//
//  ClientInfomationListViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "ClientMessageNetWorkViewModel.h"

@interface ClientMessageListViewModel : MMJFBaseViewModel

@property (nonatomic, strong)ClientMessageNetWorkViewModel *netWorkViewModel;

@property (nonatomic, assign)NSInteger number;
@end
