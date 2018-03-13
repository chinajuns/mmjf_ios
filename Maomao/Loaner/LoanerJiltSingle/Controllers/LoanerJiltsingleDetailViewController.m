//
//  LoanerJiltsingleDetailViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerJiltsingleDetailViewController.h"
#import "LoanerJiltSingleDetailViewModel.h"
#import "LoanerJiltSingleNetWorkViewModel.h"

@interface LoanerJiltsingleDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *detailTab;
@property (nonatomic, strong)LoanerJiltSingleNetWorkViewModel *networkViewModel;
@property (nonatomic, strong)LoanerJiltSingleDetailViewModel *detailViewModel;
@end

@implementation LoanerJiltsingleDetailViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"甩单详情";
    [self setUpdetailViewModel];
    [self setUpNetWork];
}

- (void)setUpdetailViewModel{
    [self.detailViewModel bindViewToViewModel:self.detailTab];
    __weak typeof(self)weakSelf = self;
    [self.detailViewModel.endSubject subscribeNext:^(id  _Nullable x) {
        NSDictionary *dic = @{@"id":weakSelf.ID};
        [weakSelf.networkViewModel.junkDetailCommand execute:dic];
    }];
}

- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    [self.networkViewModel.junkDetailCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        [weakSelf.detailViewModel refresh:x];
    }];
    NSDictionary *dic = @{@"id":self.ID};
    [self.networkViewModel.junkDetailCommand execute:dic];
}


- (LoanerJiltSingleDetailViewModel *)detailViewModel{
    if (!_detailViewModel) {
        _detailViewModel = [[LoanerJiltSingleDetailViewModel alloc]init];
    }
    return _detailViewModel;
}

- (LoanerJiltSingleNetWorkViewModel *)networkViewModel{
    if (!_networkViewModel) {
        _networkViewModel = [[LoanerJiltSingleNetWorkViewModel alloc]init];
    }
    return _networkViewModel;
}
@end
