//
//  ClientHomeInputBoxTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/11/29.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientHomeInputBoxTabCell : UITableViewCell
/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 选择输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *contentText;
/**
 输入框右边界线
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLine;

/**
 右箭头图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *arrowimage;

/**
 必填标记
 */
@property (weak, nonatomic) IBOutlet UILabel *mandatoryLab;

- (void)setUpData:(NSString *)title content:(NSString *)content index:(NSIndexPath *)index;
@end
