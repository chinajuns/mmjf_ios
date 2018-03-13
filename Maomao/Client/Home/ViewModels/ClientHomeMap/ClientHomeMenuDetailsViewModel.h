//
//  ClientHomeMenuDetailsViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/11/29.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZWPullMenuView.h"


@interface ClientHomeMenuDetailsViewModel : MMJFBaseViewModel
/**
 弹窗菜单
 */
@property (nonatomic, strong)ZWPullMenuView *pullMenuView;
/**
 判断是否收藏
 */
@property (nonatomic, assign)BOOL isCollection;

@property (nonatomic, assign)BOOL isB;

@property (nonatomic, strong)RACSubject *shareSubject;

@property (nonatomic, strong)RACSubject *favoriteSubject;
@end
