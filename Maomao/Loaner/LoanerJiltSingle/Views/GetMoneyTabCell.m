//
//  GetMoneyTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "GetMoneyTabCell.h"

@implementation GetMoneyTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.unitPriceText.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
