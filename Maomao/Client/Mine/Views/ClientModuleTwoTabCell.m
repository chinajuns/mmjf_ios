//
//  ClientModuleTwoTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientModuleTwoTabCell.h"

@implementation ClientModuleTwoTabCell

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickBut:(UIButton *)sender {
    [self.clickSubject sendNext:[NSString stringWithFormat:@"%ld",sender.tag + 5]];
}
- (RACSubject *)clickSubject{
    if (!_clickSubject) {
        _clickSubject = [RACSubject subject];
    }
    return _clickSubject;
}
@end
