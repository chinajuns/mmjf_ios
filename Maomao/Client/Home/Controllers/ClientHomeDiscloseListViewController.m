//
//  ClientHomeDiscloseListViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeDiscloseListViewController.h"
#import "ClientDisclpseListViewModel.h"
#import "ClientHomeViewModel.h"

@interface ClientHomeDiscloseListViewController ()
@property (nonatomic, strong)ClientDisclpseListViewModel *disclpseListViewModel;
@property (weak, nonatomic) IBOutlet UITableView *discloseTab;

@property (nonatomic, strong)ClientHomeViewModel *netWorkViewModel;
@end

@implementation ClientHomeDiscloseListViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提交成功";
    [self setUpData];
    [self setUpDisclpseListModel];
}
//设置列表
- (void)setUpDisclpseListModel{
    [self.disclpseListViewModel setUpData:self.model];
    [self.disclpseListViewModel bindViewToViewModel:self.discloseTab];
}
//底部按钮
- (IBAction)bottomBut:(UIButton *)sender {
    if (sender.tag == 0) {//完成
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{//立即申请
        NSString *str = [self.disclpseListViewModel getData];
        if (str.length == 0) {
            [MBProgressHUD showError:@"请选择信贷经理"];
            return;
        }
        NSDictionary *dic = @{@"id":self.model.Id,@"ids":str};
        [self.netWorkViewModel.quickApplyCommand execute:dic];
    }
}
//获取数据
- (void)setUpData{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.quickApplyCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark--getter

- (ClientDisclpseListViewModel *)disclpseListViewModel{
    if (!_disclpseListViewModel) {
        _disclpseListViewModel = [[ClientDisclpseListViewModel alloc]init];
    }
    return _disclpseListViewModel;
}

- (ClientHomeViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[ClientHomeViewModel alloc]init];
    }
    return _netWorkViewModel;
}
@end
