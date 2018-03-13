//
//  ClientInformationViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/17.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientInformationViewController.h"
#import "ClientInfomationListViewModel.h"
#import "ClientInfomationMoreListViewController.h"
#import "ClientInfomationNetWorkViewModel.h"
#import "ClientInformationDetailsViewController.h"

@interface ClientInformationViewController ()
@property (nonatomic, strong)ClientInfomationNetWorkViewModel *networkViewModel;
@property (weak, nonatomic) IBOutlet UITableView *listTab;
@property (nonatomic, strong)ClientInfomationListViewModel *infomationViewModel;

@property (nonatomic, strong)CQPlaceholderView *placeholderView;
@end

@implementation ClientInformationViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
    [self.listTab.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpData];
    [self setUpInfomationListViewModel];
}
//设置列表
- (void)setUpInfomationListViewModel{
    [self.infomationViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    [weakSelf.infomationViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        ClientInfomationMoreListViewController *vc = [[ClientInfomationMoreListViewController alloc]init];
        vc.Id = x[@"id"];
        vc.titleStr = x[@"cate_name"];
        vc.isB = weakSelf.isB;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.infomationViewModel.listSubject subscribeNext:^(id  _Nullable x) {
        ClientInformationDetailsViewController *vc = [[ClientInformationDetailsViewController alloc]init];
        vc.model = x;
        vc.isB = weakSelf.isB;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}
//设置数据
- (void)setUpData{
    __weak typeof(self)weakSelf = self;
    [self.networkViewModel.articleCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        NSArray *list = x[@"list"];
        if (list.count == 0) {
            [weakSelf placeholderPic];
        }else{
            [weakSelf.placeholderView remove];
           [weakSelf.infomationViewModel setUpData:x];
            [weakSelf.listTab.mj_header endRefreshing];
        }
    }];
    self.listTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.networkViewModel.articleCommand execute:nil];
        });
    }];
}

- (void)placeholderPic{
    [self.view addSubview:self.placeholderView];
}

/** 占位图的重新加载按钮点击时回调 */
- (void)placeholderView:(CQPlaceholderView *)placeholderView{
    [placeholderView remove];
    switch (placeholderView.type) {
        case MMJFPlaceholderViewTypeLoan:  // 没数据
        {
            [self.networkViewModel.articleCommand execute:nil];
        }
            break;
            
        default:
            break;
    }
}

- (ClientInfomationListViewModel *)infomationViewModel{
    if (!_infomationViewModel) {
        _infomationViewModel = [[ClientInfomationListViewModel alloc]init];
    }
    return _infomationViewModel;
}

- (ClientInfomationNetWorkViewModel *)networkViewModel{
    if (!_networkViewModel) {
        _networkViewModel = [[ClientInfomationNetWorkViewModel alloc]init];
    }
    return _networkViewModel;
}

- (CQPlaceholderView *)placeholderView
{
    if (!_placeholderView) {
        _placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 64, MMJF_WIDTH,MMJF_HEIGHT - 49) type:MMJFPlaceholderViewTypeLoan delegate:self];
    }
    return _placeholderView;
}
@end
