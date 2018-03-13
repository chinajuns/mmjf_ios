//
//  LoanerCustomerDetailsViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerCustomerDetailsViewController.h"
#import "LoanerCustomerDetailViewModel.h"
#import "LoanerCustomerNetWorkViewModel.h"

#import "LoanerMineCertificationViewController.h"
#import "LoanerHomeTopUpViewController.h"//积分充值

@interface LoanerCustomerDetailsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *detailTab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;

@property (weak, nonatomic) IBOutlet UIButton *clickBut;

/**
 所需积分
 */
@property (nonatomic, copy)NSString *scoreStr;
@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;

@property (nonatomic, strong)LoanerCustomerDetailViewModel *detailViewModel;

@property (nonatomic, strong)LoanerCustomerNetWorkViewModel *netWorkViewModel;
@end

@implementation LoanerCustomerDetailsViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户详情";
    if (self.isSingle == YES) {
        self.clickBut.hidden = YES;
        self.line.constant = 0;
    }
    [self setUpDetailViewModel];
    [self setUpNetWork];
}

- (void)setUpDetailViewModel{
    [self.detailViewModel bindViewToViewModel:self.detailTab];
    __weak typeof(self)weakSelf = self;
    //按钮点击
    [[self.clickBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //抢单资格验证
        NSDictionary *dic = @{@"id":weakSelf.ID};
        [weakSelf.netWorkViewModel.checkPurchaseCommand execute:dic];
    }];
}
//设置网络
- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.orderDetailCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        weakSelf.scoreStr = [NSString stringWithFormat:@"%@",x[@"score"]];
        [weakSelf.clickBut setTitle:[NSString stringWithFormat:@"%@积分",weakSelf.scoreStr] forState:UIControlStateNormal];
        [weakSelf.detailViewModel refresh:x];
    }];
    NSDictionary *dic = @{@"id":self.ID};
    [self.netWorkViewModel.orderDetailCommand execute:dic];
    //B端：首页-抢单-检查抢单资格
    [self.netWorkViewModel.checkPurchaseCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"%@",x);
         NSString *is_auth = [NSString stringWithFormat:@"%@",x[@"is_auth"]];
         NSString *my_score = [NSString stringWithFormat:@"%@",x[@"my_score"]];
         NSString *is_mine = [NSString stringWithFormat:@"%@",x[@"is_mine"]];
         if ([is_mine isEqualToString:@"1"]) {//1自己的单子 0不是
             [MBProgressHUD showError:@"不能抢自己的单子"];
             return ;
         }
         if ([is_auth isEqualToString:@"3"]){
             if ([my_score floatValue] < [weakSelf.scoreStr floatValue]) {
                 [weakSelf lackIntegral];//积分不足
             }else{//支付
                 [weakSelf payPop:weakSelf.scoreStr];
             }
         }else{
             NSString *str;
             if ([is_auth isEqualToString:@"1"]) {
                 str = @"您还未实名认证，请先认证";
             }else if ([is_auth isEqualToString:@"2"]){
                 str = @"您还在认证中，查看认证情况";
             }else if ([is_auth isEqualToString:@"4"]){
                 str = @"您认证失败，查看认证情况";
             }else{
                 return;
             }
             TYAlertController *alertController = [weakSelf.podStyleViewModel setUpShareTwo:str determineStr:@"实名认证" cancelStr:@"取消"];
             [weakSelf presentViewController:alertController animated:YES completion:nil];
         }
         
     }];
    //B端：首页-抢单-立即支付
    [self.netWorkViewModel.purchaseCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         if ([x isEqualToString:@"200"]) {
             [weakSelf dismissViewControllerAnimated:YES completion:nil];
             [weakSelf successful:weakSelf.scoreStr];
         }
     }];
}

//积分不足提示
- (void)lackIntegral{
    TYAlertController *alertController = [self.podStyleViewModel setUpShareTwo:@"积分不足，立即购买" determineStr:@"确定" cancelStr:@"取消" ];
    [self presentViewController:alertController animated:YES completion:nil];
}
//支付提示
- (void)payPop:(NSString *)str{
    TYAlertController *alertController = [self.podStyleViewModel setUpShareTitleTwoView:@"支付" soce:str unit:@"积分（分）"];
    [self presentViewController:alertController animated:YES completion:nil];
}
//抢单
- (void)successful:(NSString *)str{
    TYAlertController *alertController = [self.podStyleViewModel setUpSharePictureTwoView:@"抢单成功" img:@"cheng-gong" butTitle:@"确定" prompt1:@"支付方式：积分" prompt2:[NSString stringWithFormat:@"支付金额：%@积分",str]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (LoanerCustomerDetailViewModel *)detailViewModel{
    if (!_detailViewModel) {
        _detailViewModel = [[LoanerCustomerDetailViewModel alloc]init];
    }
    return _detailViewModel;
}

- (LoanerCustomerNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerCustomerNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
}

- (SharePodStyleViewModel *)podStyleViewModel{
    if (!_podStyleViewModel) {
        _podStyleViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        //点击
        [_podStyleViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            if ([x isEqualToString:@"积分不足，立即购买"]) {
                LoanerHomeTopUpViewController *VC = [[LoanerHomeTopUpViewController alloc]init];
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }else if ([x isEqualToString:@"您还未实名认证，请先认证"] || [x isEqualToString:@"您还在认证中，查看认证情况"] || [x isEqualToString:@"您认证失败，查看认证情况"]){
                //实名认证
                LoanerMineCertificationViewController *VC= [[LoanerMineCertificationViewController alloc]init];
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }else if ([x isEqualToString:@"支付"]){
                NSDictionary *dic = @{@"id":weakSelf.ID};
                [weakSelf.netWorkViewModel.purchaseCommand execute:dic];
            }else if ([x isEqualToString:@"抢单成功"]){
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                weakSelf.clickBut.hidden = YES;
                weakSelf.line.constant = 0;
                //重新获取详情信息
                NSDictionary *dic = @{@"id":self.ID};
                [weakSelf.netWorkViewModel.orderDetailCommand execute:dic];
            }
        }];
    }
    return _podStyleViewModel;
}
@end
