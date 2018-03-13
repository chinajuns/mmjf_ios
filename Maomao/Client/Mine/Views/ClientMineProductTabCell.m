//
//  ClientMineProductTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineProductTabCell.h"


@implementation ClientMineProductTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//设置数据
- (void)setUpData:(ClientMineProductModel *)model{
    self.name.text = model.name;
    if ([model.is_auth isEqualToString:@"1"]) {
        self.certificationImg.image = [UIImage imageNamed:@"wei-ren-zheng"];
    }else{
        self.certificationImg.image = [UIImage imageNamed:@"yi-ren-zheng"];
    }
    self.timeLab.text = [NSString stringWithFormat:@"%@天",model.loan_day];
    self.scoreLab.text = model.score;
    self.titleLab.text = model.tag;
    [self setUpScoreView:model];
}

//设置打分控件
- (void)setUpScoreView:(ClientMineProductModel *)model{
    TQStarRatingView * serviceStar = [[TQStarRatingView alloc] initWithFrame:self.scoreView.bounds numberOfStar:kNUMBER_OF_STAR spacing:0];
    serviceStar.delegate = self;
    CGFloat score = [model.score floatValue] * 2 / 10;
    [serviceStar setScore:score withAnimation:YES];
    [self.scoreView addSubview:serviceStar];
}

@end
