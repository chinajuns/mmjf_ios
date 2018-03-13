//
//  ClientMineArticleCViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineArticleCViewModel.h"
#import "ClientInfomationDetailsTabCell.h"
#import "ClientHomeViewModel.h"
#import "InformationListModel.h"

static NSString *const idnetify = @"ClientInfomationDetailsTabCell";
@interface ClientMineArticleCViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
/**
 页数
 */
@property (nonatomic, assign)NSInteger pageCurrent;
//判断上下刷新
@property (nonatomic, assign)BOOL isUpDown;
@property (nonatomic, strong)ClientHomeViewModel *homeViewModel;

@property (nonatomic, strong)CQPlaceholderView *placeholderView;
@end
@implementation ClientMineArticleCViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        __weak typeof(self)weakSelf = self;
        
        [self.homeViewModel.favoriteListCommand.executionSignals.
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
        [self.homeViewModel.setFavoriteCommand.executionSignals
         .switchToLatest subscribeNext:^(id  _Nullable x) {
             [weakSelf refreshData];
         }];
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
            weakSelf.pageCurrent = 1;
            weakSelf.isUpDown = NO;
            NSDictionary *dic = @{@"dict":@{@"type":@"2"},@"page":[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent]};
            [weakSelf.homeViewModel.favoriteListCommand execute:dic];
        });
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.pageCurrent ++;
            weakSelf.isUpDown = YES;
            NSDictionary *dic = @{@"dict":@{@"type":@"2"},@"page":[NSString stringWithFormat:@"%ld",weakSelf.pageCurrent]};
            [weakSelf.homeViewModel.favoriteListCommand execute:dic];
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
    ClientInfomationDetailsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:idnetify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientInfomationDetailsTabCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = self.dataSource[indexPath.section];
    InformationListModel *model = [InformationListModel yy_modelWithJSON:dic];
    [cell setUpData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    NSDictionary *dic = self.dataSource[indexPath.section];
    InformationListModel *model = [InformationListModel yy_modelWithJSON:dic];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%@",model.object_id],@"type":@"2",@"action":@"cancel"};
        [self.homeViewModel.setFavoriteCommand execute:dic];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消收藏";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.section];
    InformationListModel *model = [InformationListModel yy_modelWithJSON:dic];
    [self.clickSubject sendNext:model];
}

//获取到数据刷新
- (void)refresh:(NSDictionary *)dict{
    [self.placeholderView remove];
    self.tableView.scrollEnabled = YES;
    if (self.isUpDown == NO) {
        self.dataSource = [NSMutableArray array];
    }
    NSString *str = dict[@"next_page_url"];
    if ([str isKindOfClass:[NSNull class]]) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    NSArray *array = dict[@"data"];
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

//进入刷新
- (void)refreshData{
    [self.tableView.mj_header beginRefreshing];
}

- (ClientHomeViewModel *)homeViewModel{
    if (!_homeViewModel) {
        _homeViewModel = [[ClientHomeViewModel alloc]init];
    }
    return _homeViewModel;
}

- (CQPlaceholderView *)placeholderView{
    if (!_placeholderView) {
        _placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, MMJF_WIDTH,self.tableView.height) type:MMJFPlaceholderViewTypeLoan delegate:self];
    }
    return _placeholderView;
}
@end
