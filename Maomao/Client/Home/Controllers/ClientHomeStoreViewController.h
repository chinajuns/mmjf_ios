//
//  ClientHomeStoreViewController.h
//  Maomao
//
//  Created by 御顺 on 2017/11/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientManagerModel.h"
#import "ClientMineProductModel.h"

@interface ClientHomeStoreViewController : MMJFBaseViewController

/**
 我的收藏进入YES
 */
@property (nonatomic, assign)BOOL isMy;
@property (nonatomic, strong)ClientManagerModel *managerModel;

@property (nonatomic, strong)ClientMineProductModel *model;
@end
