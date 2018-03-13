//
//  LoanerAgentSearchViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerAgentSearchViewModel.h"
#import "LoanerStoreProductModel.h"
@interface LoanerAgentSearchViewModel()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSArray *dataSouce;
@property (nonatomic, strong)CQPlaceholderView *placeholderView;
@end
@implementation LoanerAgentSearchViewModel

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

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = @"aadad";
    NSDictionary *dic = self.dataSouce[indexPath.row];
    LoanerStoreProductModel *model = [LoanerStoreProductModel yy_modelWithJSON:dic];
    cell.textLabel.text = model.cate_name;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#1a1a1a"];
    cell.textLabel.font = [UIFont fontWithName:@"PingFang SC" size:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}

- (void)placeholderPic{
    self.dataSouce = nil;
    self.tableView.scrollEnabled = NO;
    [self.tableView addSubview:self.placeholderView];
}

/** 占位图的重新加载按钮点击时回调 */
- (void)placeholderView:(CQPlaceholderView *)placeholderView{
    [placeholderView remove];
    switch (placeholderView.type) {
        case MMJFPlaceholderViewTypeLoan:  // 没数据
        {
            
        }
            break;
            
        default:
            break;
    }
}

//刷新
- (void)refresh:(NSArray *)cate{
    [self.placeholderView remove];
    self.dataSouce = cate;
    if (cate.count == 0) {
        [self placeholderPic];
    }
    [self.tableView reloadData];
}

- (CQPlaceholderView *)placeholderView{
    if (!_placeholderView) {
        _placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, MMJF_WIDTH,self.tableView.height) type:MMJFPlaceholderViewTypeLoan delegate:self];
    }
    return _placeholderView;
}
@end
