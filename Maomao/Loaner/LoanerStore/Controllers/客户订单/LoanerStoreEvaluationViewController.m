//
//  LoanerStoreEvaluationViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreEvaluationViewController.h"
#import "LoanerStoreEvaluationViewModel.h"
#import "LoanerStoreNetWorkViewModel.h"

@interface LoanerStoreEvaluationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic, strong)LoanerStoreNetWorkViewModel *networkViewModel;
@property (nonatomic, strong)LoanerStoreEvaluationViewModel *evaluationViewMoeel;
@end

@implementation LoanerStoreEvaluationViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    [self setUpEvaluationViewModel];
    [self setUpNetWork];
}

- (void)setUpEvaluationViewModel{
    [self.evaluationViewMoeel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    [self.evaluationViewMoeel.orderCommentSubject subscribeNext:^(id  _Nullable x) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic addEntriesFromDictionary:x];
        [dic setObject:weakSelf.Id forKey:@"id"];
        [weakSelf.networkViewModel.orderCommentCommand execute:dic];
    }];
}

- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    //B端：店铺-客户订单-评价界面用户印象
    [self.networkViewModel.orderCommentLabelCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"%@",x);
         
         [weakSelf.evaluationViewMoeel refreshTag:x];
    }];
    [self.networkViewModel.orderCommentLabelCommand execute:nil];
    //B端：店铺-客户订单-评价提交
    [self.networkViewModel.orderCommentCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"%@",x);
         [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (LoanerStoreEvaluationViewModel *)evaluationViewMoeel{
    if (!_evaluationViewMoeel) {
        _evaluationViewMoeel = [[LoanerStoreEvaluationViewModel alloc]init];
    }
    return _evaluationViewMoeel;
}

- (LoanerStoreNetWorkViewModel *)networkViewModel{
    if (!_networkViewModel) {
        _networkViewModel = [[LoanerStoreNetWorkViewModel alloc]init];
    }
    return _networkViewModel;
}

@end
