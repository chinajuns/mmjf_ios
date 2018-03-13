//
//  LoanerJiltSingleStateTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerJiltSingleStateTabCell.h"
#import "LoanerJiltjunkDetail.h"

@interface LoanerJiltSingleStateTabCell()

@property (weak, nonatomic) IBOutlet UILabel *create_timeLab1;
@property (weak, nonatomic) IBOutlet UILabel *create_timelab2;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@end
@implementation LoanerJiltSingleStateTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpState:(LoanerJiltjunkDetail *)model{
    self.create_timeLab1.text = self.create_timelab2.text = [NSString ConvertStrToTime:model.create_time];
    NSString *junk_status = [NSString stringWithFormat:@"%@",model.junk_status];
    if ([junk_status isEqualToString:@"1"] || [junk_status isEqualToString:@"2"]) {
        self.stateLab.textColor = MMJF_COLOR_Yellow;
    }else if ([junk_status isEqualToString:@"4"]){
        self.stateLab.textColor = [UIColor colorWithHexString:@"#b3b3b3"];
    }else{
        self.stateLab.textColor = MMJF_COLOR_RED_MINT;
    }
    self.stateLab.text = model.label;
}

@end
