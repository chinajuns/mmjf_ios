//
//  LogHomeViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/21.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LogHomeViewController.h"
#import "ClientLoginViewController.h"
#import "LoanerLogViewController.h"
#import "MMJFTabBarViewController.h"
#import "ClientRightDrawerViewController.h"

@interface LogHomeViewController ()<IIViewDeckControllerDelegate>
//用户按钮
@property (weak, nonatomic) IBOutlet UIButton *userBut;
///信贷经理按钮
@property (weak, nonatomic) IBOutlet UIButton *creditManagerBut;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (weak, nonatomic) IBOutlet UIButton *backBut;

@end

@implementation LogHomeViewController
//能释放
- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    if (MMJF_HEIGHT > 800) {
        self.line.constant = 52;
    }
    
    
}
//设置UI
- (void)setUpUI{
    self.navigationController.navigationBarHidden = YES;
    [self.userBut.layer setShadow:20 opacity:1 color:[UIColor colorWithRed:245.0f/255.0f green:143.0f/255.0f blue:0.0f/255.0f alpha:0.92f] shadowRadius:6 shadowOffset:CGSizeMake(2, 3)];
    [self.creditManagerBut.layer setShadow:20 opacity:1 color:[UIColor colorWithRed:245.0f/255.0f green:143.0f/255.0f blue:0.0f/255.0f alpha:0.92f] shadowRadius:6 shadowOffset:CGSizeMake(2, 3)];
}

- (IBAction)backBut:(UIButton *)sender {
    if (MMJF_ShareV.isCustomer == NO) {//B
        MMJFTabBarViewController *tab = [[MMJFTabBarViewController alloc]init];
        ClientRightDrawerViewController *rightVC = [[ClientRightDrawerViewController alloc]init];
        IIViewDeckController *viewDeckController =[[IIViewDeckController alloc]initWithCenterViewController:tab leftViewController:nil rightViewController:rightVC];
        //标记为C端
        MMJF_ShareV.isCustomer = YES;
        viewDeckController.delegate = self;
        viewDeckController.panningEnabled = NO;
        [UIApplication sharedApplication].keyWindow.rootViewController = viewDeckController;
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


#pragma mark--按钮点击
- (IBAction)clickOn:(UIButton *)sender {
    if (sender.tag == 0) {//用户登录
        ClientLoginViewController *userVC = [[ClientLoginViewController alloc]init];
        [self.navigationController pushViewController:userVC animated:YES];
    }else{//信贷经理登录
        LoanerLogViewController *VC = [[LoanerLogViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

@end
