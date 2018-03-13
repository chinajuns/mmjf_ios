//
//  LoanerStoreHeadTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreHeadTabCell.h"

@implementation LoanerStoreHeadTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImg.layer.cornerRadius = 45;
    self.headImg.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置数据
- (void)setUpData:(LoanerShopInfoModel *)model{
    self.nameLab.text = model.username;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:model.header_img]] placeholderImage:[UIImage imageNamed:@"denglu-mei-you-tou-xiang"]];
    self.scoeLab.text = model.score;
    self.pageviewsLab.text = model.pageviews;
    self.cityLab.text = model.service_city;
}

@end
