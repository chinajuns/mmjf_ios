//
//  ClientHomeEvaluationTopViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeEvaluationTopViewModel.h"
#import "ClientEvaluationTabCell.h"

static NSString *const identify = @"ClientEvaluationTabCell";
@interface ClientHomeEvaluationTopViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
/**
 页数
 */
@property (nonatomic, assign)NSInteger pageCurrent;
//判断上下刷新
@property (nonatomic, assign)BOOL isUpDown;

@property (nonatomic, copy)NSString *Id;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation ClientHomeEvaluationTopViewModel

- (void)dealloc{
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //        self.clickSubject = [RACSubject subject];
        __weak typeof(self)weakSelf = self;
        [self.netWorkViewModel.evaluateCommand.executionSignals
         .switchToLatest subscribeNext:^(id  _Nullable x) {
             MMJF_Log(@"%@",x);
             if ([x isKindOfClass:[NSDictionary class]]) {
                 [weakSelf refresh:x];
             }else{
                 weakSelf.dataSource = [NSMutableArray array];
             }
             [weakSelf.tableView reloadData];
             [weakSelf.tableView.mj_footer endRefreshing];
             [weakSelf.tableView.mj_header endRefreshing];
         }];
    }
    return self;
}

- (void)setUpData:(NSDictionary *)dic{
    self.Id = dic[@"id"];
    self.type = dic[@"type"];
    [self.tableView.mj_header beginRefreshing];
}

//刷新
- (void)refresh:(NSDictionary *)dic{
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    __weak typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.pageCurrent = 1;
            weakSelf.isUpDown = NO;
            NSDictionary *dic = @{@"id":weakSelf.Id,@"page":[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent],@"type":weakSelf.type};
            [weakSelf.netWorkViewModel.evaluateCommand execute:dic];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.pageCurrent ++;
            weakSelf.isUpDown = YES;
            NSDictionary *dic = @{@"id":weakSelf.Id,@"page":[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent],@"type":weakSelf.type};
            [weakSelf.netWorkViewModel.evaluateCommand execute:dic];
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
    ClientEvaluationTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientEvaluationTabCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = self.dataSource[indexPath.row];
    ClientEvaluationModel *model = [ClientEvaluationModel yy_modelWithJSON:dic];
    [cell setUpData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (ClientHomeViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[ClientHomeViewModel alloc]init];
    }
    return _netWorkViewModel;
}
@end
