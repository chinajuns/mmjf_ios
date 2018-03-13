//
//  LoanerCustomerTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanerCustomerModel.h"

@interface LoanerCustomerTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *grabSingleBut;

- (void)setUpdata:(LoanerCustomerModel *)model;
@end
