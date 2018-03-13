//
//  ClientHomeViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/16.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPublicBaseViewModel.h"

@interface ClientHomeViewModel : ClientPublicBaseViewModel


/**
 C端：首页:顾问推荐
 */
@property (nonatomic, strong)RACCommand *clientManagerCommand;
/**
 C端：首页:搜索
 */
//@property (nonatomic, strong)RACCommand *clientSearchCommand;

/**
 我的：检查：收藏
 */
@property (nonatomic,strong)RACCommand *checkFavoriteCommand;

/**
 我的：收藏：添加|取消
 */
@property (nonatomic, strong)RACCommand *setFavoriteCommand;

/**
 我的：收藏列表
 */
@property (nonatomic, strong)RACCommand *favoriteListCommand;

/**
 首页:贷款申请:申请成功：快速申请
 */
@property (nonatomic, strong)RACCommand *quickApplyCommand;

/**
 首页:店铺：评价：综合信息
 */
@property (nonatomic, strong)RACCommand *averageCommand;
/**
 首页:店铺：评价：列表
 */
@property (nonatomic, strong)RACCommand *evaluateCommand;
/**
 首页:地图：顶部条件
 */
@property (nonatomic, strong)RACCommand *topConfigCommand;

/**
 首页:地图搜索
 */
@property (nonatomic, strong)RACCommand *clientMapCommand;
@end
