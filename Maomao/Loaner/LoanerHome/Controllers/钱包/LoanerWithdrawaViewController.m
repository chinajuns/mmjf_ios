//
//  LoanerWithdrawaViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerWithdrawaViewController.h"
#import "LoanerWithdrawaViewModel.h"
#import "LoanerWithdrawalSuccessViewController.h"

@interface LoanerWithdrawaViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic, strong)LoanerWithdrawaViewModel *withdrawaViewModel;
@end

@implementation LoanerWithdrawaViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要提现";
    [self serUpdrawaViewModel];
}

- (void)serUpdrawaViewModel{
    [self.withdrawaViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    [self.withdrawaViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        LoanerWithdrawalSuccessViewController *vc = [[LoanerWithdrawalSuccessViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (LoanerWithdrawaViewModel *)withdrawaViewModel{
    if (!_withdrawaViewModel) {
        _withdrawaViewModel = [[LoanerWithdrawaViewModel alloc]init];
    }
    return _withdrawaViewModel;
}

@end
