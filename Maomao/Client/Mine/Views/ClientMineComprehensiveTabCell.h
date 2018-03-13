//
//  ClientMineComprehensiveTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientMineComprehensiveTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *starsView1;
@property (weak, nonatomic) IBOutlet UIView *starsView2;
@property (weak, nonatomic) IBOutlet UIView *starsView3;

@property (nonatomic, strong)RACSubject *starsSubject;

- (void)setUpData:(NSArray *)types;
@end
