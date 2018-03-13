//
//  CardView.m
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import "RegisteredCardView.h"

@interface RegisteredCardView ()<UITextFieldDelegate>{
    CGFloat _currentAngle;
}
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLine;
@property (weak, nonatomic) IBOutlet UILabel *phoneErrorlabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLine;
@property (weak, nonatomic) IBOutlet UILabel *codeErrorLabeel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLine;
@property (weak, nonatomic) IBOutlet UILabel *passwordErrorLabel;

@property (nonatomic, strong)RACSignal *passwordSignal;
@property (nonatomic, strong)RACSignal *phoneSignal;
@property (nonatomic, strong)RACSignal *codeSignal;
@property (nonatomic, assign)BOOL isOk;
@property (nonatomic, strong)RACDisposable *dispoable;
@property (nonatomic, assign)NSInteger time;
@end

@implementation RegisteredCardView

-(void)awakeFromNib
{
//    @weakify(self);
    [super awakeFromNib];
    [self setViewShadow];
    [self settextFile];
    [self setUpRAC];
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
    //创建验证码信道
    self.codeSignal = [weakSelf.codeText.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        if (value.length == 0) {
            weakSelf.isOk = NO;
        }
        return @(value.length);
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
    //获取值
    [self setUpRACvalue];
    //设置点击状态
    [self setUpRACClick];
}

//设置参数
- (void)setUpRACvalue{
    __weak typeof(self)weakSelf = self;
    // 通过信号道返回的值，设置按钮点击状态
    RAC(weakSelf.codeBut, enabled) = [weakSelf.phoneSignal map:^id(id value) {
        if ([value boolValue]) {
            [weakSelf.codeBut setTitleColor:MMJF_COLOR_Yellow forState:UIControlStateNormal];
        }else{
            [weakSelf.codeBut setTitleColor:MMJF_COLOR_Black forState:UIControlStateNormal];
        }
        return @([value boolValue]);
    }];
    // 通过信号道返回的值，设置按钮点击状态
    RAC(weakSelf.codeBut, backgroundColor) = [weakSelf.phoneSignal map:^id(id value) {
        return [value boolValue] ? MMJF_COLOR_Black : MMJF_COLOR_Gray;
    }];
    // 通过信号道返回的值，设置文本颜色
    RAC(weakSelf.phoneLine, backgroundColor) = [weakSelf.phoneSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return MMJF_COLOR_Gray;
        }
        return [value boolValue] ? MMJF_COLOR_Gray : MMJF_COLOR_RED_MINT;
    }];
    // 通过信号道返回的值，设置文本字体颜色
    RAC(weakSelf.phoneErrorlabel, text) = [weakSelf.phoneSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return @"";
        }
        return [value boolValue] ? @"" : @"请输入0~9的纯数字手机号";
    }];
    // 通过信号道返回的值，设置文本颜色
    RAC(weakSelf.codeLine, backgroundColor) = [weakSelf.codeSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return MMJF_COLOR_Gray;
        }
        return [value boolValue] ? MMJF_COLOR_Gray : MMJF_COLOR_RED_MINT;
    }];
    // 通过信号道返回的值，设置文本字体颜色
    RAC(weakSelf.codeErrorLabeel, text) = [weakSelf.codeSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return @"";
        }
        return [value boolValue] ? @"" : @"请输入正确的验证码";
    }];
    // 通过信号道返回的值，设置文本颜色
    RAC(weakSelf.passwordLine, backgroundColor) = [weakSelf.passwordSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return MMJF_COLOR_Gray;
        }
        return [value boolValue] ? MMJF_COLOR_Gray : MMJF_COLOR_RED_MINT;
    }];
    // 通过信号道返回的值，设置文本字体颜色
    RAC(weakSelf.passwordErrorLabel, text) = [weakSelf.passwordSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return @"";
        }
        return [value boolValue] ? @"" : @"请设置6-16位密码（数字+字母组合）";
    }];
    
}

#pragma mark--按钮点击
//设置RAC点击
- (void)setUpRACClick{
    __weak typeof(self)weakSelf = self;
    // 创建登陆按钮信号道，并合并用户名和密码信号道
    RACSignal *loginSignal = [RACSignal combineLatest:@[_phoneSignal, _passwordSignal,_codeSignal] reduce:^id(NSNumber *phoneValue, NSNumber *passwordValue,NSNumber *codeValue){
        return @([phoneValue boolValue] && [passwordValue boolValue] && [codeValue boolValue]);
    }];
    // 订阅信号
    [loginSignal subscribeNext:^(id boolValue) {
        if ([boolValue boolValue]) {
            weakSelf.registeredBut.userInteractionEnabled = YES;
            [weakSelf.registeredBut setTitleColor:MMJF_COLOR_Yellow forState:UIControlStateNormal];
            [weakSelf.registeredBut setBackgroundColor:MMJF_COLOR_Black];
        }else {
            weakSelf.registeredBut.userInteractionEnabled = NO;
            [weakSelf.registeredBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [weakSelf.registeredBut setBackgroundColor:MMJF_COLOR_Gray];
        }
    }];
    
    
    
    @weakify(self);
    //获取验证码
    [[self.codeBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self endEditing:YES];
        self.phoneText.enabled = NO;
        NSDictionary *dic = @{@"mobile":self.phoneText.text,@"type":@"register"};
        [self.publicBaseViewModel.getCodeCommand execute:dic];
    }];
    
    //获取验证码成功的回调
    [self.publicBaseViewModel.getCodeCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.codeBut.enabled = false;
        self.time = 120;
        [self.codeBut setTitle:@"120秒后重试" forState:UIControlStateNormal];
        [self.codeBut setTitleColor:MMJF_COLOR_Black forState:UIControlStateNormal];
        [self.codeBut setBackgroundColor:MMJF_COLOR_Gray];
        //这个就是RAC中的GCD
        self.dispoable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
            self.time --;
            NSString * title = _time > 0 ? [NSString stringWithFormat:@"%ld秒后重试",_time] : @"重新获取";
            [self.codeBut setTitle:title forState:UIControlStateNormal | UIControlStateDisabled];
            self.codeBut.enabled = (self.time==0)? YES : NO;
            if (self.time == 0) {
                self.phoneText.enabled = YES;
                [self.codeBut setTitleColor:MMJF_COLOR_Yellow forState:UIControlStateNormal];
                [self.codeBut setBackgroundColor:MMJF_COLOR_Black];
                [self.codeBut setTitle:@"重新获取" forState:UIControlStateNormal];
                [self.dispoable dispose];
            }
        }];
    }];
    
    [[self.agreedBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.agreedBut.selected = !self.agreedBut.selected;
    }];
}
//密码可见不能见
- (IBAction)eyesBut:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.passWordText.secureTextEntry = NO;
    }else{
        self.passWordText.secureTextEntry = YES;
    }
}

#pragma mark--UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.isOk = YES;
}

//设置输入框
- (void)settextFile{
    self.phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneText.delegate = self;
    self.passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passWordText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passWordText.delegate = self;
    self.passWordText.secureTextEntry = YES;
    self.codeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.codeText.delegate = self;
}
//缩放
- (void)amplification:(CGRect)frame{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
//            [self removeFromSuperview];
//            [self setViewShadow];
        }
    }];
}
//左移除
- (void)removeWithLeft:(CGRect)frame{
    [UIView animateWithDuration:0.9 animations:^{
        self.alpha = 0;
        self.center = CGPointMake(- 1000, self.center.y - _currentAngle * self.frame.size.height + (_currentAngle == 0 ? 100 : 0));
        
    } completion:^(BOOL finished) {
        if (finished) {
            self.frame = frame;
        }
    }];
}
//阴影
- (void)setViewShadow{
    self.registeredBut.layer.cornerRadius = 20;
    self.registeredBut.layer.masksToBounds = YES;
    self.codeBut.layer.cornerRadius = 5;
    self.codeBut.layer.masksToBounds = YES;
    [self.backView.layer setShadow:6 opacity:1 color:[UIColor colorWithRed:245.0f/255.0f green:143.0f/255.0f blue:0.0f/255.0f alpha:0.7f] shadowRadius:12 shadowOffset:CGSizeMake(2, 3)];
}

- (ClientPublicBaseViewModel *)publicBaseViewModel{
    if (!_publicBaseViewModel) {
        _publicBaseViewModel = [[ClientPublicBaseViewModel alloc]init];
    }
    return _publicBaseViewModel;
}


@end
