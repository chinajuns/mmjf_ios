//
//  ClientCodeLogViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/23.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientCodeLogViewController.h"
#import "CodeLogCardView.h"
#import "ClientLogCardViewModel.h"
#import "MMJFTabBarViewController.h"
#import "ClientRightDrawerViewController.h"
#import "CYTabBarController.h"
#import "ClientMineWebPageViewController.h"

@interface ClientCodeLogViewController ()<IIViewDeckControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) CodeLogCardView * card;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;
@property (nonatomic, strong)ClientLogCardViewModel *loanViewModel;
@end

@implementation ClientCodeLogViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    //rac点击事件
    [self setUpClick];
    if (MMJF_HEIGHT > 800) {
        self.topLine.constant = 52;
    }
}

//设置UI
- (void)setUpUI{
    [self.backView.layer setShadow:6 opacity:1 color:[UIColor colorWithRed:245.0f/255.0f green:143.0f/255.0f blue:0.0f/255.0f alpha:0.7f] shadowRadius:12 shadowOffset:CGSizeMake(2, 3)];
    _card = [[[NSBundle mainBundle]loadNibNamed:@"CodeLogCardView" owner:self options:nil] lastObject];
    _card.frame = self.backView.bounds;
    [self.backView addSubview:_card];
}
//点击事件
- (void)setUpClick{
    __weak typeof(self)weakSelf = self;
    //登录
    [[weakSelf.card.loginBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSString *type;
        if (weakSelf.isC == YES) {
            type = @"1";
        }else{
            type = @"2";
        }
        NSDictionary *dic = @{@"mobile":weakSelf.card.phoneText.text,@"platform":@"3",@"type":type,@"code":weakSelf.card.passWordText.text,@"login_way":@"verify_code"};
        [weakSelf.loanViewModel.loginCommand execute:dic];
    }];
    //点击协议
    [[self.card.serviceAgreement rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        ClientMineWebPageViewController *vc = [[ClientMineWebPageViewController alloc]init];
        vc.number = 2;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    [weakSelf.loanViewModel.loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"登录成功%@",x);
        ClientUserModel *user = [ClientUserModel yy_modelWithJSON:x];
        [MMJF_DEFAULTS setObject:user.header_img forKey:weakSelf.card.phoneText.text];
        BOOL ret =  [NSKeyedArchiver archiveRootObject:user toFile:MMJF_UserInfoPath];
        if (ret) {
            MMJF_Log(@"归档成功");
        }else{
            MMJF_Log(@"归档失败");
        }
        [weakSelf setClientRootView];
    }];
    
}

//返回按钮
- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//设置C端根视图
- (void)setClientRootView{
    if (self.isC == YES) {
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
    }else{
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
}

- (ClientLogCardViewModel *)loanViewModel{
    if (!_loanViewModel) {
        _loanViewModel = [[ClientLogCardViewModel alloc]init];
    }
    return _loanViewModel;
}
@end
