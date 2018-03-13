//
//  RetrievePasswordTwoViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/23.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "RetrievePasswordTwoViewController.h"
#import "ErrorMessageView.h"

@interface RetrievePasswordTwoViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordOne;
@property (weak, nonatomic) IBOutlet UITextField *passwordTwo;

@property (weak, nonatomic) IBOutlet UIButton *submitBut;
@property (nonatomic, strong)ErrorMessageView *passwordOneError;
@property (nonatomic, strong)ErrorMessageView *passwordTwoError;

@property (nonatomic, strong)ClientPublicBaseViewModel *publicBaseViewModel;

@property (nonatomic, strong)RACSignal *passwordOneSignal;
@property (nonatomic, strong)RACSignal *passwordTwoSignal;
@property (nonatomic, assign)BOOL isOk;
/**
 判断是否刚进入
 */
@property (nonatomic, assign)BOOL isOnly;
@end

@implementation RetrievePasswordTwoViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}
//视图加载完成
//由于需要加载正确的frame错误提示view在此加载
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (_isOnly == NO) {
        [self.view addSubview:_passwordOneError];
        [self.view addSubview:_passwordTwoError];
        [self setUpRAC];
    }
}
//需要获取正确的frame在这里获取
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _passwordOneError = [[ErrorMessageView alloc]initWithFrame:self.passwordOne.frame];
    _passwordTwoError = [[ErrorMessageView alloc]initWithFrame:self.passwordTwo.frame];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    [self setUpshadow];
    [self settextFile];
}

//设置RAC
- (void)setUpRAC{
    @weakify(self);
    // 创建密码一
    self.passwordOneSignal = [self.passwordOne.rac_textSignal map:^id(NSString *value) {
        @strongify(self);
        if (value.length > 6) {
            self.isOk = YES;
        }else if (value.length == 0){
            self.isOk = NO;
        }
        return @([CManager validatePassword:value]);
    }];
    //密码二
    self.passwordTwoSignal = [self.passwordTwo.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self);
        if (value.length > 6) {
            self.isOk = YES;
        }else if (value.length == 0){
            self.isOk = NO;
        }
        if (![self.passwordOne.text isEqualToString:value]) {
            return @(NO);
        }
        return @([CManager validatePassword:value]);
    }];
    //获取值
    [self setUpRACvalue];
    //设置点击状态
    [self setUpClick];
}
//设置参数
- (void)setUpRACvalue{
    @weakify(self);
    // 通过信号道返回的值，设置文本颜色
    RAC(self.passwordOneError.lineLabel, backgroundColor) = [self.passwordOneSignal map:^id(id value) {
        @strongify(self);
        if (self.isOk == NO) {
            return MMJF_COLOR_Gray;
        }
        return [value boolValue] ? MMJF_COLOR_Gray : MMJF_COLOR_RED_MINT;
    }];
    // 通过信号道返回的值，设置文本字体颜色
    RAC(self.passwordOneError.contentLabel, text) = [self.passwordOneSignal map:^id(id value) {
        @strongify(self);
        if (self.isOk == NO) {
            return @"";
        }
        return [value boolValue] ? @"" : @"请设置6~16位密码(数组+字母组合)";
    }];
    // 通过信号道返回的值，设置文本颜色
    RAC(self.passwordTwoError.lineLabel, backgroundColor) = [self.passwordTwoSignal map:^id(id value) {
        @strongify(self);
        if (self.isOk == NO) {
            return MMJF_COLOR_Gray;
        }
        return [value boolValue] ? MMJF_COLOR_Gray : MMJF_COLOR_RED_MINT;
    }];
    // 通过信号道返回的值，设置文本字体颜色
    RAC(self.passwordTwoError.contentLabel, text) = [self.passwordTwoSignal map:^id(id value) {
        @strongify(self);
        if (self.isOk == NO) {
            return @"";
        }
        return [value boolValue] ? @"" : @"两次输入的密码不一致";
    }];
}

//点击
- (void)setUpClick{
    @weakify(self);
    // 创建登陆按钮信号道，并合并用户名和密码信号道
    RACSignal *submitButSignal = [RACSignal combineLatest:@[self.passwordOneSignal,self.passwordTwoSignal] reduce:^id(NSNumber *phoneValue ,NSNumber *codeValue){
        return @([phoneValue boolValue] && [codeValue boolValue]);
    }];
    // 订阅信号
    [submitButSignal subscribeNext:^(id boolValue) {
        @strongify(self);
        if ([boolValue boolValue]) {
            self.submitBut.userInteractionEnabled = YES;
            [self.submitBut setTitleColor:MMJF_COLOR_Yellow forState:UIControlStateNormal];
            [self.submitBut setBackgroundColor:MMJF_COLOR_Black];
        }else {
            self.submitBut.userInteractionEnabled = NO;
            [self.submitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.submitBut setBackgroundColor:MMJF_COLOR_Gray];
        }
    }];
    
    [[self.submitBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
        NSDictionary *dic = @{@"password":self.passwordOne.text,@"password_confirmation":self.passwordTwo.text,@"mobile":self.mobile};
        [self.publicBaseViewModel.forgotCommand execute:dic];
    }];
    
    [self.publicBaseViewModel.forgotCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
#pragma mark--UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.isOk = YES;
}
//设置圆角
- (void)setUpshadow{
    [self.submitBut.layer setRadius:20];
}

//设置输入框
- (void)settextFile{
    self.passwordOne.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordOne.delegate = self;
    self.passwordOne.secureTextEntry = YES;
    self.passwordTwo.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTwo.delegate = self;
    self.passwordTwo.secureTextEntry = YES;
}

- (ClientPublicBaseViewModel *)publicBaseViewModel{
    if (!_publicBaseViewModel) {
        _publicBaseViewModel = [[ClientPublicBaseViewModel alloc]init];
    }
    return _publicBaseViewModel;
}
@end
