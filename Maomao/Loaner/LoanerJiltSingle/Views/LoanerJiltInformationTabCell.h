//
//  LoanerJiltInformationTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanerOrderModel.h"

@interface LoanerJiltInformationTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lien;
@property (weak, nonatomic) IBOutlet UIView *integralView;

- (void)setUpData:(LoanerOrderModel *)model;
@end
