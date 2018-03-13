//
//  LoanerCountdownTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerCountdownTabCell.h"


@implementation LoanerCountdownTabCell

- (void)dealloc{
    [self.endSubject sendCompleted];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countDown = [[CountDown alloc] init];
    self.endSubject = [RACSubject subject];
//    __weak __typeof(self) weakSelf= self;
    self.hoursLab.layer.cornerRadius = self.pointsLab.layer.cornerRadius = self.secondsLab.layer.cornerRadius = 5;
    self.hoursLab.layer.masksToBounds = self.pointsLab.layer.masksToBounds = self.secondsLab.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)getNowTimeWithString:(NSString *)aTimeString{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:aTimeString];
    NSDate  *nowDate = [NSDate date];
    // 当前时间字符串格式
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    // 当前时间date格式
    nowDate = [formater dateFromString:nowDateStr];
    
    NSTimeInterval timeInterval =[expireDate timeIntervalSinceDate:nowDate];
    
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours + days * 24];
    //分钟
    if(minutes<10){
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    }else{
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    }
    //秒
    if(seconds < 10){
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    }else{
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    }
    if (hours<=0&&minutes<=0&&seconds<=0) {
        self.hoursLab.text = @"00";
        self.pointsLab.text = @"00";
        self.secondsLab.text = @"00";
        [self.endSubject sendNext:@""];
        [self.countDown destoryTimer];
        return;
    }
//    if (days) {
//        return [NSString stringWithFormat:@"%@天 %@小时 %@分 %@秒", dayStr,hoursStr, minutesStr,secondsStr];
//    }
    self.hoursLab.text = hoursStr;
    self.pointsLab.text = minutesStr;
    self.secondsLab.text = secondsStr;
}


@end
