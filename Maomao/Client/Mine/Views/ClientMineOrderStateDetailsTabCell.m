//
//  ClientMineOrderStateDetailsTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/6.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineOrderStateDetailsTabCell.h"

@implementation ClientMineOrderStateDetailsTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.statrBut.layer.cornerRadius = 4.5;
    self.statrBut.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpData:(ClientMineProcessingModel *)model{
    self.title.text = model.describe;
    self.time.text = [NSString ConvertStrToTime:model.create_time];
}
@end
