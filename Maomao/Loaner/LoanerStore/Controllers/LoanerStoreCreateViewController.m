//
//  LoanerStoreCreateViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreCreateViewController.h"
#import "LoanerStoreCreateViewModel.h"
#import "LoanerStoreDetailViewController.h"
#import "LoanerStoreNetWorkViewModel.h"

@interface LoanerStoreCreateViewController ()

@property (weak, nonatomic) IBOutlet UITableView *listTab;
@property (nonatomic, strong)LoanerStoreCreateViewModel *createViewModel;

@property (nonatomic, strong)LoanerStoreNetWorkViewModel *netWorkViewModel;
@end

@implementation LoanerStoreCreateViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建信贷经理店铺";
    [self setUpCreateViewModel];
    [self setUpNetWork];
}
//设置viewModel
- (void)setUpCreateViewModel{
    [self.createViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    [self.createViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        [weakSelf.netWorkViewModel.shopShowCreateCommand execute:[weakSelf.createViewModel getData]];
    }];
}
//设置网络请求
- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.showCreateCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@12312",x);
        LoanerShowCreateModel *model = [LoanerShowCreateModel yy_modelWithJSON:x];
        weakSelf.createViewModel.model = model;
        [weakSelf.createViewModel refresh];
    }];
    [self.netWorkViewModel.showCreateCommand execute:nil];
    [self.netWorkViewModel.shopShowCreateCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        MMJF_Log(@"%@",x);
        LoanerStoreDetailViewController *vc = [[LoanerStoreDetailViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
}

- (LoanerStoreCreateViewModel *)createViewModel{
    if (!_createViewModel) {
        _createViewModel = [[LoanerStoreCreateViewModel alloc]init];
    }
    return _createViewModel;
}

- (LoanerStoreNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerStoreNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
}

@end
