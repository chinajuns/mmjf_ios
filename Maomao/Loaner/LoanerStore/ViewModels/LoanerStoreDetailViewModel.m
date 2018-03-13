//
//  LoanerStoreDetailViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreDetailViewModel.h"
#import "LoanerStoreHeadTabCell.h"
#import "LoanerStoreFunctionTabCell.h"
#import "LoanerJiltInformationTabCell.h"
#import "LoanerStoreNoDataTabCell.h"

static NSString *const identify3 = @"LoanerStoreNoDataTabCell"; //268
static NSString *const identify2 = @"LoanerJiltInformationTabCell";
static NSString *const identify1 = @"LoanerStoreFunctionTabCell";
static NSString *const identify = @"LoanerStoreHeadTabCell";
@interface LoanerStoreDetailViewModel()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSArray *dataArray;
@end
@implementation LoanerStoreDetailViewModel

- (void)dealloc{
    [self.slidingSubject sendCompleted];
    [self.clickSubject sendCompleted];
    [self.storeDetailSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.slidingSubject = [RACSubject subject];
        self.clickSubject = [RACSubject subject];
        self.storeDetailSubject = [RACSubject subject];
//        _titleArray = @[@"姓名",@"所在城市",@"机构名称",@"从业时间"];
    }
    return self;
}

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
//刷新
- (void)refresh:(NSArray *)dataArray{
    self.dataArray = dataArray;
    [self.tableView reloadData];
}
#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            LoanerStoreHeadTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerStoreHeadTabCell" owner:self options:nil]lastObject];
            }
            [cell setUpData:self.model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            LoanerStoreFunctionTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1 ];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerStoreFunctionTabCell" owner:self options:nil]lastObject];
            }
            __weak typeof(self)weakSelf = self;
            __weak typeof(cell)weakCell = cell;
            [weakCell.clickSubject subscribeNext:^(id  _Nullable x) {
                [weakSelf.clickSubject sendNext:x];
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        LoanerJiltInformationTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerJiltInformationTabCell" owner:self options:nil]lastObject];
        }
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.lien.constant = 0;
        cell.integralView.hidden = YES;
        LoanerOrderModel *model = [LoanerOrderModel yy_modelWithJSON:dic];
        [cell setUpData:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
            return 337;
        }
        return 110;
    }else{
        return 261;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 && self.dataArray.count != 0) {
        return 30;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, 30)];
    customView.backgroundColor = [UIColor colorWithRed:246.f/255.f green:246.f/255.f blue:246.f/255.f alpha:1];
    if (section == 1 && self.dataArray.count != 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, MMJF_WIDTH, 30)];
        label.font = [UIFont fontWithName:@"PingFang SC" size:13];
        label.textColor = [UIColor colorWithHexString:@"#b3b3b3"];
        label.frame = CGRectMake(12, 5, MMJF_WIDTH, 30);
        label.text = @"近期申请";
        [customView addSubview:label];
    }
    return customView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    [self.storeDetailSubject sendNext:dic];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.slidingSubject sendNext:[NSString stringWithFormat:@"%f",scrollView.contentOffset.y]];
    
}
@end
