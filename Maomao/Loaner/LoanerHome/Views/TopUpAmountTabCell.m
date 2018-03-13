//
//  TopUpAmountTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "TopUpAmountTabCell.h"

@implementation TopUpAmountTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.butArray = @[self.amount1,self.amount2,self.amount3,self.amount4,self.amount5,self.amount6,self.amount7];
    self.linesArray = @[self.lines1,self.lines2,self.lines3,self.lines4,self.lines5,self.lines6,self.lines7];
    for (UIButton *but in self.butArray) {
        but.layer.cornerRadius = 5;
        but.layer.borderWidth = 1;
        but.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
        but.layer.masksToBounds = YES;
        if (but.selected) {
            but.layer.borderColor = MMJF_COLOR_Yellow.CGColor;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickbut:(UIButton *)sender {
    for (UIButton *but in self.butArray) {
        but.layer.cornerRadius = 5;
        but.layer.borderWidth = 1;
        but.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6"].CGColor;
        but.layer.masksToBounds = YES;
        but.selected = NO;
    }
    for (UILabel *lines in self.linesArray) {
        lines.textColor = [UIColor blackColor];
    }
    UIButton *but = self.butArray[sender.tag];
    but.layer.borderColor = MMJF_COLOR_Yellow.CGColor;
    but.selected = !but.selected;
    UILabel *lines = self.linesArray[sender.tag];
    lines.textColor = [UIColor colorWithHexString:@"FF3333"];
}


@end
