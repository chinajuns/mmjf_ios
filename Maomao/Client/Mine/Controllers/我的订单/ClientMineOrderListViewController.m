//
//  ClientMineOrderListViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineOrderListViewController.h"
#import "ClientMineOrderListViewModel.h"
#import "ClientMineOrderEvaluationViewController.h"
#import "ClientMineOrderDetailsViewController.h"

@interface ClientMineOrderListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *orderListTab;

@property (nonatomic, strong)ClientMineOrderListViewModel *orderListViewModel;
@end

@implementation ClientMineOrderListViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.orderListViewModel sliding:self.number];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderListTab.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    [self setUpOrderList];
}

- (void)setUpOrderList{
    [self.orderListViewModel bindViewToViewModel:self.orderListTab];
    __weak typeof(self)weakSelf = self;
    //跳转评价
    [weakSelf.orderListViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        ClientMineOrderEvaluationViewController *vc = [[ClientMineOrderEvaluationViewController alloc]init];
        vc.orderId = x[@"id"];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [weakSelf.orderListViewModel.detailsSubject subscribeNext:^(id  _Nullable x) {
        ClientMineOrderDetailsViewController *vc = [[ClientMineOrderDetailsViewController alloc]init];
        vc.dict = x;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (ClientMineOrderListViewModel *)orderListViewModel{
    if (!_orderListViewModel) {
        _orderListViewModel = [[ClientMineOrderListViewModel alloc]init];
    }
    return _orderListViewModel;
}

@end
