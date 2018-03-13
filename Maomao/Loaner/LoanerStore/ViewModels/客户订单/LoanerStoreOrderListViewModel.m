//
//  LoanerStoreOrderListViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreOrderListViewModel.h"
#import "LoanerStoreOrderTabCell.h"

static NSString *const identify = @"LoanerStoreOrderTabCell";
@interface LoanerStoreOrderListViewModel()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
//判断上下刷新
@property (nonatomic, assign)BOOL isUpDown;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)CQPlaceholderView *placeholderView;
@end
@implementation LoanerStoreOrderListViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
    [self.butClickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        self.butClickSubject = [RACSubject subject];
        [self setUpdata];
    }
    return self;
}

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.isUpDown = NO;
            NSDictionary *dic;
            NSString *str;
            if (weakSelf.number == 0) {
                str = @"";
            }else{
                str = [NSString stringWithFormat:@"%ld",weakSelf.number - 1];
            }
            if (weakSelf.isRefer == YES) {
                dic = @{@"status":str,@"refer":@"customer"};
            }else{
                dic = @{@"status":str,@"refer":@"junk"};
            }
            [weakSelf.netWorkViewModel.shopOrderCommand execute:dic];
        });
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.isUpDown = YES;
            NSDictionary *dic;
            NSString *str;
            if (weakSelf.number == 0) {
                str = @"";
            }else{
                str = [NSString stringWithFormat:@"%ld",weakSelf.number - 1];
            }
            if (weakSelf.isRefer == YES) {
                dic = @{@"status":str,@"refer":@"customer",@"create_time":weakSelf.create_time};
            }else{
                dic = @{@"status":str,@"refer":@"junk",@"create_time":weakSelf.create_time};
            }
            [weakSelf.netWorkViewModel.shopOrderCommand execute:dic];
        });
    }];
}

//设置数据
- (void)setUpdata{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.shopOrderCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        if ([x isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)x;
            if (array.count == 0) {
                if (weakSelf.isUpDown == NO) {
                    [weakSelf placeholderPic];
                    [weakSelf.tableView reloadData];
                }
            }else{
               [weakSelf refresh:x];
            }
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LoanerStoreOrderTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerStoreOrderTabCell" owner:self options:nil]lastObject];
    }
    __weak typeof(self)weakSelf = self;
    [[cell.evaluationBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSDictionary *dic = self.dataSource[indexPath.section];
        [weakSelf.butClickSubject sendNext:dic];
    }];
    if (self.isRefer == YES) {
        cell.integralLine.constant = 0;
        cell.integralView.hidden = YES;
    }
    
    NSDictionary *dic = self.dataSource[indexPath.section];
    LoanerOrderModel *model = [LoanerOrderModel yy_modelWithJSON:dic];
    
    [cell setUpData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.section];
    NSString *process = [NSString stringWithFormat:@"%@",dic[@"process"]];
    NSString *is_comment = [NSString stringWithFormat:@"%@",dic[@"is_comment"]];
    if ([process isEqualToString:@"37"] || [process isEqualToString:@"38"]) {
        if ([is_comment isEqualToString:@"2"]) {
            return 370;
        }else{
            return 410;
        }
    }else{
        return 370;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.section];
    [self.clickSubject sendNext:dic];
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
