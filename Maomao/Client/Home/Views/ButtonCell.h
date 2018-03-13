//
//  ButtonCell.h
//  Maomao
//
//  Created by 御顺 on 2017/9/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ButtonDelegate <NSObject>

@optional

- (void)handleEvent:(UIButton *)sender;

@end

@interface ButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *operationBut;

@property (nonatomic, weak) id<ButtonDelegate> delegate;

- (void)setUpData:(NSString *)title number:(NSInteger)number dict:(NSDictionary *)dict count:(NSInteger)count;
@end
