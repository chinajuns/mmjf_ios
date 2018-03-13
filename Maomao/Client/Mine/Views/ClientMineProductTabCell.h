//
//  ClientMineProductTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientMineProductModel.h"
#import "TQStarRatingView.h"
@interface ClientMineProductTabCell : UITableViewCell<StarRatingViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *certificationImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UIView *scoreView;

- (void)setUpData:(ClientMineProductModel *)model;
@end
