//
//  ClientMineComprehensiveTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineComprehensiveTabCell.h"
#import "TQStarRatingView.h"

@interface ClientMineComprehensiveTabCell()<StarRatingViewDelegate>
@property (nonatomic, strong)TQStarRatingView *star1;
@property (nonatomic, strong)TQStarRatingView *star2;
@property (nonatomic, strong)TQStarRatingView *star3;

@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *title3;

@property (nonatomic, copy)NSArray *types;
@property (nonatomic, copy)NSString *score1;
@property (nonatomic, copy)NSString *score2;
@property (nonatomic, copy)NSString *score3;

@end
@implementation ClientMineComprehensiveTabCell

- (void)dealloc{
//    [self.starsSubject sendCompleted];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.starsSubject = [RACSubject subject];
    self.score1 = self.score2 = self.score3 = @"5.0";
    NSDictionary *dic = @{@"id":@""};
    self.types = @[dic,dic,dic];
    self.star1 = [[TQStarRatingView alloc] initWithFrame:self.starsView1.bounds numberOfStar:kNUMBER_OF_STAR spacing:0];
     self.star1.delegate = self;
    self.star1.tag = 0;
    [ self.star1 setScore:1.0f withAnimation:YES];
    [self.starsView1 addSubview:self.star1];
    
    self.star2 = [[TQStarRatingView alloc] initWithFrame:self.starsView1.bounds numberOfStar:kNUMBER_OF_STAR spacing:0];
    self.star2.delegate = self;
    self.star2.tag = 1;
    [ self.star2 setScore:1.0f withAnimation:YES];
    [self.starsView2 addSubview:self.star2];
    
    self.star3 = [[TQStarRatingView alloc] initWithFrame:self.starsView1.bounds numberOfStar:kNUMBER_OF_STAR spacing:0];
    self.star3.delegate = self;
    self.star3.tag = 2;
    [ self.star3 setScore:1.0f withAnimation:YES];
    [self.starsView3 addSubview:self.star3];
}

- (void)setUpData:(NSArray *)types{
    self.types = types;
    self.title1.text = types[0][@"attr_value"];
    self.title2.text = types[1][@"attr_value"];
    self.title3.text = types[2][@"attr_value"];
}
- (void)starRatingView:(TQStarRatingView *)view score:(float)score{
    MMJF_Log(@"ssss%f",score);
    __weak typeof(self)weakSelf = self;
    if (view.tag == 0) {
        weakSelf.score1 = [NSString stringWithFormat:@"%.1f",score * 5];
    }else if (view.tag == 1){
        weakSelf.score2 = [NSString stringWithFormat:@"%.1f",score * 5];
    }else{
        weakSelf.score3 = [NSString stringWithFormat:@"%.1f",score * 5];
    }
    NSDictionary *dic = @{[NSString stringWithFormat:@"%@",weakSelf.types[0][@"id"]]:weakSelf.score1,[NSString stringWithFormat:@"%@",weakSelf.types[1][@"id"]]:weakSelf.score2,[NSString stringWithFormat:@"%@",weakSelf.types[2][@"id"]]:weakSelf.score3};
    [weakSelf.starsSubject sendNext:dic];
}


@end
