//
//  LoanerTheAgentDetailViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerTheAgentDetailViewController.h"
#import "LoanerAgentDetailViewModel.h"

@interface LoanerTheAgentDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listTab;
@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;
@property (nonatomic, strong)LoanerAgentDetailViewModel *agentDetailViewModel;
@end

@implementation LoanerTheAgentDetailViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已代理产品详情";
    [self setUpDetailViewModel];
}
//取消代理
- (IBAction)cancelBUt:(UIButton *)sender {
    [self lackIntegral];
}

//积分不足提示
- (void)lackIntegral{
    TYAlertController *alertController = [self.podStyleViewModel setUpShareTwo:@"确定取消代理该产品" determineStr:@"确定" cancelStr:@"取消" ];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)setUpDetailViewModel{
    [self.agentDetailViewModel bindViewToViewModel:self.listTab];
    [self.agentDetailViewModel.netWorkViewModel.detailCommand execute:self.dict];
    __weak typeof(self)weakSelf = self;
    [self.agentDetailViewModel.netWorkViewModel.setAgentCommand.
     executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [MBProgressHUD showError:@"取消代理成功"];
         [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (LoanerAgentDetailViewModel *)agentDetailViewModel{
    if (!_agentDetailViewModel) {
        _agentDetailViewModel = [[LoanerAgentDetailViewModel alloc]init];
    }
    return _agentDetailViewModel;
}

- (SharePodStyleViewModel *)podStyleViewModel{
    if (!_podStyleViewModel) {
        _podStyleViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        //点击
        [_podStyleViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            [weakSelf.agentDetailViewModel.netWorkViewModel.setAgentCommand execute:weakSelf.dict];
        }];
    }
    return _podStyleViewModel;
}

@end
