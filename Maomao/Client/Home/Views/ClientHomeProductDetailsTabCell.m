//
//  ClientHomeProductDetailsTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeProductDetailsTabCell.h"


@implementation ClientHomeProductDetailsTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//设置数据
- (void)setUpdata:(ClientHomeProductModel *)productModel{
    self.titelLab.text = productModel.category;
    self.linesLab.text = productModel.loan_number;
    self.limitlab.text = productModel.time_limit;
    self.interestLab.text = productModel.rate;
    self.companyLab.text = [NSString stringWithFormat:@"放贷公司:%@",productModel.title];
    self.timeLab.text = [NSString stringWithFormat:@"代理时间:%@",[NSString ConvertStrToTime:productModel.agent_time]];
    self.customerLab.text = [NSString stringWithFormat:@"%@人",productModel.apply_people];
    
}

@end
