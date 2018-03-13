//
//  ClientInfomationMoreListViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "ClientInfomationNetWorkViewModel.h"

@interface ClientInfomationMoreListViewModel : MMJFBaseViewModel

@property (nonatomic, strong)ClientInfomationNetWorkViewModel *netWorkViewModel;
@property (nonatomic, strong)RACSubject *listSubject;
- (void)setUpData:(NSString *)Id;
//刷新
- (void)refresh;
@end
