//
//  LoanerCustomerTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerCustomerTabCell.h"
#import "InfoModel.h"
@interface LoanerCustomerTabCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *titme;
@property (weak, nonatomic) IBOutlet UIImageView *vipImg;

@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UILabel *periodLab;
@property (weak, nonatomic) IBOutlet UILabel *loan_typeLab;

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UILabel *lab6;
@property (weak, nonatomic) IBOutlet UILabel *lab7;
@property (weak, nonatomic) IBOutlet UILabel *lab8;

@end
@implementation LoanerCustomerTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
}

- (void)setUpdata:(LoanerCustomerModel *)model{
    self.name.text = model.customer;
    self.titme.text = [NSString ConvertStrToTime:model.create_time];
    NSString *str = [NSString stringWithFormat:@"%@",model.is_vip];
    if ([str isEqualToString:@"1"]) {
        self.vipImg.image = [UIImage imageNamed:@"hui-yuan"];
    }else{
        self.vipImg.image = [UIImage imageNamed:@"pu-tong-hui-yuan"];
    }
    self.scoreLab.text = [NSString stringWithFormat:@"%@万元",model.apply_number];
    self.periodLab.text = model.period;
    self.loan_typeLab.text = model.loan_type;
    NSArray *array = @[self.lab1,self.lab2,self.lab3,self.lab4,self.lab5,self.lab6,self.lab7,self.lab8];
    for (int i = 0; i < (model.info.count == array.count ? array.count : model.info.count); i ++) {
        UILabel *labe = array[i];
        NSDictionary *dic = model.info[i];
        InfoModel *infoModel = [InfoModel yy_modelWithJSON:dic];
        if (i == 2) {
            labe.text = [NSString stringWithFormat:@"%@",infoModel.attr_value];
        }else{
            labe.text = [NSString stringWithFormat:@"%@:%@",infoModel.attr_key,infoModel.attr_value];
        }
    }
    [self.grabSingleBut setTitle:[NSString stringWithFormat:@"%@积分抢单",model.score] forState:UIControlStateNormal];
}

@end
