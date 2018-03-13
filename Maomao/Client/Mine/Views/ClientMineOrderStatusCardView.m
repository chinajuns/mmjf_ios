//
//  CardView.m
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import "ClientMineOrderStatusCardView.h"

@interface ClientMineOrderStatusCardView ()

@end

@implementation ClientMineOrderStatusCardView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setUpData:(NSArray *)processing all_process:(NSArray *)all_process process:(NSString *)process{
    NSString *processStr = [NSString stringWithFormat:@"%@",process];
    for (int i = 0; i < all_process.count; i ++) {
        NSDictionary *dic = all_process[i];
        NSString *iId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        for (int j = 0; j < processing.count; j ++) {
            NSDictionary *dic1 = all_process[j];
            NSString *jId = [NSString stringWithFormat:@"%@",dic1[@"id"]];
            if ([processStr isEqualToString:@"38"]) {
                if (processing.count == 1) {
                    self.status1.image = [UIImage imageNamed:@"shen-qing-shi-bai"];
                }else if (processing.count == 2){
                    self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
                    self.status1.image = [UIImage imageNamed:@"shen-qing-huang"];
                    self.status2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-shi-bai"];
                }else if (processing.count == 3){
                    self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
                    self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
                    self.status1.image = [UIImage imageNamed:@"shen-qing-huang"];
                    self.status2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
                    self.status3.image = [UIImage imageNamed:@"shen-pi-zi-liao-shi-bai"];
                }else{
                    self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
                    self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
                    self.lineView3.backgroundColor = MMJF_COLOR_Yellow;
                    self.status1.image = [UIImage imageNamed:@"shen-qing-huang"];
                    self.status2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
                    self.status3.image = [UIImage imageNamed:@"shen-pi-zi-liao-huang"];
                    self.status4.image = [UIImage imageNamed:@"shen-pi-fang-kuan-shi-bai"];
                }
                return;
            }
            if (i == 0) {
                if ([iId isEqualToString:jId]) {
                    self.status1.image = [UIImage imageNamed:@"shen-qing-huang"];
                    continue;
                }
            }else if (i == 1){
                if ([iId isEqualToString:jId]) {
                    self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
                    self.status2.image = [UIImage imageNamed:@"zi-liao-ti-jiao-huang"];
                    continue;
                }
            }else if (i == 2){
                if ([iId isEqualToString:jId]) {
                    self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
                    self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
                    self.status3.image = [UIImage imageNamed:@"shen-pi-zi-liao-huang"];
                    continue;
                }
            }else{
                if ([iId isEqualToString:jId]) {
                    self.lineView1.backgroundColor = MMJF_COLOR_Yellow;
                    self.lineView2.backgroundColor = MMJF_COLOR_Yellow;
                    self.lineView3.backgroundColor = MMJF_COLOR_Yellow;
                    self.status4.image = [UIImage imageNamed:@"shen-pi-fang-kuan-huang"];
                    continue;
                }
            }
        }
    }
}
@end
