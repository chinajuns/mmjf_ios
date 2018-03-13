//
//  UIViewController+Navigation.h
//  Maomao
//
//  Created by 御顺 on 2017/10/31.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Navigation)

/**
 设置标题

 @param title 标题
 */
- (void)titleView:(NSString *)title;

/**
 设置右导航栏按钮

 @param image 图标名称
 @param highImage 高亮图片名称
 @param rightButton 按钮
 */
- (void)itemWithImage:(NSString *)image highImage:(NSString *)highImage rightButton:(UIButton *)rightButton;

/**
 设置右导航按钮消息条数

 @param count 消息条数
 @param rightButton 按钮
 */
- (void)setRightCount:(NSString *)count rightButton:(UIButton *)rightButton;
@end
