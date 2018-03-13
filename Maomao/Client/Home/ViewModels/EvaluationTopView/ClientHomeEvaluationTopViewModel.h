//
//  ClientHomeEvaluationTopViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientHomeViewModel.h"

@interface ClientHomeEvaluationTopViewModel : MMJFBaseViewModel

@property (nonatomic, strong)ClientHomeViewModel *netWorkViewModel;
- (void)setUpData:(NSDictionary *)dic;
@end
