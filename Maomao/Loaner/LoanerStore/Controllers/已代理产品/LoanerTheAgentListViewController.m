//
//  LoanerTheAgentListViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerTheAgentListViewController.h"
#import "LoanerTheAgentListViewModel.h"
#import "LoanerTheAgentDetailViewController.h"

@interface LoanerTheAgentListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listTab;
@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;
@property (nonatomic, strong)LoanerTheAgentListViewModel *theAgentViewModel;
@property (nonatomic, copy)NSDictionary *dict;
@end

@implementation LoanerTheAgentListViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.theAgentViewModel loading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已代理产品";
    [self setUpTheAgentViewModel];
}

- (void)setUpTheAgentViewModel{
    [self.theAgentViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    [self.theAgentViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        NSDictionary *dic = [weakSelf.theAgentViewModel getListDic];
        NSString *str = [NSString stringWithFormat:@"%@",x];
        if (str.length == 0) {
            weakSelf.dict = dic;
            [weakSelf lackIntegral];
        }else{
            LoanerTheAgentDetailViewController *vc = [[LoanerTheAgentDetailViewController alloc]init];
            vc.dict = dic;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    }];
}
//积分不足提示
- (void)lackIntegral{
    TYAlertController *alertController = [self.podStyleViewModel setUpShareTwo:@"确定取消代理该产品" determineStr:@"确定" cancelStr:@"取消" ];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (LoanerTheAgentListViewModel *)theAgentViewModel{
    if (!_theAgentViewModel) {
        _theAgentViewModel = [[LoanerTheAgentListViewModel alloc]init];
    }
    return _theAgentViewModel;
}

- (SharePodStyleViewModel *)podStyleViewModel{
    if (!_podStyleViewModel) {
        _podStyleViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        //点击
        [_podStyleViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            [weakSelf.theAgentViewModel.netWorkViewModel.setAgentCommand execute:weakSelf.dict];
        }];
    }
    return _podStyleViewModel;
}
@end
