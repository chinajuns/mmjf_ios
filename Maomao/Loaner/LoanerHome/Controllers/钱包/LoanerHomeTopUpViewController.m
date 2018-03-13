//
//  LoanerHomeTopUpViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerHomeTopUpViewController.h"
#import "LoanerHomeTopUpViewModel.h"
#import "LoanerHomeTopUpSuccessViewController.h"

@interface LoanerHomeTopUpViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic, strong)LoanerHomeTopUpViewModel *topUpViewModel;
@end

@implementation LoanerHomeTopUpViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分充值";
    [self setUpTopUpViewModel];
}

- (void)setUpTopUpViewModel{
    [self.topUpViewModel bindViewToViewModel:self.listTab];
}

- (LoanerHomeTopUpViewModel *)topUpViewModel{
    if (!_topUpViewModel) {
        _topUpViewModel = [[LoanerHomeTopUpViewModel alloc]init];
    }
    return _topUpViewModel;
}
- (IBAction)clickBut:(UIButton *)sender {
    LoanerHomeTopUpSuccessViewController *vc = [[LoanerHomeTopUpSuccessViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
