//
//  ClientInformationDetailsViewController.h
//  Maomao
//
//  Created by 御顺 on 2017/12/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InformationListModel.h"

@interface ClientInformationDetailsViewController : MMJFBaseViewController

@property (nonatomic, strong)InformationListModel *model;

/**
 我的收藏进入YES 
 */
@property (nonatomic, assign)BOOL isMy;

/**
 B端YES C端NO
 */
@property (nonatomic, assign)BOOL isB;
@end
