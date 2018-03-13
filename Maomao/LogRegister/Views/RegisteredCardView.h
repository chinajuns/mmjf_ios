//
//  CardView.h
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisteredCardView : UIView

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
/**
 头像按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *headImageBut;
/**
 手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
/**
 验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *codeText;
/**
 密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passWordText;
/**
 协议按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *agreedBut;

/**
 协议
 */
@property (weak, nonatomic) IBOutlet UIButton *agreementBut;

/**
 验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *codeBut;



/**
 注册按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *registeredBut;
/**
 登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *logBut;

@property (nonatomic, strong)ClientPublicBaseViewModel *publicBaseViewModel;

- (void)amplification:(CGRect)frame;

- (void)removeWithLeft:(CGRect)frame;
@end
