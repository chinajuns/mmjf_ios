//
//  LoanerAgentProductsViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerAgentProductsViewModel.h"
#import "LoanerAgentProductsTabCell.h"


static NSString *const identify = @"LoanerAgentProductsTabCell";
@interface LoanerAgentProductsViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

//判断上下刷新
@property (nonatomic, assign)BOOL isUpDown;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, copy)NSArray *dataArray;
@property (nonatomic, strong)CQPlaceholderView *placeholderView;
@property (nonatomic, copy)NSDictionary *dict;
@end
@implementation LoanerAgentProductsViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        [self setUpdata];
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
            weakSelf.isUpDown = NO;
            NSDictionary *dic = @{@"type":@"all",@"cate_id":weakSelf.cate_id?weakSelf.cate_id:@""};
            [weakSelf.netWorkViewModel.myProductCommand execute:dic];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.isUpDown = YES;
            NSDictionary *dic = @{@"type":@"all",@"cate_id":weakSelf.cate_id?weakSelf.cate_id:@"",@"create_time":weakSelf.create_time};
            [weakSelf.netWorkViewModel.myProductCommand execute:dic];
        });
    }];
}
//加载
- (void)loading{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LoanerAgentProductsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerAgentProductsTabCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    LoanerStoreProductModel *model = [LoanerStoreProductModel yy_modelWithJSON:dic];
    [cell setUpData:model];
    __weak typeof(self)weakSelf = self;
    [[cell.agentBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSDictionary *dic = weakSelf.dataSource[indexPath.row];
        LoanerStoreProductModel *model = [LoanerStoreProductModel yy_modelWithJSON:dic];
        NSDictionary *dic1 = @{@"id":[NSString stringWithFormat:@"%@",model.Id],@"action":@"add"};
        [weakSelf.netWorkViewModel.setAgentCommand execute:dic1];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 235;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.row];
    LoanerStoreProductModel *model = [LoanerStoreProductModel yy_modelWithJSON:dic];
    self.dict = @{@"id":[NSString stringWithFormat:@"%@",model.Id],@"action":@"add"};
    [self.clickSubject sendNext:[NSString stringWithFormat:@"%ld",indexPath.row]];
}
//返回参数
- (NSDictionary *)getListDic{
    return self.dict;
}

//设置数据
- (void)setUpdata{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.myProductCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        if ([x isKindOfClass:[NSArray class]]) {
            [weakSelf refresh:x];
//            weakSelf.dataArray = x[@"cate"];
        }else{
            if (weakSelf.isUpDown == NO) {
                [weakSelf placeholderPic];
                [weakSelf.tableView reloadData];
            }
            weakSelf.tableView.mj_footer.hidden = YES;
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView.mj_header endRefreshing];
            return ;
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    [self.netWorkViewModel.setAgentCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [MBProgressHUD showError:@"代理成功"];
        [weakSelf loading];
    }];
}

//刷新
- (void)refresh:(NSArray *)array{
    [self.placeholderView remove];
    self.tableView.scrollEnabled = YES;
    if (self.isUpDown == NO) {
        self.dataSource = [NSMutableArray array];
    }
    if (array.count == 0) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    self.create_time = array.lastObject[@"create_time"];
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
            [self.tableView.mj_header beginRefreshing];
        }
            break;
            
        default:
            break;
    }
}


- (LoanerStoreNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerStoreNetWorkViewModel alloc]init];
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
