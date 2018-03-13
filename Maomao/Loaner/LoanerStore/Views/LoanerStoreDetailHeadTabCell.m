//
//  LoanerStoreDetailHeadTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreDetailHeadTabCell.h"
#import "InfoModel.h"

@interface LoanerStoreDetailHeadTabCell()
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *integralLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *integralLine;
@property (weak, nonatomic) IBOutlet UIView *integralView;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UIImageView *vipImg;
@property (weak, nonatomic) IBOutlet UILabel *apply_numberLab;
@property (weak, nonatomic) IBOutlet UILabel *loan_typeLab;
@property (weak, nonatomic) IBOutlet UILabel *periodLab;
@property (weak, nonatomic) IBOutlet UILabel *age1Lab;
@property (weak, nonatomic) IBOutlet UILabel *current_placeLab;
@property (weak, nonatomic) IBOutlet UILabel *mobileLab;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UILabel *lab5;

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *title4;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;

@end
@implementation LoanerStoreDetailHeadTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpData:(LoanerOrderDetailModel *)model isRefer:(BOOL)isRefer{
    self.numberLab.text = [NSString stringWithFormat:@"订单编号:%@",model.order_num];
    self.timeLab.text = [NSString stringWithFormat:@"创建时间:%@",[NSString ConvertStrToTime:model.create_time]];
    self.nameLab.text = model.customer;
    self.ageLab.text = self.age1Lab.text = model.age;
    NSString *vip = [NSString stringWithFormat:@"%@",model.is_vip];
    if ([vip isEqualToString:@"0"]) {
        self.vipImg.image = [UIImage imageNamed:@"pu-tong-hui-yuan"];
    }else{
        self.vipImg.image = [UIImage imageNamed:@"hui-yuan"];
    }
    if (isRefer == YES) {
        self.integralView.hidden = YES;
        self.integralLine.constant = 0;
    }
    self.integralLab.text = [NSString stringWithFormat:@"%@积分",model.price];
    self.apply_numberLab.text = model.apply_number;
    self.loan_typeLab.text = model.loan_type;
    self.periodLab.text = model.period;
    self.current_placeLab.text = model.current_place;
    self.mobileLab.text = model.mobile;
    NSArray *array = @[self.lab1,self.lab2,self.lab3,self.lab4,self.lab5];
    for (int i = 0; i < (model.info.count == array.count ? array.count : model.info.count); i ++) {
        UILabel *labe = array[i];
        NSDictionary *dic = model.info[i];
        InfoModel *infoModel = [InfoModel yy_modelWithJSON:dic];
        labe.text = [NSString stringWithFormat:@"%@:%@",infoModel.attr_key,infoModel.attr_value];
    }
    NSString *process = [NSString stringWithFormat:@"%@",model.process];
    if ([process isEqualToString:@"38"]) {
        if (model.processHistory.count == 0 || model.processHistory.count == 1) {
            self.img1.image = [UIImage imageNamed:@"shen-qing-shi-bai"];
        }else if (model.processHistory.count == 2){
            self.img2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-shi-bai"];
            self.img1.image = [UIImage imageNamed:@"shen-qing-huang"];
            self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
        }else if (model.processHistory.count == 3){
            self.img3.image = [UIImage imageNamed:@"shen-pi-zi-liao-shi-bai"];
            self.img1.image = [UIImage imageNamed:@"shen-qing-huang"];
            self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
            self.img2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
            self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
        }else if (model.processHistory.count == 4){
            self.img4.image = [UIImage imageNamed:@"shen-pi-fang-kuan-shi-bai"];
            self.img1.image = [UIImage imageNamed:@"shen-qing-huang"];
            self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
            self.img2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
            self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
            self.img3.image = [UIImage imageNamed:@"shen-pi-zi-liao-huang"];
            self.lineView3.backgroundColor = MMJF_COLOR_Yellow;
        }
    }else if ([process isEqualToString:@"11"]){
        self.img1.image = [UIImage imageNamed:@"shen-qing-huang"];
    }else if ([process isEqualToString:@"12"]){
        self.img2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
        self.img1.image = [UIImage imageNamed:@"shen-qing-huang"];
        self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
    }else if ([process isEqualToString:@"36"]){
        self.img3.image = [UIImage imageNamed:@"shen-pi-zi-liao-huang"];
        self.img1.image = [UIImage imageNamed:@"shen-qing-huang"];
        self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
        self.img2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
        self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
    }else if ([process isEqualToString:@"37"]){
        self.img4.image = [UIImage imageNamed:@"shen-pi-fang-kuan-huang"];
        self.img1.image = [UIImage imageNamed:@"shen-qing-huang"];
        self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
        self.img2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
        self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
        self.img3.image = [UIImage imageNamed:@"shen-pi-zi-liao-huang"];
        self.lineView3.backgroundColor = MMJF_COLOR_Yellow;
    }
}

@end
