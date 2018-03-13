//
//  CardView.m
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import "LogCardView.h"

@interface LogCardView ()<UITextFieldDelegate>{
    CGFloat _currentAngle;
}

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLine;
@property (weak, nonatomic) IBOutlet UILabel *phoneError;
@property (weak, nonatomic) IBOutlet UILabel *passwordLine;
@property (weak, nonatomic) IBOutlet UILabel *passwordError;
@property (nonatomic, strong)RACSignal *passwordSignal;
@property (nonatomic, strong)RACSignal *phoneSignal;
@property (nonatomic, assign)BOOL isOk;
@end

@implementation LogCardView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setViewShadow];
    [self settextFile];
    [self setUpRAC];
    
    
}
//设置登录头像
- (void)setUpheadImage{
    NSString *str = [MMJF_DEFAULTS objectForKey:self.phoneText.text];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:str]] placeholderImage:[UIImage imageNamed:@"denglu-mei-you-tou-xiang"]];
    
}

//设置信号
- (void)setUpRAC{
    __weak typeof(self)weakSelf = self;
    // 创建用户名信号道
    self.phoneSignal = [weakSelf.phoneText.rac_textSignal map:^id(NSString *value) {
        if (value.length > 10) {
            weakSelf.isOk = YES;
        }else if (value.length == 0){
            weakSelf.isOk = NO;
        }
        return @([CManager validateMobile:value]);
    }];
    // 创建密码信号道
    self.passwordSignal = [weakSelf.passWordText.rac_textSignal map:^id(NSString *value) {
        if (value.length > 6) {
            weakSelf.isOk = YES;
        }else if (value.length == 0){
            weakSelf.isOk = NO;
        }
        return @([CManager validatePassword:value]);
    }];

    // 通过信号道返回的值，设置文本颜色
    RAC(weakSelf.phoneLine, backgroundColor) = [weakSelf.phoneSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return MMJF_COLOR_Gray;
        }
        return [value boolValue] ? MMJF_COLOR_Gray : MMJF_COLOR_RED_MINT;
    }];
    // 通过信号道返回的值，设置文本字体颜色
    RAC(weakSelf.phoneError, text) = [weakSelf.phoneSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return @"";
        }
        return [value boolValue] ? @"" : @"请输入0~9纯数字手机号";
    }];
    // 通过信号道返回的值，设置文本颜色
    RAC(weakSelf.passwordLine, backgroundColor) = [weakSelf.passwordSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return MMJF_COLOR_Gray;
        }
        return [value boolValue] ? MMJF_COLOR_Gray : MMJF_COLOR_RED_MINT;
    }];
    // 通过信号道返回的值，设置文本字体颜色
    RAC(weakSelf.passwordError, text) = [weakSelf.passwordSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return @"";
        }
        return [value boolValue] ? @"" : @"请设置6-16位密码（数字+字母组合）";
    }];
    // 创建登陆按钮信号道，并合并用户名和密码信号道
    RACSignal *loginSignal = [RACSignal combineLatest:@[_phoneSignal, _passwordSignal] reduce:^id(NSNumber *phoneValue, NSNumber *passwordValue){
        return @([phoneValue boolValue] && [passwordValue boolValue]);
    }];
    // 订阅信号
    [loginSignal subscribeNext:^(id boolValue) {
        if ([boolValue boolValue]) {
            weakSelf.loginBut.userInteractionEnabled = YES;
            [weakSelf.loginBut setTitleColor:MMJF_COLOR_Yellow forState:UIControlStateNormal];
            [weakSelf.loginBut setBackgroundColor:MMJF_COLOR_Black];
        }else {
            weakSelf.loginBut.userInteractionEnabled = NO;
            [weakSelf.loginBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [weakSelf.loginBut setBackgroundColor:MMJF_COLOR_Gray];
        }
    }];
}
#pragma mark--UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.isOk = YES;
    if (textField.tag == 0) {
        [self setUpheadImage];
    }
}

//设置输入框
- (void)settextFile{
    self.phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneText.delegate = self;
    self.passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passWordText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passWordText.delegate = self;
    self.passWordText.secureTextEntry = YES;
}

///设置阴影
- (void)setViewShadow {
    self.loginBut.layer.cornerRadius = 20;
    self.loginBut.layer.masksToBounds = YES;
    [self.backView.layer setShadow:6 opacity:1 color:[UIColor colorWithRed:245.0f/255.0f green:143.0f/255.0f blue:0.0f/255.0f alpha:0.7f] shadowRadius:12 shadowOffset:CGSizeMake(2, 3)];
    self.headImage.layer.cornerRadius = 40;
    self.headImage.layer.masksToBounds = YES;
}
//右移除
- (void)removeWithRight:(CGRect)frame{
    [UIView animateWithDuration:0.9 animations:^{
        self.alpha = 0;
        self.center = CGPointMake(self.frame.size.width + 1000, self.center.y + _currentAngle * self.frame.size.height + (_currentAngle == 0 ? 100 : 0));
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.frame = frame;
        }
    }];
}
//缩放
- (void)amplification:(CGRect)frame{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            //            [self removeFromSuperview];
        }
    }];
}
- (IBAction)eyesBut:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.passWordText.secureTextEntry = NO;
    }else{
        self.passWordText.secureTextEntry = YES;
    }
}

#pragma mark--getter
- (ClientLogCardViewModel *)clientLogViewModel{
    if (!_clientLogViewModel) {
        _clientLogViewModel = [[ClientLogCardViewModel alloc]init];
    }
    return _clientLogViewModel;
}

@end
