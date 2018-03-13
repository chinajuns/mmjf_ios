//
//  LoanerCooperationTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerCooperationTabCell.h"

@implementation LoanerCooperationTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setUpText:(NSString *)str placeholderStr:(NSString *)placeholderStr{
    _input = [[CMInputView alloc]initWithFrame:CGRectMake(0, 0, MMJF_WIDTH - 30, self.textView.height)];
    _input.backgroundColor = [UIColor clearColor];
    _input.font = [UIFont fontWithName:@"PingFang SC" size:12];
    _input.text = str;
    if (str.length == 0) {
        _input.placeholder = placeholderStr;
    }
    _input.maxNumber = 50;
    //_inputView.placeholderFont = [UIFont systemFontOfSize:22];
    
    _input.maxNumberOfLines = 4;
    [self.textView addSubview:_input];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
