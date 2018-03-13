//
//  LoanerJiltSingleDetailViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerJiltSingleDetailViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "LoanerCustomerGeneralTabCell.h"
#import "LoanerJiltSingleStateTabCell.h"//成功或失败
#import "LoanerCountdownTabCell.h"//进行中
#import "SingleLabTabCell.h"

#import "LoanerJiltjunkDetail.h"
#import "InfoModel.h"

static NSString *const identify2 = @"LoanerJiltSingleStateTabCell";
static NSString *const identify = @"ClientHomeInputBoxTabCell";
static NSString *const identify1 = @"LoanerCustomerGeneralTabCell";
static NSString *const identify3 = @"LoanerCountdownTabCell";
static NSString *const identify4 = @"SingleLabTabCell";
@interface LoanerJiltSingleDetailViewModel()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_basicArray;
    NSMutableArray *_workArray;
    NSMutableArray *_assetsArray;
    NSMutableArray *_mutBasicArray;
    NSMutableArray *_mutWorkArray;
    NSMutableArray *_mutassetsArray;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)LoanerJiltjunkDetail *model;
@end
@implementation LoanerJiltSingleDetailViewModel

- (void)dealloc{
    [self.endSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _basicArray = @[@"年龄",@"手机号码",@"婚姻情况"];
        _workArray = [NSMutableArray array];
        _assetsArray = [NSMutableArray array];
        _mutBasicArray = [NSMutableArray array];
        _mutWorkArray = [NSMutableArray array];
        _mutassetsArray = [NSMutableArray array];
        self.endSubject = [RACSubject subject];
    }
    return self;
}

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section == 5) {
        return 1;
    }else if (section == 2){
        return _basicArray.count;
    }else if (section == 3){
        return  _workArray.count;
    }else{
        return _assetsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *str = [NSString stringWithFormat:@"%@",self.model.junk_status];
        if ([str isEqualToString:@"2"]) {
            LoanerCountdownTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerCountdownTabCell" owner:self options:nil]lastObject];
            }
            __weak typeof(cell)weakCell = cell;
            __weak typeof(self)weakSelf = self;
            ///每秒回调一次
            [cell.countDown countDownWithPER_SECBlock:^{
                MMJF_Log(@"6");
                MMJF_Log(@"%@",[NSString ConvertStrToTime:weakSelf.model.expire_time]);
                [weakCell getNowTimeWithString:[NSString ConvertStrToTime1:weakSelf.model.expire_time]];
            }];
            [cell.endSubject subscribeNext:^(id  _Nullable x) {
                [weakSelf.endSubject sendNext:@""];
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            LoanerJiltSingleStateTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerJiltSingleStateTabCell" owner:self options:nil]lastObject];
            }
            [cell setUpState:self.model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section == 1){
        LoanerCustomerGeneralTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerCustomerGeneralTabCell" owner:self options:nil]lastObject];
        }
        [cell setUpData:self.model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 5){
        SingleLabTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SingleLabTabCell" owner:self options:nil]lastObject];
        }
        cell.contentLab.text = [NSString stringWithFormat:@"信息简介:%@",self.model.description1 ? self.model.description1 : @""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        ClientHomeInputBoxTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeInputBoxTabCell" owner:self options:nil]lastObject];
        }
        cell.arrowimage.hidden = YES;
        cell.contentLine.constant = 15;
        cell.contentText.enabled = NO;
        cell.contentText.textColor = [UIColor colorWithHexString:@"#1a1a1a"];
        cell.mandatoryLab.hidden = YES;
        if (indexPath.section == 2) {
            cell.titleLabel.text = _basicArray[indexPath.row];
            if (_mutBasicArray.count == _basicArray.count) {
                cell.contentText.text = _mutBasicArray[indexPath.row];
            }
        }else if (indexPath.section == 3){
            if (_workArray.count != 0) {
                cell.titleLabel.text = _workArray[indexPath.row];
                cell.contentText.text = _mutWorkArray[indexPath.row];
            }
        }else{
            if (_assetsArray.count != 0) {
                cell.titleLabel.text = _assetsArray[indexPath.row];
                cell.contentText.text = _mutassetsArray[indexPath.row];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *str = [NSString stringWithFormat:@"%@",self.model.junk_status];
        if ([str isEqualToString:@"2"]) {
            return 162;
        }else{
            return 65;
        }
    }else if (indexPath.section == 1){
        return 140;
    }
    else if (indexPath.section == 5){
        return UITableViewAutomaticDimension;
    }
    else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 8;
    }else if (section == 0 || section == 5){
        return 0;
    }
    else{
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, 40)];
    customView.backgroundColor = [UIColor colorWithRed:241.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, MMJF_WIDTH, 30)];
    label.font = [UIFont fontWithName:@"PingFang SC" size:13];
    label.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
    label.frame = CGRectMake(12, 5, MMJF_WIDTH, 30);
    if (section == 2) {
        label.text = @"基本信息:";
    }else if (section == 3){
        label.text = @"工作信息:";
    }else if (section == 4){
        label.text = @"资产信用信息:";
    }
    [customView addSubview:label];
    return customView;
}

- (void)refresh:(NSDictionary *)dict{
    _model = [LoanerJiltjunkDetail yy_modelWithJSON:dict];
    [_mutBasicArray addObject:_model.age];
    [_mutBasicArray addObject:_model.mobile];
    NSString *is_marry = [NSString stringWithFormat:@"%@",_model.is_marry];
    if ([is_marry isEqualToString:@"1"]) {
        [_mutBasicArray addObject:@"已婚"];
    }else{
        [_mutBasicArray addObject:@"未婚"];
    }
    NSArray *jobs = dict[@"job"];
    for (int i = 0; i < jobs.count; i ++) {
        NSDictionary *dic = jobs[i];
        InfoModel *model = [InfoModel yy_modelWithJSON:dic];
        [_mutWorkArray addObject:model.attr_value];
        [_workArray addObject:model.attr_key];
    }
    NSArray *assets = dict[@"assets"];
    for (int i = 0; i < assets.count; i ++) {
        NSDictionary *dic = assets[i];
        InfoModel *model = [InfoModel yy_modelWithJSON:dic];
        [_mutassetsArray addObject:model.attr_value];
        [_assetsArray addObject:model.attr_key];
    }
    [self.tableView reloadData];
}

- (NSString *)age:(NSString *)ageStr{
    //计算年龄
    NSString *birth = ageStr;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birth];
    //当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
//    NSLog(@"currentDate %@ birthDay %@",currentDateStr,birth);
    NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
    int age = ((int)time)/(3600*24*365);
    MMJF_Log(@"year %d",age);
    return [NSString stringWithFormat:@"%d",age];
}
@end
