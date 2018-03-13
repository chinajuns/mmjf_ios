//
//  ClientMineHeadTablCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientMineHeadTablCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *leftBut;

@property (weak, nonatomic) IBOutlet UIButton *rightBut;

@property (weak, nonatomic) IBOutlet UIButton *headBut;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property (weak, nonatomic) IBOutlet UILabel *loansLab;
@property (weak, nonatomic) IBOutlet UILabel *counterLab;

@end
