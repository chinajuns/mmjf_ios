//
//  LoanerCustomerViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerCustomerViewModel.h"
#import "LoanerCustomerTabCell.h"


static NSString *const identify = @"LoanerCustomerTabCell";
@interface LoanerCustomerViewModel()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;

//判断上下刷新
@property (nonatomic, assign)BOOL isUpDown;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)CQPlaceholderView *placeholderView;
@end
@implementation LoanerCustomerViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
    [self.listClickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        self.listClickSubject = [RACSubject subject];
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
    [self setParameter:@"" region_id:@"" has_house:@"" has_car:@""];
}

- (void)setParameter:(NSString *)is_vip region_id:(NSString *)region_id has_house:(NSString *)has_house has_car:(NSString *)has_car{
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.isUpDown = NO;
            NSDictionary *dic = @{@"is_vip":is_vip?is_vip:@"",@"region_id":region_id?region_id:@"",@"has_house":has_house?has_house:@"",@"has_car":has_car?has_car:@"",@"city_name":MMJF_ShareV.locatingCity ? MMJF_ShareV.locatingCity:@""};
            [weakSelf.netWorkViewModel.orderIndexCommand execute:dic];
        });
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.isUpDown = YES;
            NSDictionary *dic = @{@"is_vip":is_vip?is_vip:@"",@"region_id":region_id?region_id:@"",@"has_house":has_house?has_house:@"",@"has_car":has_car?has_car:@"",@"create_time":weakSelf.create_time,@"city_name":MMJF_ShareV.locatingCity ? MMJF_ShareV.locatingCity:@""};
            [weakSelf.netWorkViewModel.orderIndexCommand execute:dic];
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
    LoanerCustomerTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerCustomerTabCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    LoanerCustomerModel *model = [LoanerCustomerModel yy_modelWithJSON:dic];
    [cell setUpdata:model];
    __weak typeof(self)weakSelf = self;
    cell.grabSingleBut.tag = indexPath.row;
    [[cell.grabSingleBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSDictionary *dic = weakSelf.dataSource[indexPath.row];
        [weakSelf.clickSubject sendNext:dic];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 312;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.row];
    [self.listClickSubject sendNext:dic];
}
//设置数据
- (void)setUpdata{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.orderIndexCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        if ([x isKindOfClass:[NSArray class]]) {
            [weakSelf refresh:x];
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

- (LoanerCustomerNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerCustomerNetWorkViewModel alloc]init];
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
