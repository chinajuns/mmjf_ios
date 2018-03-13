//
//  ClientMineOrderStateTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineOrderStateTabCell.h"
#import "ClientHomeListCardView.h"
#import "ClientMineOrderStatusCardView.h"

@implementation ClientMineOrderStateTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

//    [self.backView.layer setShadow:5 opacity:1 color:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.1f] shadowRadius:3 shadowOffset:CGSizeMake(0, 4)];
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
}
//订单信息
- (void)setUpListData:(NSDictionary *)listDict{
    ClientHomeListCardView *card = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeListCardView" owner:self options:nil] lastObject];
    card.frame = self.dataView.bounds;
    card.cardClick.userInteractionEnabled = NO;
    [card setUpdata:listDict];
    [self.dataView addSubview:card];
}
//订单状态
- (void)setUpStats:(NSArray *)processing all_process:(NSArray *)all_process process:(NSString *)process{
    ClientMineOrderStatusCardView *card1 = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineOrderStatusCardView" owner:self options:nil] lastObject];
    card1.frame = self.statsView.bounds;
    [self.statsView addSubview:card1];
    [card1 setUpData:processing all_process:all_process process:process];
}
@end
