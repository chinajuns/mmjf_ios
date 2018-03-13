//
//  ClientHomeProductDetailsTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientHomeProductModel.h"

@interface ClientHomeProductDetailsTabCell : UITableViewCell
/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titelLab;

/**
 额度
 */
@property (weak, nonatomic) IBOutlet UILabel *linesLab;

/**
 期限
 */
@property (weak, nonatomic) IBOutlet UILabel *limitlab;
/**
 月利率
 */
@property (weak, nonatomic) IBOutlet UILabel *interestLab;

/**
 放贷公司
 */
@property (weak, nonatomic) IBOutlet UILabel *companyLab;

/**
 代理时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
/**
 申请客户
 */
@property (weak, nonatomic) IBOutlet UILabel *customerLab;

/**
 设置数据
 */
- (void)setUpdata:(ClientHomeProductModel *)productModel;
@end
