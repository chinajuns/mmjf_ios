//
//  ClientintegralSubsidiaryTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientintegralSubsidiaryTabCell.h"

@implementation ClientintegralSubsidiaryTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpData:(ClientMineIntegralModel *)integralModel{
    NSString *str = [NSString stringWithFormat:@"%@",integralModel.number];
    if ([str integerValue] > 0) {
        self.integralLab.text = [NSString stringWithFormat:@"+%@",integralModel.number];
        self.statesLab.textColor = [UIColor colorWithHexString:@"#ff3333"];
    }else{
        self.statesLab.textColor = [UIColor colorWithHexString:@"#33abff"];
        self.integralLab.text = [NSString stringWithFormat:@"%@",integralModel.number];
    }
    self.titleLab.text = integralModel.type_name;
    if (self.titleLab.text.length == 0) {
        self.titleLab.text = integralModel.description;
    }
    self.timeLab.text = [NSString ConvertStrToTime:integralModel.create_time];
    
}

@end
