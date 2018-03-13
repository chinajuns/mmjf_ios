//
//  ClientInfomationListViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMessageListViewModel.h"
#import "ClientInfomationListTabCell.h"

static NSString *const identify = @"ClientInfomationListTabCell";
@interface ClientMessageListViewModel()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
/**
 页数
 */
@property (nonatomic, assign)NSInteger pageCurrent;
//判断上下刷新
@property (nonatomic, assign)BOOL isUpDown;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)CQPlaceholderView *placeholderView;
@end

@implementation ClientMessageListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        //        self.clickSubject = [RACSubject subject];
        __weak typeof(self)weakSelf = self;
        [self.netWorkViewModel.messageCommand.executionSignals
            .switchToLatest subscribeNext:^(id  _Nullable x) {
            MMJF_Log(@"%@",x);
            if ([x isKindOfClass:[NSDictionary class]]) {
                [weakSelf refresh:x];
            }else{
                [weakSelf placeholderPic];
            }
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%ld",weakSelf.number + 1]};
            [weakSelf.netWorkViewModel.messageSetReadCommand execute:dic];
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

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.pageCurrent = 1;
            weakSelf.isUpDown = NO;
            NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%ld",weakSelf.number + 1],@"page":[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent]};
            [weakSelf.netWorkViewModel.messageCommand execute:dic];
        });
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.pageCurrent ++;
            weakSelf.isUpDown = YES;
            NSDictionary *dic = @{@"type":[NSString stringWithFormat:@"%ld",weakSelf.number + 1],@"page":[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent]};
            [weakSelf.netWorkViewModel.messageCommand execute:dic];
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
    ClientInfomationListTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientInfomationListTabCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    ClientMessageListModel *message = [ClientMessageListModel yy_modelWithJSON:dic];
    [cell setUpdata:message];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
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

- (ClientMessageNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[ClientMessageNetWorkViewModel alloc]init];
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
