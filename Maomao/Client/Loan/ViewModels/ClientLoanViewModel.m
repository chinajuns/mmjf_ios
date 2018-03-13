//
//  ClientLoanViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientLoanViewModel.h"
#import "ClientHomeListCardView.h"
#import "ClientLoanTabCell.h"


static NSString *const identify = @"ClientLoanTabCell";

@interface ClientLoanViewModel()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
/**
 页数
 */
@property (nonatomic, assign)NSInteger pageCurrent;
//判断上下刷新
@property (nonatomic, assign)BOOL isUpDown;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)CQPlaceholderView *placeholderView;
@end
@implementation ClientLoanViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        self.loantypeDic = @{@"id":@"",@"attr_value":@"不限"};
        self.cityDic = @{@"name":@"不限",@"id":@"",@"pid":@""};
        self.focusDic = @{@"attr_value":@"不限",@"pid":@"",@"id":@""};
        self.dataSource = [NSMutableArray array];
        __weak typeof(self)weakSelf = self;
        [weakSelf.netWorkViewModel.loanSearchCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            MMJF_Log(@"%@",x);
            if ([x isKindOfClass:[NSDictionary class]]) {
                [weakSelf refresh:x];
            }else{
                [weakSelf placeholderPic];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
        }];
    }
    return self;
}
//刷新
- (void)refresh:(NSDictionary *)dic{
    [self.placeholderView remove];
    self.tableView.scrollEnabled = YES;
    if (self.isUpDown == NO) {
        self.dataSource = [NSMutableArray array];
    }
    NSString *str = dic[@"next_page_url"];
    if ([str isKindOfClass:[NSNull class]]) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    NSArray *array = dic[@"data"];
    [self.dataSource addObjectsFromArray:array];
}

- (void)placeholderPic{
    self.dataSource = [NSMutableArray array];
    self.tableView.scrollEnabled = NO;
    [self.tableView addSubview:self.placeholderView];
}

/** 占位图的重新加载按钮点击时回调 */
- (void)placeholderView:(CQPlaceholderView *)placeholderView{
    [placeholderView remove];
    switch (placeholderView.type) {
        case MMJFPlaceholderViewTypeLoan:  // 没数据
        {
            [self refresh];
        }
            break;
            
        default:
            break;
    }
}
//刷新
- (void)refresh{
    [self.tableView.mj_header beginRefreshing];
}

- (void)bindViewToViewModel:(UIView *)view {
    self.tableView = (UITableView *)view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView= [UIView new];
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.pageCurrent = 1;
            weakSelf.isUpDown = NO;
            NSDictionary *dic = @{@"region_id":weakSelf.cityDic[@"id"],@"type":weakSelf.loantypeDic[@"id"],@"focus_id":weakSelf.focusDic[@"pid"],@"city":MMJF_ShareV.locatingCity ? MMJF_ShareV.locatingCity:@""};
            NSArray *array = @[[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent],dic];
            [weakSelf.netWorkViewModel.loanSearchCommand execute:array];
        });
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.pageCurrent ++;
            weakSelf.isUpDown = YES;
            NSDictionary *dic = @{@"region_id":weakSelf.cityDic[@"id"],@"type":weakSelf.loantypeDic[@"id"],@"focus_id":weakSelf.focusDic[@"pid"],@"city":MMJF_ShareV.locatingCity ? MMJF_ShareV.locatingCity:@""};
            NSArray *array = @[[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent],dic];
            [weakSelf.netWorkViewModel.loanSearchCommand execute:array];
        });
    }];
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClientLoanTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientLoanTabCell" owner:self options:nil]lastObject];
    }
    ClientHomeListCardView *card = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeListCardView" owner:self options:nil] lastObject];
    card.frame = cell.backView.bounds;
    NSDictionary *dic = self.dataSource[indexPath.row];
    [card setUpdata:dic];
    __weak typeof(self)weakSelf = self;
    [[card.cardClick rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.clickSubject sendNext:dic];
    }];
    [cell.backView addSubview:card];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185;
}


- (ClientLoanNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[ClientLoanNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
}

- (CQPlaceholderView *)placeholderView{
    if (!_placeholderView) {
        _placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, MMJF_WIDTH,self.tableView.height) type:MMJFPlaceholderViewTypeLoan delegate:self];
    }
    return _placeholderView;
}
@end
