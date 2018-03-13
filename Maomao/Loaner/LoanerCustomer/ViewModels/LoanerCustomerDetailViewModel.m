//
//  LoanerCustomerDetailViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerCustomerDetailViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "LoanerCustomerGeneralTabCell.h"
#import "SingleLabTabCell.h"
#import "InfoModel.h"

static NSString *const identify = @"ClientHomeInputBoxTabCell";
static NSString *const identify1 = @"LoanerCustomerGeneralTabCell";
static NSString *const identify2 = @"SingleLabTabCell";
@interface LoanerCustomerDetailViewModel()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_basicArray;
    NSMutableArray *_mutBasicArray;
    NSMutableArray *_workArray;
    NSMutableArray *_mutWorkArray;
    NSMutableArray *_assetsArray;
    NSMutableArray *_mutAssetsArray;
}

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)CustomerDetailModel *model;
@end
@implementation LoanerCustomerDetailViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _basicArray = @[@"年龄",@"手机号码",@"婚姻情况"];
        
    }
    return self;
}

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 4) {
        return 1;
    }else if (section == 1){
        return _basicArray.count;
    }else if (section == 2){
        return  _workArray.count;
    }else{
        return _assetsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LoanerCustomerGeneralTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerCustomerGeneralTabCell" owner:self options:nil]lastObject];
        }
        [cell setUpDetaiData:self.model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 4){
        SingleLabTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SingleLabTabCell" owner:self options:nil]lastObject];
        }
        cell.separatorInset = UIEdgeInsetsMake(0, MMJF_WIDTH, 0, 0);
        cell.contentLab.text = [NSString stringWithFormat:@"信息简述%@",@""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        ClientHomeInputBoxTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeInputBoxTabCell" owner:self options:nil]lastObject];
        }
        cell.mandatoryLab.hidden = YES;
        cell.arrowimage.hidden = YES;
        cell.contentLine.constant = 15;
        cell.contentText.enabled = NO;
        cell.contentText.textColor = [UIColor colorWithHexString:@"#1a1a1a"];
        if (indexPath.section == 1) {
            cell.titleLabel.text = _basicArray[indexPath.row];
            if (_mutBasicArray.count != 0) {
                cell.contentText.text = _mutBasicArray[indexPath.row];
            }
        }else if (indexPath.section == 2){
            if (_workArray.count != 0) {
                cell.titleLabel.text = _workArray[indexPath.row];
                cell.contentText.text = _mutWorkArray[indexPath.row];
            }
        }else{
            if (_assetsArray.count != 0) {
                cell.titleLabel.text = _assetsArray[indexPath.row];
                cell.contentText.text = _mutAssetsArray[indexPath.row];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 140;
    }else if (indexPath.section == 4){
        return UITableViewAutomaticDimension;
    }
    else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }else if (section == 4){
        return 0;
    }
    else{
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, 40)];
    customView.backgroundColor = [UIColor colorWithRed:241.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1];
    if (section == 4) {
        return customView;
    }else{
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, MMJF_WIDTH, 30)];
        label.font = [UIFont fontWithName:@"PingFang SC" size:13];
        label.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
        label.frame = CGRectMake(12, 5, MMJF_WIDTH, 30);
        if (section == 1) {
            label.text = @"基本信息:";
        }else if (section == 2){
            label.text = @"工作信息:";
        }else if (section == 3){
            label.text = @"资产信用信息:";
        }
        [customView addSubview:label];
        return customView;
    }
}

- (void)refresh:(NSDictionary *)dict{
    _mutBasicArray = [NSMutableArray array];
    _workArray = [NSMutableArray array];
    _assetsArray = [NSMutableArray array];
    _mutWorkArray = [NSMutableArray array];
    _mutAssetsArray = [NSMutableArray array];
    self.model = [CustomerDetailModel yy_modelWithJSON:dict];
    NSArray *assets = dict[@"assets"];
    for (NSDictionary *dic in assets) {
        InfoModel *model = [InfoModel yy_modelWithJSON:dic];
        [_assetsArray addObject:model.attr_key];
        [_mutAssetsArray addObject:model.attr_value];
    }
    NSArray *job = dict[@"job"];
    for (NSDictionary *dic in job) {
        InfoModel *model = [InfoModel yy_modelWithJSON:dic];
        [_workArray addObject:model.attr_key];
        [_mutWorkArray addObject:model.attr_value];
    }
    NSDictionary *dic1 = dict[@"basic"];
    [_mutBasicArray addObject:[NSString stringWithFormat:@"%@",dic1[@"age"]]];
    [_mutBasicArray addObject:dic1[@"mobile"]];
    NSString *is_marry = [NSString stringWithFormat:@"%@",dic1[@"is_marry"]];
    if ([is_marry isEqualToString:@"0"]) {
        [_mutBasicArray addObject:@"未婚"];
    }else{
        [_mutBasicArray addObject:@"已婚"];
    }
    [self.tableView reloadData];
}
@end
