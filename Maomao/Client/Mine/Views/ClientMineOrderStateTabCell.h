//
//  ClientMineOrderStateTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientMineOrderStateTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *dataView;

@property (weak, nonatomic) IBOutlet UIView *statsView;

@property (weak, nonatomic) IBOutlet UIView *evaluationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;

@property (weak, nonatomic) IBOutlet UIButton *evaluationBut;
@property (weak, nonatomic) IBOutlet UIView *backView;

//订单信息
- (void)setUpListData:(NSDictionary *)listDict;
//订单状态
- (void)setUpStats:(NSArray *)processing all_process:(NSArray *)all_process process:(NSString *)process;
@end
