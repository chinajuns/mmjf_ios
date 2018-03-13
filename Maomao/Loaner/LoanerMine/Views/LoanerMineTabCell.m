//
//  LoanerMineTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerMineTabCell.h"

@implementation LoanerMineTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.separatorInset = UIEdgeInsetsMake(0, MMJF_WIDTH, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
