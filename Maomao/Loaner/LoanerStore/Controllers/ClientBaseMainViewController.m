//
//  ClientBaseMainViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/20.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientBaseMainViewController.h"
#import "CYTabBarController.h"
#import "BHBPopView.h"
#import "LoanerStoreCreateViewController.h"
#import "LoanerMineCertificationViewController.h"
#import "LoanerMineRecertificationViewController.h"
#import "LoanerStoreDetailViewController.h"
#import "LoanerStoreNetWorkViewModel.h"

@interface ClientBaseMainViewController ()<CYTabBarDelegate>
@property (nonatomic, strong)SharePodStyleViewModel *podViewModel;

/**
 店铺状态 : 0=>未创建店铺,1=>未审核,2=>通过, 3=>拒绝
 */
@property (nonatomic, copy)NSString *check_result;
@property (nonatomic, strong)LoanerStoreNetWorkViewModel *netWorkModel;
@end

@implementation ClientBaseMainViewController

- (void)dealloc{
    CYTABBARCONTROLLER.tabbar.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkAuthentication) name:@"checkAuthentication" object:nil];
    CYTABBARCONTROLLER.tabbar.delegate = self;
//    [CYTABBARCONTROLLER setCYTabBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [CYTABBARCONTROLLER setCYTabBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.check_result = @"";
    [self setUpNetWork];
}

- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    [self.netWorkModel.shopIndexCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        if (![x isKindOfClass:[NSDictionary class]]) {
            [MBProgressHUD showError:@"实名认证失败"];
            return ;
        }
        weakSelf.check_result = [NSString stringWithFormat:@"%@",x[@"check_result"]];
        if ([weakSelf.check_result isEqualToString:@"0"]) {
            
        }else if ([weakSelf.check_result isEqualToString:@"2"]){
            LoanerStoreDetailViewController *vc = [[LoanerStoreDetailViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            return ;
        }else if ([weakSelf.check_result isEqualToString:@"3"]){
            [MBProgressHUD showError:@"创建店铺审核失败请重新创建"];
        }else if ([weakSelf.check_result isEqualToString:@"1"]){
            [MBProgressHUD showError:@"创建的店铺正在审核中请耐心等待"];
            return ;
        }
        BHBItem * item0 = [[BHBItem alloc]initWithTitle:@"" Icon:@"images.bundle/tabbar_compose_idea"];
        __weak typeof(self)weakSelf = self;
        //添加popview
        [BHBPopView showToView:self.view.window withItems:@[item0]andSelectBlock:^(BHBItem *item) {
            if ([item isKindOfClass:[BHBGroup class]]) {
                MMJF_Log(@"选中%@分组",item.title);
            }else{
                LoanerStoreCreateViewController *vc = [[LoanerStoreCreateViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }
        }];
    }];
    
}

- (void)jump:(NSInteger)number{
    CYTABBARCONTROLLER.selectedIndex = number;
}

- (void)checkAuthentication{
    NSString *str;
    if ([MMJF_ShareV.is_auth isEqualToString:@"1"]) {
        str = @"您尚未完成实名认证，暂时不能创建店铺，是否前往实名认证?";
    }else if ([MMJF_ShareV.is_auth isEqualToString:@"2"]){
        [MBProgressHUD showError:@"您还在认证中，请耐心等待"];
        return;
    }else if ([MMJF_ShareV.is_auth isEqualToString:@"4"]){
        str = @"您认证失败，查看认证情况";
    }else{
        CYTABBARCONTROLLER.selectedIndex = 2;
    }
    TYAlertController *alertController = [self.podViewModel setUpShareTwo:str determineStr:@"实名认证" cancelStr:@"取消"];
    [self presentViewController:alertController animated:YES completion:nil];
}

//中间按钮点击
- (void)tabbar:(CYTabBar *)tabbar clickForCenterButton:(CYCenterButton *)centerButton{
    if ([MMJF_ShareV.is_auth isEqualToString:@"3"]) {
        [self.netWorkModel.shopIndexCommand execute:nil];
    }else if ([MMJF_ShareV.is_auth isEqualToString:@"0"]){
        [MBProgressHUD showError:@"似乎与互联网断开连接"];
    }
    else{
        [self checkAuthentication];
    }
    
}

- (SharePodStyleViewModel *)podViewModel{
    if (!_podViewModel) {
        _podViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        [_podViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            if([MMJF_ShareV.is_auth isEqualToString:@"1"]){
                //未审核
                LoanerMineCertificationViewController *vc = [[LoanerMineCertificationViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{//审核中
                LoanerMineRecertificationViewController *vc = [[LoanerMineRecertificationViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _podViewModel;
}

- (LoanerStoreNetWorkViewModel *)netWorkModel{
    if (!_netWorkModel) {
        _netWorkModel = [[LoanerStoreNetWorkViewModel alloc]init];
    }
    return _netWorkModel;
}

@end
