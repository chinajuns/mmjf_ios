//
//  LoanerBillingDetilsTableViewCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanerBillingDetilsTableViewCell : UITableViewCell
/**
 指示
 */
@property (weak, nonatomic) IBOutlet UILabel *instructionsLab;

/**
 操作
 */
@property (weak, nonatomic) IBOutlet UILabel *operationLab;
/**
 金额
 */
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
/**
 时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@end
