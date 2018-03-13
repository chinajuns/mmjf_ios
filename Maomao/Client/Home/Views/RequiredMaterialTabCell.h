//
//  RequiredMaterialTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequiredMaterialTabCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
/**
 传入字符串
 */
- (void)setUpData:(NSString *)content;
/**
 传入数组
 */
- (void)setUpDataArray:(NSArray *)contents;
@end
