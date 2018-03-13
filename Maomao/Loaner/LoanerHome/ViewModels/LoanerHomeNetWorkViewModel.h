//
//  LoanerHomeNetWorkViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/25.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPublicBaseViewModel.h"

@interface LoanerHomeNetWorkViewModel : ClientPublicBaseViewModel

/**
 B端：首页
 */
@property (nonatomic, strong)RACCommand *indexCommand;
@end
