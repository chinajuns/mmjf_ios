//
//  ClientMineOrderListViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineOrderListViewModel.h"
#import "ClientMineOrderStateTabCell.h"

static NSString *const identify = @"ClientMineOrderStateTabCell";
@interface ClientMineOrderListViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign)NSInteger number;
/**
 页数
 */
@property (nonatomic, assign)NSInteger pageCurrent;
//判断上下刷新
@property (nonatomic, assign)BOOL isUpDown;
@property (nonatomic, strong)CQPlaceholderView *placeholderView;
@end

@implementation ClientMineOrderListViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
    [self.detailsSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        self.detailsSubject = [RACSubject subject];
        __weak typeof(self)weakSelf = self;
        [self.networkViewModel.historyCommand.executionSignals.
         switchToLatest subscribeNext:^(id  _Nullable x) {
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

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.pageCurrent = 1;
            weakSelf.isUpDown = NO;
            NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%ld",weakSelf.number]};
            NSDictionary *dic1 = @{@"page":[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent],@"dict":dic};
            [weakSelf.networkViewModel.historyCommand execute:dic1];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.pageCurrent ++;
            weakSelf.isUpDown = YES;
            NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%ld",weakSelf.number]};
            NSDictionary *dic1 = @{@"page":[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent],@"dict":dic};
            [weakSelf.networkViewModel.historyCommand execute:dic1];
        });
    }];
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClientMineOrderStateTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineOrderStateTabCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = self.dataSource[indexPath.section];
    [cell setUpListData:dic[@"loaner"]];
    NSString *process = [NSString stringWithFormat:@"%@",dic[@"process"]];
    [cell setUpStats:dic[@"processing"] all_process:dic[@"all_process"] process:process];
    NSString *is_comment = [NSString stringWithFormat:@"%@",dic[@"is_comment"]];
    cell.evaluationView.hidden = YES;
    if ([is_comment isEqualToString:@"1"]) {
        if ([process isEqualToString:@"37"] || [process isEqualToString:@"38"]) {
            cell.evaluationView.hidden = NO;
        }
    }
    __weak typeof(self)weakSelf = self;
    [[cell.evaluationBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.clickSubject sendNext:dic];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.section];
    NSString *is_comment = [NSString stringWithFormat:@"%@",dic[@"is_comment"]];
    NSString *process = [NSString stringWithFormat:@"%@",dic[@"process"]];
    if ([is_comment isEqualToString:@"1"]) {
        if ([process isEqualToString:@"37"] || [process isEqualToString:@"38"]) {
            return 340;
        }
    }
    return 300;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.section];
    [self.detailsSubject sendNext:dic];
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

//刷新
- (void)sliding:(NSInteger)number{
    self.number = number;
    [self.tableView.mj_header beginRefreshing];
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
            [self.tableView.mj_header beginRefreshing];
        }
            break;
            
        default:
            break;
    }
}

- (ClientMineNetworkViewModel *)networkViewModel{
    if (!_networkViewModel) {
        _networkViewModel = [[ClientMineNetworkViewModel alloc]init];
    }
    return _networkViewModel;
}

- (CQPlaceholderView *)placeholderView{
    if (!_placeholderView) {
        _placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, MMJF_WIDTH,self.tableView.height) type:MMJFPlaceholderViewTypeLoan delegate:self];
    }
    return _placeholderView;
}
@end
