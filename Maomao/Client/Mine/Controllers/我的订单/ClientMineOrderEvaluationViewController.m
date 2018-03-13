//
//  ClientMineOrderEvaluationViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineOrderEvaluationViewController.h"
#import "ClientMineOrdereEvaluationViewModel.h"

@interface ClientMineOrderEvaluationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *evaluationTab;

@property (nonatomic, strong)ClientMineOrdereEvaluationViewModel *evaluationViewModel;
@end

@implementation ClientMineOrderEvaluationViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    __weak typeof(self)weakSelf = self;
    [weakSelf.evaluationViewModel.networkViewModel.scoreTypeCommand.
     executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
         [weakSelf.evaluationViewModel refresh:x orderid:weakSelf.orderId];
    }];
    [weakSelf.evaluationViewModel.networkViewModel.userAddScoreCommand.
     executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
         [weakSelf.navigationController popViewControllerAnimated:YES];
     }];
    [self setUpevaluation];
}

- (void)setUpevaluation{
    [self.evaluationViewModel bindViewToViewModel:self.evaluationTab];
}

- (ClientMineOrdereEvaluationViewModel *)evaluationViewModel{
    if (!_evaluationViewModel) {
        _evaluationViewModel = [[ClientMineOrdereEvaluationViewModel alloc]init];
    }
    return _evaluationViewModel;
}

@end
