//
//  LoanerAgentDetailViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerAgentDetailViewModel.h"
#import "LoanerAgentProductsTabCell.h"
#import "ApplicationRequirementsTabCell.h"
#import "RequiredMaterialTabCell.h"
#import "LoanerAgentBasicTabCell.h"

static NSString *const identify = @"LoanerAgentProductsTabCell";
static NSString *const identify1 = @"ApplicationRequirementsTabCell";
static NSString *const identify2 = @"RequiredMaterialTabCell";
static NSString *const identify3 = @"LoanerAgentBasicTabCell";
@interface LoanerAgentDetailViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic, copy)NSDictionary *dataDic;
/**
 (申请条件)
 */
@property (nonatomic, copy)NSArray *options;
/**
 所需材料
 */
@property (nonatomic, copy)NSString *need_data;

@end

@implementation LoanerAgentDetailViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        [self setUpData];
    }
    return self;
}

- (void)bindViewToViewModel:(UIView *)view {
    self.tableView = (UITableView *)view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 200;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView= [UIView new];
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        LoanerAgentProductsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerAgentProductsTabCell" owner:self options:nil]lastObject];
        }
        LoanerStoreProductModel *model = [LoanerStoreProductModel yy_modelWithJSON:self.dataDic];
        [cell setUpData:model];
        cell.agentBut.hidden = YES;
        cell.lien.constant = 180;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2){
        ApplicationRequirementsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ApplicationRequirementsTabCell" owner:self options:nil]lastObject];
        }
        cell.key1 = @"option_name";
        cell.key2 = @"option_values";
        [cell setUpdata:self.options];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.row == 1){
        LoanerAgentBasicTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerAgentBasicTabCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RequiredMaterialTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RequiredMaterialTabCell" owner:self options:nil]lastObject];
        }
        [cell setUpData:self.need_data];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 211;
    }else if (indexPath.row == 1){
        return 125;
    }
    else{
        return UITableViewAutomaticDimension;
    }
    
}
//设置数据
- (void)setUpData{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.detailCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        weakSelf.dataDic = x;
        weakSelf.options = x[@"options"];
        weakSelf.need_data = x[@"need_data"];
        [weakSelf.tableView reloadData];
    }];
    
}

- (LoanerStoreNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerStoreNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
}
@end
