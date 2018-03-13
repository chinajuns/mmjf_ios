//
//  ClientMineIntegralSubsidiaryViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/19.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineIntegralSubsidiaryViewController.h"
#import "ClientMineIntegralListViewModel.h"
@interface ClientMineIntegralSubsidiaryViewController ()
@property (nonatomic, strong)ClientMineIntegralListViewModel *minelistViewModel;
@property (weak, nonatomic) IBOutlet UITableView *listTab;
@end

@implementation ClientMineIntegralSubsidiaryViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMineListViewModel];
    self.title = @"积分明细";
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
}

//设置积分列表
- (void)setUpMineListViewModel{
    self.minelistViewModel.isRefresh = YES;
    [self.minelistViewModel bindViewToViewModel:self.listTab];
    
}
- (ClientMineIntegralListViewModel *)minelistViewModel{
    if (!_minelistViewModel) {
        _minelistViewModel = [[ClientMineIntegralListViewModel alloc]init];
    }
    return _minelistViewModel;
}

@end
