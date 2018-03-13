//
//  ClientInfomationHeadView.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientInfomationHeadView : UITableViewHeaderFooterView
/**
 更多按钮点击
 */
@property (weak, nonatomic) IBOutlet UIButton *clickbut;
/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titelLab;

@end
