
//
//  LoanerStoreFunctionTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreFunctionTabCell.h"

@implementation LoanerStoreFunctionTabCell

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clickSubject = [RACSubject subject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickBut:(UIButton *)sender {
    [self.clickSubject sendNext:[NSString stringWithFormat:@"%ld",sender.tag]];
}


@end
