//
//  ClientInfomationMoreListViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientInfomationMoreListViewController.h"
#import "ClientInfomationMoreListViewModel.h"
#import "ClientInformationDetailsViewController.h"

@interface ClientInfomationMoreListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *moreListTab;
@property (nonatomic, strong)ClientInfomationMoreListViewModel *moreListViewModel;

@end

@implementation ClientInfomationMoreListViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
    [self.moreListViewModel refresh];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleStr;
    [self setUpMoreListViewModel];
}
//设置数据
- (void)setUpMoreListViewModel{
    [self.moreListViewModel setUpData:self.Id];
    [self.moreListViewModel bindViewToViewModel:self.moreListTab];
    __weak typeof(self)weakSelf = self;
    [self.moreListViewModel.listSubject subscribeNext:^(id  _Nullable x) {
        ClientInformationDetailsViewController *vc = [[ClientInformationDetailsViewController alloc]init];
        vc.model = x;
        vc.isB = weakSelf.isB;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}


- (ClientInfomationMoreListViewModel *)moreListViewModel{
    if (!_moreListViewModel) {
        _moreListViewModel = [[ClientInfomationMoreListViewModel alloc]init];
    }
    return _moreListViewModel;
}


@end
