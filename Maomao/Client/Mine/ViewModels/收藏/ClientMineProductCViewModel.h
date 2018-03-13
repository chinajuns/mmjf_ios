//
//  ClientMineProductCViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"

@interface ClientMineProductCViewModel : MMJFBaseViewModel

@property (nonatomic, strong)RACSubject *clickSubject;
/**
 刷新数据
 */
- (void)refreshData;
@end
