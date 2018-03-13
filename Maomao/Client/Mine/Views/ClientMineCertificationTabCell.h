//
//  ClientMineCertificationTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientMineCertificationTabCell : UITableViewCell

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

/**
 图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *img;

/**
 按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *clickBut;

- (void)setUpimg:(NSString *)url number:(NSInteger)number img:(UIImage *)img;
@end
