
//
//  LoanerStoreOrderTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreOrderTabCell.h"
#import "InfoModel.h"

@interface LoanerStoreOrderTabCell()
@property (weak, nonatomic) IBOutlet UILabel *integralLab;

@property (weak, nonatomic) IBOutlet UILabel *customerLab;
@property (weak, nonatomic) IBOutlet UILabel *create_timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *is_vipImg;
@property (weak, nonatomic) IBOutlet UILabel *apply_numberLab;
@property (weak, nonatomic) IBOutlet UILabel *loan_typeLab;
@property (weak, nonatomic) IBOutlet UILabel *periodLab;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *current_placeLab;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;

@property (weak, nonatomic) IBOutlet UIImageView *process1;
@property (weak, nonatomic) IBOutlet UIImageView *process2;
@property (weak, nonatomic) IBOutlet UIImageView *process3;
@property (weak, nonatomic) IBOutlet UIImageView *process4;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@end
@implementation LoanerStoreOrderTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    self.apply_numberLab.text = [NSString stringWithFormat:@"%@万元",model.apply_number];
    self.loan_typeLab.text = model.loan_type;
    self.periodLab.text = model.period;
    self.ageLab.text = model.age;
    self.integralLab.text = [NSString stringWithFormat:@"%@积分",model.price];
    self.current_placeLab.text = model.current_place;
    self.mobile.text = model.mobile;
    NSArray *array = @[self.lab1,self.lab2,self.lab3,self.lab4,self.lab5];
    for (int i = 0; i < (model.info.count == array.count ? array.count : model.info.count); i ++) {
        UILabel *labe = array[i];
        NSDictionary *dic = model.info[i];
        InfoModel *infoModel = [InfoModel yy_modelWithJSON:dic];
        labe.text = [NSString stringWithFormat:@"%@:%@",infoModel.attr_key,infoModel.attr_value];
    }
    NSString *process = [NSString stringWithFormat:@"%@",model.process];
    if ([process isEqualToString:@"38"]) {
        if (model.processIds.count == 0 || model.processIds.count == 1) {
            self.process1.image = [UIImage imageNamed:@"shen-qing-shi-bai"];
        }else if (model.processIds.count == 2){
            self.process2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-shi-bai"];
            self.process1.image = [UIImage imageNamed:@"shen-qing-huang"];
            self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
        }else if (model.processIds.count == 3){
            self.process3.image = [UIImage imageNamed:@"shen-pi-zi-liao-shi-bai"];
            self.process1.image = [UIImage imageNamed:@"shen-qing-huang"];
            self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
            self.process2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
            self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
        }else if (model.processIds.count == 4){
            self.process4.image = [UIImage imageNamed:@"shen-pi-fang-kuan-shi-bai"];
            self.process1.image = [UIImage imageNamed:@"shen-qing-huang"];
            self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
            self.process2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
            self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
            self.process3.image = [UIImage imageNamed:@"shen-pi-zi-liao-huang"];
            self.lineView3.backgroundColor = MMJF_COLOR_Yellow;
        }
    }else if ([process isEqualToString:@"11"]){
        self.process1.image = [UIImage imageNamed:@"shen-qing-huang"];
    }else if ([process isEqualToString:@"12"]){
        self.process2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
        self.process1.image = [UIImage imageNamed:@"shen-qing-huang"];
        self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
    }else if ([process isEqualToString:@"36"]){
        self.process3.image = [UIImage imageNamed:@"shen-pi-zi-liao-huang"];
        self.process1.image = [UIImage imageNamed:@"shen-qing-huang"];
        self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
        self.process2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
        self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
    }else if ([process isEqualToString:@"37"]){
        self.process4.image = [UIImage imageNamed:@"shen-pi-fang-kuan-huang"];
        self.process1.image = [UIImage imageNamed:@"shen-qing-huang"];
        self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
        self.process2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
        self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
        self.process3.image = [UIImage imageNamed:@"shen-pi-zi-liao-huang"];
        self.lineView3.backgroundColor = MMJF_COLOR_Yellow;
    }
    NSString *number = [NSString stringWithFormat:@"%@",model.is_comment];
    if ([process isEqualToString:@"37"] || [process isEqualToString:@"38"]) {
        if ([number isEqualToString:@"2"]) {
            self.line.constant = 0;
            self.evaluationBut.hidden = YES;
        }
    }else{
        self.line.constant = 0;
        self.evaluationBut.hidden = YES;
    }
}
@end
