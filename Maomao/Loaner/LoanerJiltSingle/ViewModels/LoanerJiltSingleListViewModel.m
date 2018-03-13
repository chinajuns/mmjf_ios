//
//  LoanerJiltSingleListViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerJiltSingleListViewModel.h"
#import "LoanerJiltInformationTabCell.h"
#import "LoanerJiltSingleNetWorkViewModel.h"
#import "ButtonCell.h"

static NSString *const identify1 = @"LoanerJiltInformationTabCell";
static NSString *const identify = @"ButtonCell";
@interface LoanerJiltSingleListViewModel()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
//判断上下刷新
@property (nonatomic, assign)BOOL isUpDown;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong)LoanerJiltSingleNetWorkViewModel *networkViewModel;
@property (nonatomic, strong)CQPlaceholderView *placeholderView;
@end
@implementation LoanerJiltSingleListViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        __weak typeof(self)weakSelf = self;
        //B端：首页-甩单-重新甩单
        [self.networkViewModel.junkAgainCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
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
            NSDictionary *dic = @{@"status":[NSString stringWithFormat:@"%ld",weakSelf.number]};
            [weakSelf.networkViewModel.junkListCommand execute:dic];
        });
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.isUpDown = YES;
            NSDictionary *dic = @{@"status":[NSString stringWithFormat:@"%ld",weakSelf.number],@"create_time":weakSelf.create_time};
            [weakSelf.networkViewModel.junkListCommand execute:dic];
        });
    }];
}

//设置数据
- (void)setUpdata{
    __weak typeof(self)weakSelf = self;
    [self.networkViewModel.junkListCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
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
#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = self.dataSource[section];
    LoanerOrderModel *model = [LoanerOrderModel yy_modelWithJSON:dic];
    NSString *order_status = [NSString stringWithFormat:@"%@",model.order_status];
    if ([order_status isEqualToString:@"4"]) {
       return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.section];
    LoanerOrderModel *model = [LoanerOrderModel yy_modelWithJSON:dic];
    NSString *order_status = [NSString stringWithFormat:@"%@",model.order_status];
    if ([order_status isEqualToString:@"4"] && indexPath.row == 1) {
        ButtonCell*cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil]lastObject];
        }
        [cell.operationBut setTitle:@"重新甩单" forState:UIControlStateNormal];
        cell.operationBut.tag = indexPath.section;
        __weak typeof(self)weakSelf = self;
        [[cell.operationBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSDictionary *dic = self.dataSource[x.tag];
            LoanerOrderModel *model = [LoanerOrderModel yy_modelWithJSON:dic];
            NSString *Id = [NSString stringWithFormat:@"%@",model.Id];
            NSDictionary *dic1 = @{@"id":Id};
            [weakSelf.networkViewModel.junkAgainCommand execute:dic1];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        LoanerJiltInformationTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerJiltInformationTabCell" owner:self options:nil]lastObject];
        }
        [cell setUpData:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.section];
    LoanerOrderModel *model = [LoanerOrderModel yy_modelWithJSON:dic];
    NSString *order_status = [NSString stringWithFormat:@"%@",model.order_status];
    if ([order_status isEqualToString:@"4"]) {
        if (indexPath.row == 0) {
            return 261;
        }else{
            return 40;
        }
    }
    return 261;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.section];
    [self.clickSubject sendNext:[NSString stringWithFormat:@"%@",dic[@"id"]]];
}

- (LoanerJiltSingleNetWorkViewModel *)networkViewModel{
    if (!_networkViewModel) {
        _networkViewModel = [[LoanerJiltSingleNetWorkViewModel alloc]init];
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
