//
//  LoanerMineViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerMineViewModel.h"
#import "ClientMineHeadTablCell.h"
#import "LoanerMineMoreTabCell.h"
#import "LoanerMineTabCell.h"

static NSString *const identify = @"ClientMineHeadTablCell";
static NSString *const identify1 = @"LoanerMineMoreTabCell";
static NSString *const identify2 = @"LoanerMineTabCell";
@interface LoanerMineViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@end
@implementation LoanerMineViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
    }
    return self;
}

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self)weakSelf = self;
    if (indexPath.section == 0) {
        ClientMineHeadTablCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineHeadTablCell" owner:self options:nil]lastObject];
        }
        cell.loansLab.hidden = cell.counterLab.hidden = YES;
        cell.rightBut.hidden = cell.leftBut.hidden = YES;
        [[cell.headBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:@"7"];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 1){
        LoanerMineMoreTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerMineMoreTabCell" owner:self options:nil]lastObject];
        }
        __weak typeof(self)weakSelf = self;
        [cell.clickSubject subscribeNext:^(id  _Nullable x) {
            [weakSelf.clickSubject sendNext:x];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        LoanerMineTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerMineTabCell" owner:self options:nil]lastObject];
        }
        
        [[cell.clickBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:@"6"];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 264;
    }else if(indexPath.section == 1){
        return 320;
    }else{
        return 50;
    }
}


- (void)top{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)refresh{
    [self.tableView reloadData];
}
@end
