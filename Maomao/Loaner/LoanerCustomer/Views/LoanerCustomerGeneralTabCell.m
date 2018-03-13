//
//  LoanerCustomerGeneralTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerCustomerGeneralTabCell.h"

@interface LoanerCustomerGeneralTabCell()

@property (weak, nonatomic) IBOutlet UILabel *integralLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *create_timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *is_vipImg;
@property (weak, nonatomic) IBOutlet UILabel *apply_numberLab;
@property (weak, nonatomic) IBOutlet UILabel *periodLab;
@property (weak, nonatomic) IBOutlet UILabel *loan_typeLab;

@end
@implementation LoanerCustomerGeneralTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpData:(LoanerJiltjunkDetail *)model{
    self.nameLab.text = model.customer;
    self.create_timeLab.text = [NSString stringWithFormat:@"%@/%@",[NSString ConvertStrToTime:model.create_time],model.current_place];
    NSString *is_vip = [NSString stringWithFormat:@"%@",model.is_vip];
    if ([is_vip isEqualToString:@"1"]) {
        self.is_vipImg.image = [UIImage imageNamed:@"hui-yuan"];
    }else{
        self.is_vipImg.image = [UIImage imageNamed:@"pu-tong-hui-yuan"];
    }
    self.apply_numberLab.text = [NSString stringWithFormat:@"%@万元",model.apply_number];
    self.periodLab.text = model.period;
    self.loan_typeLab.text = model.loan_type;
    self.integralLab.text = [NSString stringWithFormat:@"%@积分",model.price];
}

- (void)setUpDetaiData:(CustomerDetailModel *)model{
    self.nameLab.text = model.customer;
    self.create_timeLab.text = [NSString stringWithFormat:@"%@/%@",[NSString ConvertStrToTime:model.create_time],model.current_place];
    NSString *is_vip = [NSString stringWithFormat:@"%@",model.is_vip];
    if ([is_vip isEqualToString:@"1"]) {
        self.is_vipImg.image = [UIImage imageNamed:@"hui-yuan"];
    }else{
        self.is_vipImg.image = [UIImage imageNamed:@"pu-tong-hui-yuan"];
    }
    self.apply_numberLab.text = [NSString stringWithFormat:@"%@万元",model.apply_number];
    self.periodLab.text = model.period;
    self.loan_typeLab.text = model.loan_type;
    self.integralLab.text = [NSString stringWithFormat:@"%@积分",model.score];
}

@end
