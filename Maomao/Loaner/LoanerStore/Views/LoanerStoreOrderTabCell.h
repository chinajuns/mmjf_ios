//
//  LoanerStoreOrderTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanerOrderModel.h"

@interface LoanerStoreOrderTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *evaluationBut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *integralLine;
@property (weak, nonatomic) IBOutlet UIView *integralView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;


- (void)setUpData:(LoanerOrderModel *)model;
@end
