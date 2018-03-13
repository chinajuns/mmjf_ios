//
//  ClientMineOrderStateDetailsTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/6.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientMineProcessingModel.h"

@interface ClientMineOrderStateDetailsTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *statrBut;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *topLine;

@property (weak, nonatomic) IBOutlet UIView *bottomLine;

- (void)setUpData:(ClientMineProcessingModel *)model;
@end
