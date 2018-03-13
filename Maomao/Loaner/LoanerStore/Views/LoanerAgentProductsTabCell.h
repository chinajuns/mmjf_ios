//
//  LoanerAgentProductsTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanerStoreProductModel.h"

@interface LoanerAgentProductsTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lien;

@property (weak, nonatomic) IBOutlet UIButton *agentBut;

- (void)setUpData:(LoanerStoreProductModel *)model;
@end
