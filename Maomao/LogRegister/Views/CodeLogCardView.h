//
//  CardView.h
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeLogCardView : UIView
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
 验证码
 */
@property (weak, nonatomic) IBOutlet UIButton *codeBut;
/**
 服务协议
 */
@property (weak, nonatomic) IBOutlet UIButton *serviceAgreement;

@property (nonatomic, strong)ClientPublicBaseViewModel *publicBaseViewModel;
- (void)removeWithRight:(CGRect)frame;

- (void)amplification:(CGRect)frame;
@end
