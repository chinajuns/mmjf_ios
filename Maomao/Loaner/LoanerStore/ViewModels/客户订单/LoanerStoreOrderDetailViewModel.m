//
//  LoanerStoreDetailViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreOrderDetailViewModel.h"
#import "LoanerStoreDetailHeadTabCell.h"
#import "ClientMineOrderStateDetailsTabCell.h"

static NSString *const identify1 = @"ClientMineOrderStateDetailsTabCell";
static NSString *const identify = @"LoanerStoreDetailHeadTabCell";
@interface LoanerStoreOrderDetailViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;


@end
@implementation LoanerStoreOrderDetailViewModel

- (instancetype)init {
self = [super init];
if (self) {
    //        self.clickSubject = [RACSubject subject];
    //        _titleArray = @[@"姓名",@"所在城市",@"机构名称",@"从业时间"];
}
return self;
}

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
}
//刷新
- (void)refresh{
    [self.tableView reloadData];
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.model.processHistory.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LoanerStoreDetailHeadTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerStoreDetailHeadTabCell" owner:self options:nil]lastObject];
        }
        [cell setUpData:self.model isRefer:self.isRefer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ClientMineOrderStateDetailsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineOrderStateDetailsTabCell" owner:self options:nil]lastObject];
        }
        NSDictionary *dic = self.model.processHistory[indexPath.row];
        ClientMineProcessingModel *model = [ClientMineProcessingModel yy_modelWithJSON:dic];
        cell.statrBut.selected = NO;
        if (indexPath.row == 0) {
            cell.topLine.hidden = YES;
            cell.statrBut.selected = YES;
            cell.statrBut.backgroundColor = [UIColor whiteColor];
        }else{
            cell.title.textColor = [UIColor colorWithHexString:@"#b3b3b3"];
        }
        if (indexPath.row == self.model.processHistory.count - 1){
            cell.bottomLine.hidden = YES;
        }
        [cell setUpData:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 400;
    }
    return 80;
    
}

@end
