//
//  ClientMineListViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "ClientMineNetworkViewModel.h"

@interface ClientMineListViewModel : MMJFBaseViewModel

@property (nonatomic, strong)RACSubject *clickSubject;
@property (nonatomic, strong)ClientMineNetworkViewModel *networkViewModel;
/**
 头像
 */
@property (nonatomic, strong)UIImage *headImage;
/**
 刷新
 */
- (void)refresh;
/**
 滚动到头部
 */
- (void)top;
@end
