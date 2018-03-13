//
//  UserLoginViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/21.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientLoginViewController.h"
#import "LogCardView.h"
#import "ClientRegisteredViewController.h"
#import "ClientBindingPhoneViewController.h"
#import "ClientCodeLogViewController.h"
#import "RetrievePasswordOneViewController.h"
#import "MMJFTabBarViewController.h"
#import "ClientRightDrawerViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ClientUserModel.h"

@interface ClientLoginViewController ()<IIViewDeckControllerDelegate>
/**
 用于处理未安装微信移动到中心
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicLineLayout;
//用于处理未安装微信隐藏
@property (weak, nonatomic) IBOutlet UIButton *wxBut;
/**
 底部视图
 */
@property (weak, nonatomic) IBOutlet UIView *backView;
/**
 模板视图
 */
@property (weak, nonatomic) IBOutlet UIView *templateView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;

/**
 底部按钮视图
 */
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong)LogCardView * card;

@property (nonatomic, copy)NSDictionary *wxDic;
@end

@implementation ClientLoginViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpClick];
    [self setUpdata];
    if (![[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_WechatSession]) {
        self.dynamicLineLayout.priority = 1000;
        self.wxBut.hidden = YES;
    }
    if (MMJF_HEIGHT > 800) {
        self.topLine.constant = 52;
    }
    
}
//设置视图
- (void)setUpUI{
    [self.templateView.layer setShadow:6 opacity:1 color:[UIColor colorWithRed:245.0f/255.0f green:143.0f/255.0f blue:0.0f/255.0f alpha:0.7f] shadowRadius:12 shadowOffset:CGSizeMake(2, 3)];
    
    _card = [[[NSBundle mainBundle]loadNibNamed:@"LogCardView" owner:self options:nil] lastObject];
    
    _card.frame = self.templateView.bounds;
    [self.templateView addSubview:_card];
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

#pragma mark--点击事件
//设置点击事件
- (void)setUpClick{
    @weakify(self);
    //注册点击事件
    [[self.card.registeredBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        ClientRegisteredViewController *VC = [[ClientRegisteredViewController alloc] init];
        VC.isC = YES;
        [self.navigationController pushViewController:VC animated:YES];
    }];
    
    //登录点击事件
    [[self.card.loginBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSDictionary *dic = @{@"mobile":self.card.phoneText.text,@"password":self.card.passWordText.text,@"platform":@"3",@"type":@"1"};
        [self.card.clientLogViewModel.loginCommand execute:dic];
        
    }];
    //忘记密码
    [[self.card.forgotPasswordBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        RetrievePasswordOneViewController *vc = [[RetrievePasswordOneViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    //登录成功回调
    [self.card.clientLogViewModel.loginCommand.executionSignals
     .switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"登录成功%@",x);
         @strongify(self);
        ClientUserModel *user = [ClientUserModel yy_modelWithJSON:x];
        [MMJF_DEFAULTS setObject:user.header_img forKey:self.card.phoneText.text];
        BOOL ret =  [NSKeyedArchiver archiveRootObject:user toFile:MMJF_UserInfoPath];
        if (ret) {
                MMJF_Log(@"归档成功");
            }else{
                MMJF_Log(@"归档失败");
            }
        [self setClientRootView];
         MMJF_Log(@"%@",user.Id);
    }];
    ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
    MMJF_Log(@"%@",user.Id);
    
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

- (void)getUserInfoForPlatform
{
    __weak typeof(self)weakSelf = self;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        MMJF_Log(@" uid: %@", resp.unionId);
        if (resp.unionId.length == 0) {
            return;
        }
        NSDictionary *dic = @{@"platform":@"3",@"user_type":@"1",@"type":@"wehcat",@"header_img":resp.iconurl,@"unionid":resp.unionId};
        weakSelf.wxDic = dic;
        NSDictionary *dic1 = @{@"type":@"wehcat",@"unionid":resp.unionId,@"user_type":@"1"};
        [weakSelf.card.clientLogViewModel.setAuthCommand execute:dic1];
    }];
}

//底部三方登录
- (IBAction)otherLogin:(UIButton *)sender {
    if (sender.tag == 0) {
        ClientCodeLogViewController *vc = [[ClientCodeLogViewController alloc]init];
        vc.isC = YES;
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
