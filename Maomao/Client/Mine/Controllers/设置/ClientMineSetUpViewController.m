//
//  ClientMineSetUpViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineSetUpViewController.h"
#import "ClientMineSetUpListViewModel.h"
#import "ClientMineFeedbackViewController.h"
#import "ClientMineChangePasswordViewController.h"
#import "LogHomeViewController.h"
#import "MMJFBaseNavigationViewController.h"
#import "ClientMineNetworkViewModel.h"
#import "ClientMineWebPageViewController.h"

@interface ClientMineSetUpViewController ()
@property (weak, nonatomic) IBOutlet UITableView *setUpTab;

@property (nonatomic, strong)ClientMineNetworkViewModel *netWorkViewModel;
@property (nonatomic, strong)ClientMineSetUpListViewModel *setUpListViewModel;
@end

@implementation ClientMineSetUpViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [self setUpSetListViewModel];
    [self setUpNetWork];
}

//设置列表
- (void)setUpSetListViewModel{
    [self.setUpListViewModel bindViewToViewModel:self.setUpTab];
    __weak typeof(self)weakSelf = self;
    [weakSelf.setUpListViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        [weakSelf jump:x];
    }];
    //设置推送
    [self.setUpListViewModel.swithSubject subscribeNext:^(id  _Nullable x) {
        NSDictionary *dic;
        if ([x isEqualToString:@"开"]) {
            dic = @{@"action":@"on"};
        }else{
            dic = @{@"action":@"off"};
        }
        [weakSelf.netWorkViewModel.setPushStatus execute:dic];
    }];
}

- (void)jump:(NSString *)x{
    switch ([x integerValue]) {
        case 0:
        {
            ClientMineFeedbackViewController *vc = [[ClientMineFeedbackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            ClientMineChangePasswordViewController *vc = [[ClientMineChangePasswordViewController alloc]init];
            vc.isC = self.isC;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            ClientMineWebPageViewController *vc = [[ClientMineWebPageViewController alloc]init];
            vc.number = 3;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 4:
        {//退出登录
            [self.netWorkViewModel.logoutCommand execute:nil];
        }
            break;
        default:
            break;
    }
}
//设置网络请求
- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.logoutCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        // 创建文件管理对象
        NSFileManager *manager = [NSFileManager defaultManager];
        // 删除
        [manager removeItemAtPath:MMJF_UserInfoPath error:nil];
        
        LogHomeViewController *log = [[LogHomeViewController alloc]init];
        MMJFBaseNavigationViewController *nav = [[MMJFBaseNavigationViewController alloc]initWithRootViewController:log];
        if (weakSelf.isC == YES) {
            MMJF_ShareV.isCustomer = YES;
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }else{
            MMJF_ShareV.isCustomer = NO;
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        }
        
    }];
    
    [self.netWorkViewModel.getPushStatus.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        weakSelf.setUpListViewModel.number = [[NSString stringWithFormat:@"%@",x[@"push_status"]] integerValue];
        [weakSelf.setUpListViewModel refresh];
    }];
    
    [self.netWorkViewModel.getPushStatus execute:nil];
    
    [self.netWorkViewModel.setPushStatus.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [weakSelf.netWorkViewModel.getPushStatus execute:nil];
    }];
}

#pragma mark--getter
- (ClientMineSetUpListViewModel *)setUpListViewModel{
    if (!_setUpListViewModel) {
        _setUpListViewModel = [[ClientMineSetUpListViewModel alloc]init];
    }
    return _setUpListViewModel;
}

- (ClientMineNetworkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[ClientMineNetworkViewModel alloc]init];
    }
    return _netWorkViewModel;
}
@end
