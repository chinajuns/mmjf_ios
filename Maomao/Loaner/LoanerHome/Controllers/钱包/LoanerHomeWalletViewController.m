//
//  LoanerHomeWalletViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerHomeWalletViewController.h"
#import "LoanerHomeBillingDetailsViewController.h"
#import "LoanerHomeTopUpViewController.h"
#import "LoanerWithdrawaViewController.h"

@interface LoanerHomeWalletViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation LoanerHomeWalletViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    [self setUpNavigation];
}

- (void)setUpNavigation{
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:[UIImage imageNamed:@"zhang-dan-ming-xi"] forState:UIControlStateNormal];
    [right setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    right.frame = CGRectMake(0, 0, 50, 44);
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem= rightItem;
    __weak typeof(self)weakSelf = self;
    //打开右抽屉
    [[right rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        LoanerHomeBillingDetailsViewController *vc = [[LoanerHomeBillingDetailsViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}
//提现 充值
- (IBAction)clickBut:(UIButton *)sender {
    if (sender.tag == 0) {
        LoanerWithdrawaViewController *vc = [[LoanerWithdrawaViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LoanerHomeTopUpViewController *vc = [[LoanerHomeTopUpViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
