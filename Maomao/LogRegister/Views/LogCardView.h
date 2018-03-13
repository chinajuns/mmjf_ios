//
//  CardView.h
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientLogCardViewModel.h"

@interface LogCardView : UIView
/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

/**
 手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
/**
 密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
/**
 登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *loginBut;
/**
 注册按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *registeredBut;

/**
 忘记密码
 */
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordBut;
//
@property (nonatomic, strong)ClientLogCardViewModel *clientLogViewModel;

- (void)removeWithRight:(CGRect)frame;

- (void)amplification:(CGRect)frame;
@end
