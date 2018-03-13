//
//  ClientDisclpseListViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientDisclpseListViewModel.h"
#import "ClientHomeListCardView.h"
#import "ClientHomeDiscloseTabCell.h"

static NSString *const identify = @"ClientHomeDiscloseTabCell";
@interface ClientDisclpseListViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *selectArray;

@property (nonatomic, strong)ClientQuickApplyModel *model;
@property (nonatomic, copy)NSArray *dataArray;
@end

@implementation ClientDisclpseListViewModel

- (void)dealloc{
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.clickSubject = [RACSubject subject];
        self.selectArray = [NSMutableArray array];
        [self.selectArray addObject:@""];
        [self.selectArray addObject:@""];
    }
    return self;
}

- (void)bindViewToViewModel:(UIView *)view {
    self.tableView = (UITableView *)view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView= [UIView new];
    NSDictionary *dic = @{@"id":[NSString stringWithFormat:@"%@",self.model.Id]};
    [self.recommendCommand execute:dic];
}

- (void)setUpData:(ClientQuickApplyModel *)model{
    self.model = model;
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ClientHomeDiscloseTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeDiscloseTabCell" owner:self options:nil]lastObject];
        }
        [cell setUpdata:self.model.mobile];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
        }
        ClientHomeListCardView *card = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeListCardView" owner:self options:nil] lastObject];
        card.frame = CGRectMake(15, 4, cell.contentView.width - 30, cell.contentView.height - 8);
        cell.contentView.backgroundColor = [UIColor colorWithRed:241.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1];
        [cell.contentView addSubview:card];
        card.selectIdBut.hidden = NO;
        NSString *str = self.selectArray[indexPath.row];
        if (str.length != 0) {
            card.selectIdBut.selected = YES;
        }else{
            card.selectIdBut.selected = NO;
        }
        NSDictionary *dic = self.dataArray[indexPath.row];
        [card setUpdata:dic];
        __weak typeof(self)weakSelf =self;
        __weak typeof(card)weakCard = card;
        [[card.cardClick rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (!weakCard.selectIdBut.selected) {
                [weakSelf.selectArray setObject:[NSString stringWithFormat:@"%@",dic[@"id"]] atIndexedSubscript:indexPath.row];
            }else{
                [weakSelf.selectArray setObject:@"" atIndexedSubscript:indexPath.row];
                
            }
            weakCard.selectIdBut.selected = !weakCard.selectIdBut.selected;
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 203;
    }else{
        return 170;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }else{
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, 40)];
    customView.backgroundColor = [UIColor colorWithRed:241.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1];
    if (section == 1) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, MMJF_WIDTH, 30)];
        label.font = [UIFont fontWithName:@"PingFang SC" size:11];
        label.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
        label.frame = CGRectMake(12, 5, MMJF_WIDTH, 30);
        label.text = @"根据您的需求，为您匹配了2个优质信贷经理";
        [customView addSubview:label];
    }
    return customView;
}

- (NSString *)getData{
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSString *str in self.selectArray) {
        if (str.length != 0) {
            [mutArray addObject:str];
        }
    }
     NSString *str = [mutArray.copy componentsJoinedByString:@","];
    return str;
}

//推荐贷款
- (RACCommand *)recommendCommand{
    if (!_recommendCommand) {
        _recommendCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientRecommend:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    [MBProgressHUD showSuccess:baseModel.msg];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    if (![baseModel.msg isEqualToString:@"已取消"]) {
                        [MBProgressHUD showError:baseModel.msg];
                    }
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    __weak typeof(self)weakSelf = self;
    [_recommendCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        weakSelf.dataArray = x;
        [weakSelf.tableView reloadData];
    }];
    return _recommendCommand;
}

@end
