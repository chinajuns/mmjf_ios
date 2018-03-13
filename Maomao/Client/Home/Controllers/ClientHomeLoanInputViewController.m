//
//  ClientHomeLoanInputViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/29.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeLoanInputViewController.h"
#import "ClientHomeLoanInputViewModel.h"
#import "ClientHomeDiscloseListViewController.h"

@interface ClientHomeLoanInputViewController ()

@property (weak, nonatomic) IBOutlet UITableView *loanInputTab;

/**
 输入
 */
@property (nonatomic, strong)ClientHomeLoanInputViewModel *loanInputViewModel;


@end

@implementation ClientHomeLoanInputViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要贷款";
    [self setupLoanInputViewModel];
    
}
//设置输入viewModel
- (void)setupLoanInputViewModel{
    self.loanInputViewModel.loaner_id = self.loaner_id;
    self.loanInputViewModel.product_id = self.product_id;
    [self.loanInputViewModel bindViewToViewModel:self.loanInputTab];
    __weak typeof(self)weakSelf = self;
    [weakSelf.loanInputViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        [MBProgressHUD showSuccess:@"申请成功"];
        ClientHomeDiscloseListViewController *vc = [[ClientHomeDiscloseListViewController alloc]init];
        ClientQuickApplyModel *model = [ClientQuickApplyModel yy_modelWithJSON:x];
        vc.model = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.loanInputViewModel.clientConfigCommand execute:nil];
}

#pragma mark--getter
- (ClientHomeLoanInputViewModel *)loanInputViewModel{
    if (!_loanInputViewModel) {
        _loanInputViewModel = [[ClientHomeLoanInputViewModel alloc]init];
    }
    return _loanInputViewModel;
}




@end
