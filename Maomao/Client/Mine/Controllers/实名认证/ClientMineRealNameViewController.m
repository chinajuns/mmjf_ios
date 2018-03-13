//
//  ClientMineRealNameViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineRealNameViewController.h"
#import "ClientMineRealNameViewModel.h"
#import "ClientMineRealNameTwoViewController.h"


@interface ClientMineRealNameViewController ()
@property (weak, nonatomic) IBOutlet UITableView *realNameTab;
@property (nonatomic, strong)ClientMineRealNameViewModel *realnameViewModel;


@end

@implementation ClientMineRealNameViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self setUpReakNameViewModel];
}
//设置列表
- (void)setUpReakNameViewModel{
    [self.realnameViewModel bindViewToViewModel:self.realNameTab];
    __weak typeof(self)weakSelf = self;
    [weakSelf.realnameViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        ClientMineRealNameTwoViewController *vc = [[ClientMineRealNameTwoViewController alloc]init];
        vc.dict = x;
        MMJF_Log(@"%@",x);
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (ClientMineRealNameViewModel *)realnameViewModel{
    if (!_realnameViewModel) {
        _realnameViewModel = [[ClientMineRealNameViewModel alloc]init];
    }
    return _realnameViewModel;
}

@end
