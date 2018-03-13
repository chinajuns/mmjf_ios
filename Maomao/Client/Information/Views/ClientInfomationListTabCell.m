//
//  ClientInfomationListTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientInfomationListTabCell.h"

@implementation ClientInfomationListTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpdata:(ClientMessageListModel *)managerModel{
    if ([managerModel.status isEqualToString:@"1"]) {
        self.statusLab.hidden = NO;
        self.line.constant = 15;
    }else{
        self.line.constant = 10;
        self.statusLab.hidden = YES;
    };
    self.titleLab.text = [NSString stringWithFormat:@"【%@】",managerModel.title];
    self.timeLab.text = [NSString ConvertStrToTime:managerModel.create_time];
    self.contentLab.text = managerModel.content;
}

@end
