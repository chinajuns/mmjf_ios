//
//  ThereHintsButTabCell.h
//  Maomao
//
//  Created by 御顺 on 2018/1/31.
//  Copyright © 2018年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ThereHintsButDelegate <NSObject>

@optional

- (void)handleEvent:(UIButton *)sender;

@end
@interface ThereHintsButTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *cilckBut;
@property (nonatomic, weak) id<ThereHintsButDelegate> delegate;
- (void)setUpData:(NSString *)title number:(NSInteger)number dict:(NSDictionary *)dict count:(NSInteger)count;
@end
