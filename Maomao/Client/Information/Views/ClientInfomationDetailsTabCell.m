//
//  ClientInfomationDetailsTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientInfomationDetailsTabCell.h"
@interface ClientInfomationDetailsTabCell()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@end
@implementation ClientInfomationDetailsTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpData:(InformationListModel *)moodel{
    [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:moodel.picture]] placeholderImage:[UIImage imageNamed:@"suo-tu-1"]];
    self.timeLab.text = [NSString stringWithFormat:@"%@/%@阅读量",[NSString ConvertStrToTime:moodel.create_time],moodel.views];
    self.titleLab.text = moodel.title;
}

@end
