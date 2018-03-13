//
//  LoanerAgentProductsTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerAgentProductsTabCell.h"

@interface LoanerAgentProductsTabCell()
@property (weak, nonatomic) IBOutlet UILabel *cate_name;
@property (weak, nonatomic) IBOutlet UILabel *loan_numberLab;
@property (weak, nonatomic) IBOutlet UILabel *time_limitLab;
@property (weak, nonatomic) IBOutlet UILabel *rateLab;
@property (weak, nonatomic) IBOutlet UILabel *apply_peopleLab;
@property (weak, nonatomic) IBOutlet UILabel *create_timeLab;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
@implementation LoanerAgentProductsTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpData:(LoanerStoreProductModel *)model{
    self.cate_name.text = model.cate_name;
    self.loan_numberLab.text = model.loan_number;
    self.time_limitLab.text = model.time_limit;
    self.rateLab.text = model.rate;
    self.apply_peopleLab.text = [NSString stringWithFormat:@"%@人",model.apply_people];
    self.create_timeLab.text = [NSString stringWithFormat:@"发布时间:%@",[NSString ConvertStrToTime:model.create_time]];
}

@end
