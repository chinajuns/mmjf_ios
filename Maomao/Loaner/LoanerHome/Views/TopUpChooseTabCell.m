//
//  TopUpChooseTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "TopUpChooseTabCell.h"

@implementation TopUpChooseTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.weChatBut.layer.cornerRadius = self.payTreasureBut.layer.cornerRadius = 5;
    self.weChatBut.layer.borderWidth = self.payTreasureBut.layer.borderWidth = 1;
    self.weChatBut.layer.borderColor = self.payTreasureBut.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    self.weChatBut.layer.masksToBounds = self.payTreasureBut.layer.masksToBounds = YES;
    if (self.weChatBut.selected) {
        self.weChatBut.layer.borderColor = MMJF_COLOR_Yellow.CGColor;
        self.payTreasureBut.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    }else{
        self.payTreasureBut.layer.borderColor = MMJF_COLOR_Yellow.CGColor;
        self.weChatBut.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickBut:(UIButton *)sender {
    self.weChatBut.selected = self.payTreasureBut.selected = NO;
    if (sender.tag == 0) {
        self.weChatBut.selected = !self.weChatBut.selected;
        self.weChatBut.layer.borderColor = MMJF_COLOR_Yellow.CGColor;
        self.payTreasureBut.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    }else{
        self.payTreasureBut.selected = !self.payTreasureBut.selected;
        self.payTreasureBut.layer.borderColor = MMJF_COLOR_Yellow.CGColor;
        self.weChatBut.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
    }
}
@end
