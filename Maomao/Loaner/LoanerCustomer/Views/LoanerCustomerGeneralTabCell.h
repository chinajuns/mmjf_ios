//
//  LoanerCustomerGeneralTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanerJiltjunkDetail.h"
#import "CustomerDetailModel.h"

@interface LoanerCustomerGeneralTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (weak, nonatomic) IBOutlet UIView *backView;

- (void)setUpData:(LoanerJiltjunkDetail *)model;

- (void)setUpDetaiData:(CustomerDetailModel *)model;
@end
