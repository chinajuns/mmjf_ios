//
//  ClientEvaluationTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientEvaluationTabCell.h"

@interface ClientEvaluationTabCell()
@property (weak, nonatomic) IBOutlet UILabel *scoceLab;
@property (weak, nonatomic) IBOutlet UILabel *cotentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@end
@implementation ClientEvaluationTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpData:(ClientEvaluationModel *)model{
    self.timeLab.text = [NSString ConvertStrToTime:model.create_time];
    self.cotentLab.text = model.describe;
    self.nameLab.text = model.username;
    self.scoceLab.text = [NSString stringWithFormat:@"%@",model.score_avg];
    [self setUpScoreView:[NSString stringWithFormat:@"%@",model.score_avg]];
}

//设置打分控件
- (void)setUpScoreView:(NSString *)score_avg{
    TQStarRatingView * serviceStar = [[TQStarRatingView alloc] initWithFrame:self.starsView.bounds numberOfStar:kNUMBER_OF_STAR spacing:0];
    CGFloat scoce = [score_avg floatValue] * 2 / 10;
    [serviceStar setScore:scoce withAnimation:YES];
    [self.starsView addSubview:serviceStar];
}


@end
