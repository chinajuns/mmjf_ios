//
//  ClientHomeProductViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientHomeProductModel.h"

@interface ClientHomeProductListViewModel : MMJFBaseViewModel


@property (nonatomic, strong)RACCommand *clientSingleCommand;

@property (nonatomic, strong)ClientHomeProductModel *productModel;
@end
