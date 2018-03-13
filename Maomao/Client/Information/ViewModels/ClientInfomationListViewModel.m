//
//  ClientInfomationListViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientInfomationListViewModel.h"

#import "ClientSubjectClassificationTabCell.h"
#import "ClientInfomationDetailsTabCell.h"
#import "ClientInfomationHeadView.h"
#import "ClientInfomationFooterTabCell.h"
#import "ClientBannerTabCell.h"

#import "SDCycleScrollView.h"

static NSString *const identity = @"ClientSubjectClassificationTabCell";
static NSString *const idnetify1 = @"ClientInfomationDetailsTabCell";
static NSString *const identify2 = @"ClientInfomationHeadView";
static NSString *const identify3 = @"ClientInfomationFooterTabCell";
static NSString *const identify4 = @"ClientBannerTabCell";
@interface ClientInfomationListViewModel()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, copy)NSArray *tops;
@property (nonatomic, copy)NSArray *middles;
@property (nonatomic, copy)NSArray *configs;
@property (nonatomic, copy)NSArray *lists;
@end
@implementation ClientInfomationListViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
    [self.listSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        self.listSubject = [RACSubject subject];
    }
    return self;
}

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"ClientInfomationHeadView" bundle:nil] forHeaderFooterViewReuseIdentifier:identify2];

}
//设置数据
- (void)setUpData:(id)data{
    self.tops = data[@"adver"][@"top"];
    self.middles = data[@"adver"][@"middle"];
    self.configs = data[@"adver"][@"config"];
    self.lists = data[@"list"];
    [self.tableView reloadData];
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.lists.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        NSArray *list = self.lists[section - 1][@"list"];
        if (self.lists.count == section) {
            return list.count;
        }
        return list.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ClientBannerTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientBannerTabCell" owner:self options:nil]lastObject];
            }
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MMJF_WIDTH, cell.backView.height) delegate:self placeholderImage:[UIImage imageNamed:@"banner-1"]];
            //            cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
            //            cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
            cycleScrollView.imageURLStringsGroup = self.tops;
            [cell.backView addSubview:cycleScrollView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ClientSubjectClassificationTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientSubjectClassificationTabCell" owner:self options:nil]lastObject];
            }
            __weak typeof(self)weakSelf = self;
            [[cell.dataBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (weakSelf.lists.count < 3) {
                    return ;
                }
                NSDictionary *dic = weakSelf.lists[2];
                [weakSelf.clickSubject sendNext:dic];
            }];
            [[cell.interestBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (weakSelf.lists.count < 2) {
                    return ;
                }
                NSDictionary *dic = weakSelf.lists[1];
                [weakSelf.clickSubject sendNext:dic];
            }];
            [[cell.financialBtu rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
                if (weakSelf.lists.count == 0) {
                    return ;
                }
                NSDictionary *dic = weakSelf.lists[0];
                [weakSelf.clickSubject sendNext:dic];
            }];
        
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        NSArray *list = self.lists[indexPath.section - 1][@"list"];
        if (indexPath.row == list.count) {
            ClientInfomationFooterTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientInfomationFooterTabCell" owner:self options:nil]lastObject];
            }
            NSString *str = [NSString stringWithFormat:@"%@",self.middles[indexPath.section%2][@"image"]];
            [cell.image sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:str]] placeholderImage:[UIImage imageNamed:@"banner-2"]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ClientInfomationDetailsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:idnetify1];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientInfomationDetailsTabCell" owner:self options:nil]lastObject];
            }
            NSDictionary *dic = list[indexPath.row];
            InformationListModel *model = [InformationListModel yy_modelWithJSON:dic];
            [cell setUpData:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 224;
        }
        return 160;
    }else{
        if (indexPath.row == 2) {
            return 123;
        }
        return 98;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ClientInfomationHeadView *headView = (ClientInfomationHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:identify2];
    headView.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = self.lists[section - 1];
    headView.titelLab.text = dic[@"cate_name"];
    __weak typeof(self)weakSelf = self;
    [[headView.clickbut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.clickSubject sendNext:dic];
    }];
    return headView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return 50;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section != 0) {
        
        NSArray *list = self.lists[indexPath.section - 1][@"list"];
        if (indexPath.row == list.count) {
            return;
        }
        NSDictionary *dic = list[indexPath.row];
        InformationListModel *model = [InformationListModel yy_modelWithJSON:dic];
        [self.listSubject sendNext:model];
    }
    
}

@end
