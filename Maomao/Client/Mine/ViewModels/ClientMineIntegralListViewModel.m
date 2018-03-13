//
//  ClientMineIntegralListViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineIntegralListViewModel.h"
#import "ClientintegralSubsidiaryTabCell.h"

static NSString *const identify = @"ClientintegralSubsidiaryTabCell";
@interface ClientMineIntegralListViewModel()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataSouce;
@property (nonatomic, strong)UITableView *tableView;

/**
 页数
 */
@property (nonatomic, assign)NSInteger pageCurrent;
//判断上下刷新
@property (nonatomic, assign)BOOL isUpDown;

@property (nonatomic, strong)CQPlaceholderView *placeholderView;
@end
@implementation ClientMineIntegralListViewModel


- (instancetype)init {
    self = [super init];
    if (self) {
        //        self.clickSubject = [RACSubject subject];
        __weak typeof(self)weakSelf = self;
        [self.networdViewModel.memberPointCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            MMJF_Log(@"%@",x);
            weakSelf.dataSouce = [NSMutableArray array];
            weakSelf.dataSouce = x[@"list"];
            [weakSelf.tableView reloadData];
        }];
        [weakSelf.networdViewModel.pointListCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
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
    if (self.isRefresh == YES) {
        __weak typeof(self)weakSelf = self;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //网络请求
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.pageCurrent = 1;
                weakSelf.isUpDown = NO;
                [weakSelf.networdViewModel.pointListCommand execute:[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent]];
            });
        }];
        [self.tableView.mj_header beginRefreshing];
        
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            //网络请求
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.pageCurrent ++;
                weakSelf.isUpDown = YES;
                [weakSelf.networdViewModel.pointListCommand execute:[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent]];
            });
        }];
    }
}

//刷新
- (void)refresh:(NSDictionary *)dic{
    [self.placeholderView remove];
    self.tableView.scrollEnabled = YES;
    if (self.isUpDown == NO) {
        self.dataSouce = [NSMutableArray array];
    }
    NSString *str = dic[@"next_page_url"];
    if ([str isKindOfClass:[NSNull class]]) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    NSArray *array = dic[@"data"];
    [self.dataSouce addObjectsFromArray:array];
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSouce.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClientintegralSubsidiaryTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientintegralSubsidiaryTabCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = self.dataSouce[indexPath.section];
    ClientMineIntegralModel *moel = [ClientMineIntegralModel yy_modelWithJSON:dic];
    [cell setUpData:moel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103;
}

- (void)placeholderPic{
    self.dataSouce = [NSMutableArray array];
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

- (ClientMineNetworkViewModel *)networdViewModel{
    if (!_networdViewModel) {
        _networdViewModel = [[ClientMineNetworkViewModel alloc]init];
    }
    return _networdViewModel;
}
- (CQPlaceholderView *)placeholderView{
    if (!_placeholderView) {
        _placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, MMJF_WIDTH,self.tableView.height) type:MMJFPlaceholderViewTypeLoan delegate:self];
    }
    return _placeholderView;
}
@end
