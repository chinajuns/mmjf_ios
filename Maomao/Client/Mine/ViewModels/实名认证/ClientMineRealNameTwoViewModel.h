//
//  ClientMineRealNameTwoViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "ClientPublicBaseViewModel.h"
#import "ClientMineNetworkViewModel.h"

@interface ClientMineRealNameTwoViewModel : MMJFBaseViewModel

@property (nonatomic, strong)RACSubject *clickSubject;
@property (nonatomic, strong)ClientPublicBaseViewModel *publicbaseViewModel;
@property (nonatomic, strong)ClientMineNetworkViewModel *netWorkViewModel;
@property (nonatomic, assign)NSInteger number;

@property (nonatomic, strong)NSMutableArray *mutArray;

@property (nonatomic, strong)NSMutableArray *mutImgArray;

/**
 上传完成
 */
@property (nonatomic, strong)RACSubject *uploadSubject;

- (void)refresh;

@end
