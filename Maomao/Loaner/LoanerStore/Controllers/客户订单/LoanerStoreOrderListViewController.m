//
//  LoanerStoreOrderListViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreOrderListViewController.h"
#import "LoanerStoreOrderListViewModel.h"
#import "LoanerStoreOrderDetaillViewController.h"
#import "LoanerStoreEvaluationViewController.h"


@interface LoanerStoreOrderListViewController ()
@property (nonatomic, strong)LoanerStoreOrderListViewModel *orderListViewModel;

@property (weak, nonatomic) IBOutlet UITableView *listTab;
@end

@implementation LoanerStoreOrderListViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setUpOrderListViewModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.listTab.contentSize = CGSizeMake(MMJF_WIDTH, MMJF_HEIGHT);
    self.listTab.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
}

- (void)setUpOrderListViewModel{
    self.orderListViewModel.number = self.number;
    self.orderListViewModel.isRefer = self.isRefer;
    [self.orderListViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    //跳转详情
    [self.orderListViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        LoanerStoreOrderDetaillViewController *vc = [[LoanerStoreOrderDetaillViewController alloc]init];
        MMJF_Log(@"%@",x[@"id"]);
        vc.Id = [NSString stringWithFormat:@"%@",x[@"id"]];
        vc.isRefer = weakSelf.isRefer;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    //跳转评价
    [self.orderListViewModel.butClickSubject subscribeNext:^(id  _Nullable x) {
        LoanerStoreEvaluationViewController *vc = [[LoanerStoreEvaluationViewController alloc]init];
        MMJF_Log(@"%@",x[@"id"]);
        vc.Id = [NSString stringWithFormat:@"%@",x[@"id"]];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}


- (LoanerStoreOrderListViewModel *)orderListViewModel{
    if (!_orderListViewModel) {
        _orderListViewModel = [[LoanerStoreOrderListViewModel alloc]init];
    }
    return _orderListViewModel;
}


@end
