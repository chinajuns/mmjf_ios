//
//  LoanerStoreEvaluationTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreEvaluationTabCell.h"
#import "TQStarRatingView.h"
@interface LoanerStoreEvaluationTabCell()<StarRatingViewDelegate>
@property (nonatomic, strong)TQStarRatingView *star1;
@end
@implementation LoanerStoreEvaluationTabCell

- (void)dealloc{
    [self.starSubject sendCompleted];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.starSubject = [RACSubject subject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpStar:(NSString *)score{
    CGFloat f = [score floatValue] * 2 / 10.f;
    self.star1 = [[TQStarRatingView alloc] initWithFrame:self.starView.bounds numberOfStar:kNUMBER_OF_STAR spacing:0];
    self.star1.delegate = self;
    self.star1.tag = 0;
    [self.star1 setScore:f withAnimation:YES];
    [self.starView addSubview:self.star1];
}

- (void)starRatingView:(TQStarRatingView *)view score:(float)score{
    MMJF_Log(@"ssss%f",score);
    [self.starSubject sendNext:[NSString stringWithFormat:@"%.1f",score * 5]];
}
@end
