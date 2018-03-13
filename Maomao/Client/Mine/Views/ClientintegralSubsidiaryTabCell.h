//
//  ClientintegralSubsidiaryTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientMineIntegralModel.h"

@interface ClientintegralSubsidiaryTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statesLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *integralLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

- (void)setUpData:(ClientMineIntegralModel *)integralModel;
@end
