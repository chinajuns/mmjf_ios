//
//  ClientRightDrawerViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/11/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientRightDrawerViewModel : MMJFBaseViewModel


@property (nonatomic, strong)RACCommand *clientAttrConfigCommand;

/**
 清楚选择条件
 */
- (void)emptyChoose;

/**
 获取筛选条件
 */
- (NSDictionary *)getScreeningIds;
@end
