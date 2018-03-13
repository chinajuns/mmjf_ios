//
//  LoanerWithdrawalSuccessViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerWithdrawalSuccessViewController.h"

@interface LoanerWithdrawalSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIButton *completeBut;

@end

@implementation LoanerWithdrawalSuccessViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现成功";
}

- (IBAction)completeBut:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
