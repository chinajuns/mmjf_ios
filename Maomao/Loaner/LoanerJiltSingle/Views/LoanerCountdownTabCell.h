//
//  LoanerCountdownTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountDown.h"

@interface LoanerCountdownTabCell : UITableViewCell

@property (strong, nonatomic)  CountDown *countDown;

@property (nonatomic, strong)RACSubject *endSubject;
@property (weak, nonatomic) IBOutlet UILabel *hoursLab;
@property (weak, nonatomic) IBOutlet UILabel *pointsLab;

@property (weak, nonatomic) IBOutlet UILabel *secondsLab;

- (void)getNowTimeWithString:(NSString *)aTimeString;

@end
