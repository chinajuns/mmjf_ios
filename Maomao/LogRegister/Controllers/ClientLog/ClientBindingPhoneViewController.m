//
//  UserBindingPhoneViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientBindingPhoneViewController.h"
#import "ErrorMessageView.h"
#import "ClientPublicBaseViewModel.h"
#import "MMJFTabBarViewController.h"
#import "ClientRightDrawerViewController.h"

@interface ClientBindingPhoneViewController ()<UITextFieldDelegate,IIViewDeckControllerDelegate>
/**
 电话号码
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneText;

/**
 验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *codeText;

/**
 提交按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *submitBut;
/**
 验证码按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *codeBut;
@property (nonatomic, strong)ErrorMessageView *phoneError;
@property (nonatomic, strong)ErrorMessageView *codeError;

@property (nonatomic, strong)ClientPublicBaseViewModel *publicBaseViewModel;

@property (nonatomic, strong)RACSignal *phoneSignal;
@property (nonatomic, strong)RACSignal *codeSignal;
@property (nonatomic, assign)BOOL isOk;
@property (nonatomic, strong)RACDisposable *dispoable;
@property (nonatomic, assign)NSInteger time;
/**
 判断是否刚进入
 */
@property (nonatomic, assign)BOOL isOnly;
@end

@implementation ClientBindingPhoneViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = YES;
}
//视图加载完成
//由于需要加载正确的frame错误提示view在此加载
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.view addSubview:_phoneError];
    [self.view addSubview:_codeError];
    if (_isOnly == NO) {
        [self.view addSubview:_phoneError];
        [self.view addSubview:_codeError];
        [self setUpRAC];
    }
}
//需要获取正确的frame在这里获取
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _phoneError = [[ErrorMessageView alloc]initWithFrame:self.phoneText.frame];
    _codeError = [[ErrorMessageView alloc]initWithFrame:self.codeText.frame];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机号";
    [self setUpshadow];
}

//设置RAC
- (void)setUpRAC{
    @weakify(self);
    // 创建用户名信号道
    self.phoneSignal = [self.phoneText.rac_textSignal map:^id(NSString *value) {
        @strongify(self);
        if (value.length > 10) {
            self.isOk = YES;
        }else if (value.length == 0){
            self.isOk = NO;
        }
        return @([CManager validateMobile:value]);
    }];
    //创建验证码信道
    self.codeSignal = [self.codeText.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        @strongify(self);
        if (value.length == 0) {
            self.isOk = NO;
        }
        return @(value.length);
    }];
    //获取值
    [self setUpRACvalue];
    //设置点击状态
    [self setUpClick];
}
//设置参数
- (void)setUpRACvalue{
    @weakify(self);
    // 通过信号道返回的值，设置按钮点击状态
    RAC(self.codeBut, enabled) = [self.phoneSignal map:^id(id value) {
        @strongify(self);
        if ([value boolValue]) {
            [self.codeBut setTitleColor:MMJF_COLOR_Yellow forState:UIControlStateNormal];
        }else{
            [self.codeBut setTitleColor:MMJF_COLOR_Black forState:UIControlStateNormal];
        }
        return @([value boolValue]);
    }];
    // 通过信号道返回的值，设置按钮点击状态
    RAC(self.codeBut, backgroundColor) = [self.phoneSignal map:^id(id value) {
        return [value boolValue] ? MMJF_COLOR_Black : MMJF_COLOR_Gray;
    }];
    // 通过信号道返回的值，设置文本颜色
    RAC(self.phoneError.lineLabel, backgroundColor) = [self.phoneSignal map:^id(id value) {
        @strongify(self);
        if (self.isOk == NO) {
            return MMJF_COLOR_Gray;
        }
        return [value boolValue] ? MMJF_COLOR_Gray : MMJF_COLOR_RED_MINT;
    }];
    // 通过信号道返回的值，设置文本字体颜色
    RAC(self.phoneError.contentLabel, text) = [self.phoneSignal map:^id(id value) {
        @strongify(self);
        if (self.isOk == NO) {
            return @"";
        }
        return [value boolValue] ? @"" : @"请输入0~9的纯数字手机号";
    }];
    // 通过信号道返回的值，设置文本颜色
    RAC(self.codeError.lineLabel, backgroundColor) = [self.codeSignal map:^id(id value) {
        @strongify(self);
        if (self.isOk == NO) {
            return MMJF_COLOR_Gray;
        }
        return [value boolValue] ? MMJF_COLOR_Gray : MMJF_COLOR_RED_MINT;
    }];
    // 通过信号道返回的值，设置文本字体颜色
    RAC(self.codeError.contentLabel, text) = [self.codeSignal map:^id(id value) {
        @strongify(self);
        if (self.isOk == NO) {
            return @"";
        }
        return [value boolValue] ? @"" : @"请输入正确的验证码";
    }];
}
//点击
- (void)setUpClick{
    @weakify(self);
    // 创建登陆按钮信号道，并合并用户名和密码信号道
    RACSignal *submitButSignal = [RACSignal combineLatest:@[_phoneSignal,_codeSignal] reduce:^id(NSNumber *phoneValue ,NSNumber *codeValue){
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
    //下一步提交
    [[self.submitBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSDictionary *dic = @{@"mobile":self.phoneText.text,@"code":self.codeText.text};
        [self.publicBaseViewModel.checkCodeCommand execute:dic];
    }];
    
    [self.publicBaseViewModel.checkCodeCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         @strongify(self);
         NSMutableDictionary *mut = [NSMutableDictionary dictionary];
         NSDictionary *dic = @{@"mobile":self.phoneText.text};
         [mut addEntriesFromDictionary:dic];
         [mut addEntriesFromDictionary:self.wxDic];
         [self.publicBaseViewModel.setOauthBindCommand execute:mut.copy];
     }];
    //绑定手机
    [self.publicBaseViewModel.setOauthBindCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        ClientUserModel *user = [ClientUserModel yy_modelWithJSON:x];
        [MMJF_DEFAULTS setObject:user.header_img forKey:self.phoneText.text];
        BOOL ret =  [NSKeyedArchiver archiveRootObject:user toFile:MMJF_UserInfoPath];
        if (ret) {
            MMJF_Log(@"归档成功");
        }else{
            MMJF_Log(@"归档失败");
        }
        [self setClientRootView];
    }];
    
    //获取验证码
    [[self.codeBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.isOnly = YES;
        [self.view endEditing:YES];
        self.phoneText.enabled = NO;
        NSDictionary *dic = @{@"mobile":self.phoneText.text,@"type":@"register"};
        [self.publicBaseViewModel.getCodeCommand execute:dic];
    }];
    
    //获取验证码成功的回调
    [self.publicBaseViewModel.getCodeCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.codeBut.enabled = false;
        self.time = 120;
        [self.codeBut setTitle:@"120秒后重试" forState:UIControlStateNormal];
        [self.codeBut setTitleColor:MMJF_COLOR_Black forState:UIControlStateNormal];
        [self.codeBut setBackgroundColor:MMJF_COLOR_Gray];
        @weakify(self);
        //这个就是RAC中的GCD
        self.dispoable = [[RACSignal interval:1.0 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSDate * _Nullable x) {
            @strongify(self);
            self.time --;
            NSString * title = self.time > 0 ? [NSString stringWithFormat:@"%ld秒后重试",_time] : @"重新获取";
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
    
}

//设置C端根视图
- (void)setClientRootView{
    if (MMJF_ShareV.isCustomer == YES) {//是客户端退出
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        MMJFTabBarViewController *tab = [[MMJFTabBarViewController alloc]init];
        ClientRightDrawerViewController *rightVC = [[ClientRightDrawerViewController alloc]init];
        IIViewDeckController *viewDeckController =[[IIViewDeckController alloc]initWithCenterViewController:tab leftViewController:nil rightViewController:rightVC];
        //标记为C端
        MMJF_ShareV.isCustomer = YES;
        viewDeckController.delegate = self;
        viewDeckController.panningEnabled = NO;
        [UIApplication sharedApplication].keyWindow.rootViewController = viewDeckController;
    }
}

//设置圆角
- (void)setUpshadow{
    [self.submitBut.layer setRadius:20];
    [self.codeBut.layer setRadius:5];
    self.phoneText.keyboardType = UIKeyboardTypePhonePad;
    self.phoneText.delegate = self;
    self.codeText.keyboardType = UIKeyboardTypePhonePad;
    self.codeText.delegate = self;
}

#pragma mark--getter
- (ClientPublicBaseViewModel *)publicBaseViewModel{
    if (!_publicBaseViewModel) {
        _publicBaseViewModel = [[ClientPublicBaseViewModel alloc]init];
    }
    return _publicBaseViewModel;
}
@end
