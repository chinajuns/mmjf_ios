//
//  LoanerJiltsingleListViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerJiltsingleListViewController.h"
#import "LoanerJiltSingleListViewModel.h"
#import "LoanerJiltsingleDetailViewController.h"

@interface LoanerJiltsingleListViewController ()
@property (nonatomic, strong)LoanerJiltSingleListViewModel *listViewModel;


@property (weak, nonatomic) IBOutlet UITableView *listtab;
@end

@implementation LoanerJiltsingleListViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setUpListViewModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"甩单记录";
    self.listtab.contentInset = UIEdgeInsetsMake(0, 0, 70, 0);
}

- (void)setUpListViewModel{
    self.listViewModel.number = self.number;
    [self.listViewModel bindViewToViewModel:self.listtab];
    __weak typeof(self)weakSelf = self;
    [self.listViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        LoanerJiltsingleDetailViewController *vc = [[LoanerJiltsingleDetailViewController alloc]init];
        vc.ID = x;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}


- (LoanerJiltSingleListViewModel *)listViewModel{
    if (!_listViewModel) {
        _listViewModel = [[LoanerJiltSingleListViewModel alloc]init];
    }
    return _listViewModel;
}


@end
