//
//  ClientEvaluationTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "ClientEvaluationModel.h"
@interface ClientEvaluationTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *starsView;

- (void)setUpData:(ClientEvaluationModel *)model;
@end
