//
//  ClientMineChangePasswordViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/7.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineChangePasswordViewController.h"
#import "ClientPublicBaseViewModel.h"
#import "LogHomeViewController.h"
#import "MMJFBaseNavigationViewController.h"

@interface ClientMineChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *password1Text;
@property (weak, nonatomic) IBOutlet UITextField *password2Text;
@property (weak, nonatomic) IBOutlet UITextField *password3Text;

@property (weak, nonatomic) IBOutlet UIButton *confirmBut;

@property (nonatomic, strong)RACSignal *PasswoedOldSignal;
@property (nonatomic, strong)RACSignal *passwordOneSignal;
@property (nonatomic, strong)RACSignal *passwordTwoSignal;
@property (nonatomic, assign)BOOL isOk;

@property (nonatomic, strong)ClientPublicBaseViewModel *netWork;
@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;
@end

@implementation ClientMineChangePasswordViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.password1Text.secureTextEntry = self.password2Text.secureTextEntry = self.password3Text.secureTextEntry = YES;
    [self setUpRAC];
}

- (void)setUpRAC{
    __weak typeof(self)weakSelf = self;
    // 旧密码
    self.PasswoedOldSignal = [weakSelf.password1Text.rac_textSignal map:^id(NSString *value) {
        return @([CManager validatePassword:value]);
    }];
    
    // 创建密码一
    self.passwordOneSignal = [weakSelf.password2Text.rac_textSignal map:^id(NSString *value) {
        return @([CManager validatePassword:value]);
    }];
    //密码二
    self.passwordTwoSignal = [weakSelf.password3Text.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @([CManager validatePassword:value]);
    }];
    
    [self.netWork.resetCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        // 创建文件管理对象
        NSFileManager *manager = [NSFileManager defaultManager];
        // 删除
        [manager removeItemAtPath:MMJF_UserInfoPath error:nil];
        TYAlertController *alertController = [weakSelf.podStyleViewModel setUpShareResetView:@"密码修改成功，请重新登录"];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }];
    //设置点击状态
    [self setUpClick];
}

//点击
- (void)setUpClick{
    __weak typeof(self)weakSelf = self;
    // 创建登陆按钮信号道，并合并用户名和密码信号道
    RACSignal *submitButSignal = [RACSignal combineLatest:@[_passwordOneSignal,_passwordTwoSignal,_PasswoedOldSignal] reduce:^id(NSNumber *phoneValue ,NSNumber *codeValue,NSNumber *passwordValue){
        return @([phoneValue boolValue] && [codeValue boolValue] && [passwordValue boolValue]);
    }];
    // 订阅信号
    [submitButSignal subscribeNext:^(id boolValue) {
        if ([boolValue boolValue]) {
            weakSelf.confirmBut.userInteractionEnabled = YES;
            [weakSelf.confirmBut setTitleColor:[UIColor colorWithHexString:@"#1a1a1a"] forState:UIControlStateNormal];
            [weakSelf.confirmBut setBackgroundColor:MMJF_COLOR_Yellow];
        }else {
            weakSelf.confirmBut.userInteractionEnabled = NO;
            [weakSelf.confirmBut setTitleColor:[UIColor colorWithHexString:@"#b3b3b3"] forState:UIControlStateNormal];
            [weakSelf.confirmBut setBackgroundColor:[UIColor colorWithHexString:@"#e6e6e6"]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//确认
- (IBAction)confirmBut:(UIButton *)sender {
    if (![_password2Text.text isEqualToString:_password3Text.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
    }else{
        NSDictionary *dic = @{@"old_password":self.password1Text.text,@"password":self.password2Text.text,@"password_confirmation":self.password3Text.text};
        [self.netWork.resetCommand execute:dic];
    }
    
}

- (ClientPublicBaseViewModel *)netWork{
    if (!_netWork) {
        _netWork = [[ClientPublicBaseViewModel alloc]init];
    }
    return _netWork;
}

- (SharePodStyleViewModel *)podStyleViewModel{
    if (!_podStyleViewModel) {
        _podStyleViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        //点击
        [_podStyleViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            if ([x isEqualToString:@"密码修改成功，请重新登录"]) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                LogHomeViewController *log = [[LogHomeViewController alloc]init];
                MMJFBaseNavigationViewController *nav = [[MMJFBaseNavigationViewController alloc]initWithRootViewController:log];
                MMJF_ShareV.isCustomer = NO;
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
        }];
    }
    return _podStyleViewModel;
}
@end
