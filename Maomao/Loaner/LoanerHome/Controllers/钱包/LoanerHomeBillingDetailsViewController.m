//
//  LoanerHomeBillingDetailsViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerHomeBillingDetailsViewController.h"
#import "LoanerHomeBillingDetailsListViewModel.h"
#import "LoanerHomeBillDetailViewController.h"

@interface LoanerHomeBillingDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic, strong)LoanerHomeBillingDetailsListViewModel *billListViewModel;
@end

@implementation LoanerHomeBillingDetailsViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单明细";
    [self setUpBillViewModel];
}

- (void)setUpBillViewModel{
    [self.billListViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    //跳转详情
    [self.billListViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        LoanerHomeBillDetailViewController *vc = [[LoanerHomeBillDetailViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (LoanerHomeBillingDetailsListViewModel *)billListViewModel{
    if (!_billListViewModel) {
        _billListViewModel = [[LoanerHomeBillingDetailsListViewModel alloc]init];
    }
    return _billListViewModel;
}

@end
