//
//  ClientMineIntegralDetailsViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineIntegralDetailsViewController.h"
#import "ClientMineIntegralListViewModel.h"
#import "ClientMineIntegralSubsidiaryViewController.h"
#import "ClientMineWebPageViewController.h"

@interface ClientMineIntegralDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *availableLntegralLab;
@property (weak, nonatomic) IBOutlet UILabel *obtainLab;
@property (weak, nonatomic) IBOutlet UILabel *monthObtainLab;
/**
 积分列表
 */
@property (weak, nonatomic) IBOutlet UITableView *integralTab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;
@property (nonatomic, strong)ClientMineIntegralListViewModel *minelistViewModel;
@end

@implementation ClientMineIntegralDetailsViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMineListViewModel];
    if (MMJF_HEIGHT > 800) {
        self.topLine.constant = 52;
    }
}
//设置积分列表
- (void)setUpMineListViewModel{
    __weak typeof(self)weakSelf = self;
    [self.minelistViewModel.networdViewModel.memberPointCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        weakSelf.availableLntegralLab.text = [NSString stringWithFormat:@"%@",x[@"total"]];
         weakSelf.obtainLab.text = [NSString stringWithFormat:@"今日获得:%@积分",x[@"day"]];
         weakSelf.monthObtainLab.text = [NSString stringWithFormat:@"本月获得:%@积分",x[@"month"]];
    }];
    [self.minelistViewModel bindViewToViewModel:self.integralTab];
    [self.minelistViewModel.networdViewModel.memberPointCommand execute:nil];
}
//顶部导航按钮
- (IBAction)topBut:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        ClientMineWebPageViewController *vc = [[ClientMineWebPageViewController alloc]init];
        vc.number = 4;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//积分按钮
- (IBAction)IntegralBut:(UIButton *)sender {
    if (sender.tag == 0) {//积分商城
        
    }else{//积分明细
        ClientMineIntegralSubsidiaryViewController *vc = [[ClientMineIntegralSubsidiaryViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (ClientMineIntegralListViewModel *)minelistViewModel{
    if (!_minelistViewModel) {
        _minelistViewModel = [[ClientMineIntegralListViewModel alloc]init];
    }
    return _minelistViewModel;
}

@end
