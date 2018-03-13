//
//  TopUpAmountTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopUpAmountTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *amount1;
@property (weak, nonatomic) IBOutlet UILabel *lines1;

@property (weak, nonatomic) IBOutlet UIButton *amount2;
@property (weak, nonatomic) IBOutlet UILabel *lines2;

@property (weak, nonatomic) IBOutlet UIButton *amount3;
@property (weak, nonatomic) IBOutlet UILabel *lines3;

@property (weak, nonatomic) IBOutlet UIButton *amount4;
@property (weak, nonatomic) IBOutlet UILabel *lines4;

@property (weak, nonatomic) IBOutlet UIButton *amount5;
@property (weak, nonatomic) IBOutlet UILabel *lines5;

@property (weak, nonatomic) IBOutlet UIButton *amount6;
@property (weak, nonatomic) IBOutlet UILabel *lines6;

@property (weak, nonatomic) IBOutlet UIButton *amount7;
@property (weak, nonatomic) IBOutlet UILabel *lines7;
@property (nonatomic, copy)NSArray *butArray;
@property (nonatomic, copy)NSArray *linesArray;
@end
