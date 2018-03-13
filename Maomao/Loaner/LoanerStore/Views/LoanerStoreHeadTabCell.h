//
//  LoanerStoreHeadTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanerShopInfoModel.h"

@interface LoanerStoreHeadTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
/**
 服务地区
 */
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
/**
 评分
 */
@property (weak, nonatomic) IBOutlet UILabel *scoeLab;
/**
 浏览量
 */
@property (weak, nonatomic) IBOutlet UILabel *pageviewsLab;

/**
 名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
//设置数据
- (void)setUpData:(LoanerShopInfoModel *)model;
@end
