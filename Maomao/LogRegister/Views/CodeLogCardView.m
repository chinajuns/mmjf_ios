//
//  CardView.m
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import "CodeLogCardView.h"

@interface CodeLogCardView ()<UITextFieldDelegate>{
    CGFloat _currentAngle;
}


@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLine;
@property (weak, nonatomic) IBOutlet UILabel *phoneError;
@property (weak, nonatomic) IBOutlet UILabel *passwordLine;
@property (weak, nonatomic) IBOutlet UILabel *passwordError;
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;

@property (nonatomic, strong)RACSignal *codeSignal;
@property (nonatomic, strong)RACSignal *phoneSignal;
@property (nonatomic, assign)BOOL isOk;
@property (nonatomic, strong)RACDisposable *dispoable;
@property (nonatomic, assign)NSInteger time;


@end

@implementation CodeLogCardView

-(void)awakeFromNib
{
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
    self.codeSignal = [weakSelf.passWordText.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        if (value.length == 0) {
            weakSelf.isOk = NO;
        }
        return @(value.length);
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
    // 通过信号道返回的值，设置文本字体
    RAC(weakSelf.phoneError, text) = [weakSelf.phoneSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return @"";
        }
        return [value boolValue] ? @"" : @"请输入正确的手机号";
    }];
    // 通过信号道返回的值，设置文本颜色
    RAC(weakSelf.passwordLine, backgroundColor) = [weakSelf.codeSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return MMJF_COLOR_Gray;
        }
        return [value boolValue] ? MMJF_COLOR_Gray : MMJF_COLOR_RED_MINT;
    }];
    // 通过信号道返回的值，设置文本字体
    RAC(weakSelf.passwordError, text) = [weakSelf.codeSignal map:^id(id value) {
        if (weakSelf.isOk == NO) {
            return @"";
        }
        return [value boolValue] ? @"" : @"请输入正确的验证码";
    }];
    
}
#pragma mark--按钮点击
//设置RAC点击
- (void)setUpRACClick{
    __weak typeof(self)weakSelf = self;
    // 创建登陆按钮信号道，并合并用户名和密码信号道
    RACSignal *loginSignal = [RACSignal combineLatest:@[_phoneSignal,_codeSignal] reduce:^id(NSNumber *phoneValue,NSNumber *codeValue){
        return @([phoneValue boolValue] && [codeValue boolValue]);
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
    
    
    
    @weakify(self);
    //获取验证码
    [[self.codeBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self endEditing:YES];
        self.phoneText.enabled = NO;
        NSDictionary *dic = @{@"mobile":self.phoneText.text,@"type":@"verify_code"};
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
            _time --;
            NSString * title = _time > 0 ? [NSString stringWithFormat:@"%ld秒后重试",_time] : @"重新获取";
            [self.codeBut setTitle:title forState:UIControlStateNormal | UIControlStateDisabled];
            self.codeBut.enabled = (_time==0)? YES : NO;
            if (_time == 0) {
                self.phoneText.enabled = YES;
                [self.codeBut setTitleColor:MMJF_COLOR_Yellow forState:UIControlStateNormal];
                [self.codeBut setBackgroundColor:MMJF_COLOR_Black];
                [self.codeBut setTitle:@"重新获取" forState:UIControlStateNormal];
                [self.dispoable dispose];
            }
        }];
    }];
    
}

#pragma mark--UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.isOk = YES;
    if (textField.tag == 0) {
        [self setUpheadImage];
    }
}
//设置登录头像
- (void)setUpheadImage{
    NSString *str = [MMJF_DEFAULTS objectForKey:self.phoneText.text];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:str]] placeholderImage:[UIImage imageNamed:@"denglu-mei-you-tou-xiang"]];
}
///设置阴影
- (void)setViewShadow {
    self.loginBut.layer.cornerRadius = 20;
    self.loginBut.layer.masksToBounds = YES;
    [self.backView.layer setShadow:6 opacity:1 color:[UIColor colorWithRed:245.0f/255.0f green:143.0f/255.0f blue:0.0f/255.0f alpha:0.7f] shadowRadius:12 shadowOffset:CGSizeMake(2, 3)];
    self.codeBut.layer.cornerRadius = 5;
    self.codeBut.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = 40;
    self.headImage.layer.masksToBounds = YES;
    //
    NSString *string = @"登录即表示您同意《毛毛金服服务协议》";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:MMJF_COLOR_Gray};
    [attrString setAttributes:attributes range:[string rangeOfString:@"登录即表示您同意"]];
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName:MMJF_COLOR_Yellow};
    [attrString setAttributes:attributes1 range:[string rangeOfString:@"《毛毛金服服务协议》"]];
    self.agreementLabel.attributedText = attrString;
}
//设置输入框
- (void)settextFile{
    self.phoneText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneText.delegate = self;
    self.passWordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passWordText.delegate = self;
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
#pragma mark--getter
- (ClientPublicBaseViewModel *)publicBaseViewModel{
    if (!_publicBaseViewModel) {
        _publicBaseViewModel = [[ClientPublicBaseViewModel alloc]init];
    }
    return _publicBaseViewModel;
}

@end
