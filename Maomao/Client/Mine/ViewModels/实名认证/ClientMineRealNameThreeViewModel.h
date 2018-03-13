//
//  ClientMineRealNameThreeViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/20.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import "ClientMineNetworkViewModel.h"
#import "ClientMineAuthDocumentModel.h"

@interface ClientMineRealNameThreeViewModel : MMJFBaseViewModel

@property (nonatomic, strong)ClientMineNetworkViewModel *networkViewModel;

@property (nonatomic, strong)ClientMineAuthDocumentModel *authDocumentModel;
@end
