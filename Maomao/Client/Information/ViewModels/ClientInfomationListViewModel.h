//
//  ClientInfomationListViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"

@interface ClientInfomationListViewModel : MMJFBaseViewModel

/**
 按钮点击信号
 */
@property (nonatomic, strong)RACSubject *clickSubject;

@property (nonatomic, strong)RACSubject *listSubject;
//设置数据
- (void)setUpData:(id)data;
@end
