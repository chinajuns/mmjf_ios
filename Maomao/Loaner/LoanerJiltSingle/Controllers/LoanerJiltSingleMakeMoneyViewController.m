//
//  LoanerJiltSingleDetaiViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerJiltSingleMakeMoneyViewController.h"
#import "LoanerJiltSinglemakeMoneyViewModel.h"

@interface LoanerJiltSingleMakeMoneyViewController ()
@property (weak, nonatomic) IBOutlet UITableView *detailTab;

@property (nonatomic, strong)LoanerJiltSinglemakeMoneyViewModel *makeMoneyViewModel;
@end

@implementation LoanerJiltSingleMakeMoneyViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpmakeMoneyViewModel];
}

- (void)setUpmakeMoneyViewModel{
    [self.makeMoneyViewModel bindViewToViewModel:self.detailTab];
}

- (LoanerJiltSinglemakeMoneyViewModel *)makeMoneyViewModel{
    if (!_makeMoneyViewModel) {
        _makeMoneyViewModel = [[LoanerJiltSinglemakeMoneyViewModel alloc]init];
    }
    return _makeMoneyViewModel;
}

@end
