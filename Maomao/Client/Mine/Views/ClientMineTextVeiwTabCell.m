//
//  ClientMineTextVeiwTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineTextVeiwTabCell.h"


@implementation ClientMineTextVeiwTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpText:(NSString *)placeholder maxNumber:(NSInteger)maxNumber color:(UIColor *)backColor fontSize:(CGFloat)fontSize inputText:(NSString *)inputText{
    _input = [[CMInputView alloc]initWithFrame:CGRectMake(0, 0, MMJF_WIDTH - 30, self.textView.height)];
    
    _input.font = [UIFont fontWithName:@"PingFang SC" size:fontSize];
    if (inputText.length != 0) {
        _input.placeholder = @"";
    }else{
        _input.placeholder = placeholder;
    }
    _input.text = inputText;
    _input.maxNumber = maxNumber;
    self.numberWordsLab.text = [NSString stringWithFormat:@"0/%ld",maxNumber];
    //_inputView.placeholderFont = [UIFont systemFontOfSize:22];
    if (backColor) {
        _input.backgroundColor = backColor;
    }else{
        _input.backgroundColor = [UIColor whiteColor];
    }
    
    
    _input.maxNumberOfLines = 7;
    [self.textView addSubview:_input];
}


@end
