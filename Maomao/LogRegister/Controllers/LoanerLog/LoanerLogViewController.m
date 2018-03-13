//
//  LoanerLogViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/23.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerLogViewController.h"
#import "LogCardView.h"
#import "ClientRegisteredViewController.h"
#import "CYTabBarController.h"
#import "ClientCodeLogViewController.h"
#import "ClientBindingPhoneViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "RetrievePasswordOneViewController.h"

@interface LoanerLogViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;

@property (weak, nonatomic) IBOutlet UIButton *wxBUt;
@property (nonatomic, strong)LogCardView * card;
@property (nonatomic, copy)NSDictionary *wxDic;
@end

@implementation LoanerLogViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpdata];
    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        self.line.priority = 1000;
        self.wxBUt.hidden = YES;
    }
    if (MMJF_HEIGHT > 800) {
        self.topLine.constant = 52;
    }
}
//设置UI
- (void)setUpUI{
    [self.backView.layer setShadow:6 opacity:1 color:[UIColor colorWithRed:245.0f/255.0f green:143.0f/255.0f blue:0.0f/255.0f alpha:0.7f] shadowRadius:12 shadowOffset:CGSizeMake(2, 3)];
    self.card = [[[NSBundle mainBundle]loadNibNamed:@"LogCardView" owner:self options:nil] lastObject];
    self.card.frame = self.backView.bounds;
    [self.backView addSubview:self.card];
    __weak typeof(self)weakSelf = self;
    //注册点击事件
    [[self.card.registeredBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        ClientRegisteredViewController *vc = [[ClientRegisteredViewController alloc]init];
        vc.isC = NO;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    __weak typeof(self.card)weakCard = self.card;
    //忘记密码
    [[self.card.forgotPasswordBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        RetrievePasswordOneViewController *vc = [[RetrievePasswordOneViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    //登录点击事件
    [[self.card.loginBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSDictionary *dic = @{@"mobile":weakCard.phoneText.text,@"password":weakCard.passWordText.text,@"platform":@"3",@"type":@"2"};
        [weakCard.clientLogViewModel.loginCommand execute:dic];
    }];
    //登录成功回调
    [weakCard.clientLogViewModel.loginCommand.executionSignals
     .switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"登录成功%@",x);
         ClientUserModel *user = [ClientUserModel yy_modelWithJSON:x];
         [MMJF_DEFAULTS setObject:user.header_img forKey:weakCard.phoneText.text];
         BOOL ret =  [NSKeyedArchiver archiveRootObject:user toFile:MMJF_UserInfoPath];
         if (ret) {
             MMJF_Log(@"归档成功");
         }else{
             MMJF_Log(@"归档失败");
         }
         [weakSelf setClientRootView];
     }];
    ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
    MMJF_Log(@"%@",user.mobile);
}

//设置绑定数据
- (void)setUpdata{
    __weak typeof(self)weakSelf = self;
    //第三方绑定检查：如果已经绑定：直接返回用户信息
    [self.card.clientLogViewModel.setAuthCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        //已绑定
        if ([x isKindOfClass:[NSDictionary class]]) {
            ClientUserModel *user = [ClientUserModel yy_modelWithJSON:x];
            [MMJF_DEFAULTS setObject:user.header_img forKey:weakSelf.card.phoneText.text];
            BOOL ret =  [NSKeyedArchiver archiveRootObject:user toFile:MMJF_UserInfoPath];
            if (ret) {
                MMJF_Log(@"归档成功");
            }else{
                MMJF_Log(@"归档失败");
            }
            [weakSelf setClientRootView];
        }else{
            NSString *str = [NSString stringWithFormat:@"%@",x];
            if ([str isEqualToString:@"5000"]) {
                ClientBindingPhoneViewController *VC = [[ClientBindingPhoneViewController alloc]init];
                VC.wxDic = weakSelf.wxDic;
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }
        }
    }];
}
//设置B端根视图
- (void)setClientRootView{
    if (MMJF_ShareV.isCustomer == NO) {//是B端退出
        //标记为B端
        MMJF_ShareV.isCustomer = NO;
        CYTabBarController * tabbar = [[CYTabBarController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
    }else{
        [self dismissViewControllerAnimated:NO completion:^{
            //标记为B端
            MMJF_ShareV.isCustomer = NO;
            CYTabBarController * tabbar = [[CYTabBarController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabbar;
        }];
        
    }
}
- (void)getUserInfoForPlatform
{
    __weak typeof(self.card)weakCard = self.card;
    __weak typeof(self)weakSelf = self;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        MMJF_Log(@" uid: %@", resp.unionId);
        if (resp.unionId.length == 0) {
            return;
        }
        NSDictionary *dic = @{@"platform":@"3",@"user_type":@"2",@"type":@"wehcat",@"header_img":resp.iconurl,@"unionid":resp.unionId};
        weakSelf.wxDic = dic;
        NSDictionary *dic1 = @{@"type":@"wehcat",@"unionid":resp.unionId,@"user_type":@"2"};
        [weakCard.clientLogViewModel.setAuthCommand execute:dic1];
    }];
}

//底部按钮
- (IBAction)bottomBut:(UIButton *)sender {
    if (sender.tag == 0) {
        ClientCodeLogViewController *vc = [[ClientCodeLogViewController alloc]init];
        vc.isC = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self getUserInfoForPlatform];
    }
}

//返回
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
