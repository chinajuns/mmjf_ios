//
//  LoanerJiltInformationTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerJiltInformationTabCell.h"
#import "InfoModel.h"
@interface LoanerJiltInformationTabCell()
@property (weak, nonatomic) IBOutlet UILabel *customerLab;
@property (weak, nonatomic) IBOutlet UILabel *create_timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *is_vipImg;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *apply_numberLab;
@property (weak, nonatomic) IBOutlet UILabel *loan_type;
@property (weak, nonatomic) IBOutlet UILabel *periodLab;
@property (weak, nonatomic) IBOutlet UILabel *mobileLab;

@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *current_placeLab;

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;

@property (weak, nonatomic) IBOutlet UILabel *auditLab;
@end
@implementation LoanerJiltInformationTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpData:(LoanerOrderModel *)model{
    self.customerLab.text = model.customer;
    self.create_timeLab.text = [NSString ConvertStrToTime:model.create_time];
    NSString *str = [NSString stringWithFormat:@"%@",model.is_vip];
    if ([str isEqualToString:@"0"]) {
        self.is_vipImg.image = [UIImage imageNamed:@"pu-tong-hui-yuan"];
    }else{
        self.is_vipImg.image = [UIImage imageNamed:@"hui-yuan"];
    }
    NSString *order_status = [NSString stringWithFormat:@"%@",model.order_status];
    if (order_status.length != 0) {
        if ([order_status isEqualToString:@"1"]) {
            self.auditLab.text = @"审核中";
        }else if ([order_status isEqualToString:@"2"]){
            self.auditLab.text = @"进行中";
        }else if ([order_status isEqualToString:@"3"]){
            self.auditLab.text = @"已成交";
        }else if ([order_status isEqualToString:@"4"]){
            self.auditLab.text = @"已过期";
        }else if ([order_status isEqualToString:@"-1"]){
            self.auditLab.text = @"审核失败";
        }
    }
    self.price.text = [NSString stringWithFormat:@"%@积分",model.price];
    self.apply_numberLab.text = [NSString stringWithFormat:@"%@万元",model.apply_number];
    self.loan_type.text = model.loan_type;
    self.periodLab.text = model.period;
    self.ageLab.text = model.age;
    self.current_placeLab.text = model.current_place;
    self.mobileLab.text = model.mobile;
    NSArray *array = @[self.lab1,self.lab2,self.lab3,self.lab4,self.lab5];
    for (int i = 0; i < (model.info.count == array.count ? array.count : model.info.count); i ++) {
        UILabel *labe = array[i];
        NSDictionary *dic = model.info[i];
        InfoModel *infoModel = [InfoModel yy_modelWithJSON:dic];
        labe.text = [NSString stringWithFormat:@"%@:%@",infoModel.attr_key,infoModel.attr_value];
    }
}

@end
