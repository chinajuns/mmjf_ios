//
//  CardView.h
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientMineOrderStatusCardView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *status1;
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;

@property (weak, nonatomic) IBOutlet UIImageView *status2;

@property (weak, nonatomic) IBOutlet UIImageView *status3;

@property (weak, nonatomic) IBOutlet UIImageView *status4;

/**
 设置数据

 @param processing 状态详情数据
 @param all_process 所有状态数据
 */
- (void)setUpData:(NSArray *)processing all_process:(NSArray *)all_process process:(NSString *)process;
@end
