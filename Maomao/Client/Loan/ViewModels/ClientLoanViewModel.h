//
//  ClientLoanViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "ClientLoanNetWorkViewModel.h"

@interface ClientLoanViewModel : MMJFBaseViewModel{
}

/**
 点击
 */
@property (nonatomic, strong)RACSubject *clickSubject;
@property (nonatomic, strong)ClientLoanNetWorkViewModel *netWorkViewModel;
@property (nonatomic, strong)NSDictionary *loantypeDic;
@property (nonatomic, strong)NSDictionary *focusDic;
@property (nonatomic, strong)NSDictionary *cityDic;
///刷新
- (void)refresh;
@end
