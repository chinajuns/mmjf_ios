//
//  ClientMineOrderDetailsViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/6.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineOrderDetailsViewModel.h"
#import "ClientMineOrderStateDetailsTabCell.h"

static NSString *const identify = @"ClientMineOrderStateDetailsTabCell";
@interface ClientMineOrderDetailsViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, copy)NSArray *dataSource;
@end
@implementation ClientMineOrderDetailsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.clickSubject = [RACSubject subject];
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

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClientMineOrderStateDetailsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineOrderStateDetailsTabCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic = self.dataSource[indexPath.section];
    ClientMineProcessingModel *model = [ClientMineProcessingModel yy_modelWithJSON:dic];
    if (indexPath.section == 0) {
        cell.topLine.hidden = YES;
    }
    cell.statrBut.selected = NO;
    if (indexPath.section == self.dataSource.count - 1){
        cell.bottomLine.hidden = YES;
        cell.statrBut.selected = YES;
        cell.statrBut.backgroundColor = [UIColor whiteColor];
    }
    [cell setUpData:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void)setUpData:(NSArray *)array{
    self.dataSource = array;
    [self.tableView reloadData];
}

@end
