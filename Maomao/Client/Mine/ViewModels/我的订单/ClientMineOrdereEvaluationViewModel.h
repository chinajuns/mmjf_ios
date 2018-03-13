//
//  ClientMineOrdereEvaluationViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "ClientMineNetworkViewModel.h"

@interface ClientMineOrdereEvaluationViewModel : MMJFBaseViewModel

@property (nonatomic, strong)ClientMineNetworkViewModel *networkViewModel;

- (void)refresh:(NSDictionary *)dic orderid:(NSString *)orderId;

@end
