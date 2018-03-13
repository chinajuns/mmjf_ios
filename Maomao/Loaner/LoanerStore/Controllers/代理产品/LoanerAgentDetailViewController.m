//
//  LoanerAgentDetailViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerAgentDetailViewController.h"
#import "LoanerAgentDetailViewModel.h"

@interface LoanerAgentDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (weak, nonatomic) IBOutlet UIButton *clickBut;
@property (nonatomic, strong)LoanerAgentDetailViewModel *detailViewModel;
@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;

@property (nonatomic, assign)BOOL isOK;
@end

@implementation LoanerAgentDetailViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"代理产品详情";
    [self setUpDetailViewModel];
}

//代理按钮
- (IBAction)agentBut:(UIButton *)sender {
    if (self.isOK == YES) {
        [self lackIntegral];
    }else{
        [self.detailViewModel.netWorkViewModel.setAgentCommand execute:self.dict];
    }
}

- (void)setUpDetailViewModel{
    [self.detailViewModel bindViewToViewModel:self.listTab];
    [self.detailViewModel.netWorkViewModel.detailCommand execute:self.dict];
    __weak typeof(self)weakSelf = self;
    [self.detailViewModel.netWorkViewModel.setAgentCommand.executionSignals
     .switchToLatest subscribeNext:^(id  _Nullable x) {
         if (weakSelf.isOK == YES) {
             [MBProgressHUD showError:@"取消代理成功"];
             weakSelf.isOK = NO;
             [weakSelf.clickBut setTitle:@"我要代理" forState:UIControlStateNormal];
             weakSelf.clickBut.backgroundColor = MMJF_COLOR_Yellow;
         }else{
             [MBProgressHUD showError:@"代理成功"];
             weakSelf.isOK = YES;
             [weakSelf.clickBut setTitle:@"取消代理" forState:UIControlStateNormal];
             weakSelf.clickBut.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
         }
    }];
}

//积分不足提示
- (void)lackIntegral{
    TYAlertController *alertController = [self.podStyleViewModel setUpShareTwo:@"确定取消代理该产品" determineStr:@"确定" cancelStr:@"取消" ];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (LoanerAgentDetailViewModel *)detailViewModel{
    if (!_detailViewModel) {
        _detailViewModel = [[LoanerAgentDetailViewModel alloc]init];
    }
    return _detailViewModel;
}



- (SharePodStyleViewModel *)podStyleViewModel{
    if (!_podStyleViewModel) {
        _podStyleViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        //点击
        [_podStyleViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            NSDictionary *dic1 = @{@"id":weakSelf.dict[@"id"],@"action":@"cancel"};
            [weakSelf.detailViewModel.netWorkViewModel.setAgentCommand execute:dic1];
        }];
    }
    return _podStyleViewModel;
}
@end
