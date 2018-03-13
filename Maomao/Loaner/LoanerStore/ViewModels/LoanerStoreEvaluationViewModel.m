//
//  LoanerStoreEvaluationViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreEvaluationViewModel.h"
#import "LoanerStoreEvaluationTabCell.h"
#import "ClientMineImpressionTabCell.h"
#import "ClientMineTextVeiwTabCell.h"
#import "ButtonCell.h"

static NSString *const identify = @"LoanerStoreEvaluationTabCell";
static NSString *const identify1 = @"ClientMineImpressionTabCell";
static NSString *const identify2 = @"ClientMineTextVeiwTabCell";
static NSString *const identify3 = @"ButtonCell";

@interface LoanerStoreEvaluationViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *selecteds;
@property (nonatomic, strong)UITableView *tableView;
/**
 标签s
 */
@property (nonatomic, copy)NSArray *tags;
@property (nonatomic, copy)NSArray *tagArray;
/**
 评分
 */
@property (nonatomic, copy)NSString *score;

/**
 输入框
 */
@property (nonatomic, copy)NSString *textStr;
@end
@implementation LoanerStoreEvaluationViewModel

- (void)dealloc{
    [self.orderCommentSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.orderCommentSubject = [RACSubject subject];
        self.selecteds = [NSMutableArray array];
        self.score = @"0";
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
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LoanerStoreEvaluationTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerStoreEvaluationTabCell" owner:self options:nil]lastObject];
        }
        [cell setUpStar:self.score];
        __weak typeof(self)weakSelf= self;
        [cell.starSubject subscribeNext:^(id  _Nullable x) {
            MMJF_Log(@"%@",x);
            weakSelf.score = x;
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        ClientMineImpressionTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineImpressionTabCell" owner:self options:nil]lastObject];
        }
        [cell setUptagListView:self.tags selecteds:self.selecteds];
        __weak typeof(self)weakSelf = self;
        [cell.arraySubject subscribeNext:^(id  _Nullable x) {
            [weakSelf.selecteds addObject:x];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
            [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [cell.removeSubject subscribeNext:^(id  _Nullable x) {
            [weakSelf.selecteds removeObject:x];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
            [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 2){
        ClientMineTextVeiwTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineTextVeiwTabCell" owner:self options:nil]lastObject];
        }
        [cell setUpText:@"信贷经理有哪些地方让你印象深刻？快分享一下" maxNumber:200 color:[UIColor whiteColor] fontSize:11 inputText:self.textStr];
        __weak typeof(cell)weakCell = cell;
        __weak typeof(self)weakSelf= self;
        cell.numberWordsLab.text = [NSString stringWithFormat:@"%ld/%d",self.textStr.length,200];
        // 设置文本框最大行
        [cell.input textValueDidChanged:^(NSString *text, CGFloat textHeight) {
            if (textHeight > 162) {
                CGRect frame = weakCell.input.frame;
                frame.size.height = textHeight;
                weakCell.input.frame = frame;
            }
            weakSelf.textStr = text;
            weakCell.numberWordsLab.text = [NSString stringWithFormat:@"%ld/%d",text.length,200];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil]lastObject];
        }
        if (self.selecteds.count == 0) {
            cell.operationBut.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
            cell.operationBut.userInteractionEnabled = NO;
        }else{
            cell.operationBut.backgroundColor = MMJF_COLOR_Yellow;
            cell.operationBut.userInteractionEnabled = YES;
        }
        __weak typeof(self)weakSelf = self;
        [[cell.operationBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSMutableArray *mut = [NSMutableArray array];
            for (int i = 0; i < weakSelf.tagArray.count; i ++) {
                NSDictionary *dic = weakSelf.tagArray[i];
                NSString *str1 = dic[@"label"];
                NSString *str2 = dic[@"id"];
                for (int j = 0; j < weakSelf.selecteds.count; j ++) {
                    NSString *str = weakSelf.selecteds[j];
                    if ([str isEqualToString:str1]) {
                        [mut addObject:str2];
                    }
                }
            }
            NSString *str3 = [mut componentsJoinedByString:@","];
            NSDictionary *dic;
            if (weakSelf.textStr) {
                dic = @{@"score":weakSelf.score,@"label_ids":str3,@"describe":weakSelf.textStr};
            }else{
                dic = @{@"score":weakSelf.score,@"label_ids":str3};
            }
            
            [weakSelf.orderCommentSubject sendNext:dic];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else if (indexPath.section == 1){
        return self.tags.count / 3 * 30 + (self.tags.count % 3 ? 30 : 0) + 90;
    }else if (indexPath.section == 2){
        return 185;
    }else{
        return 100;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 0;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, 40)];
    customView.backgroundColor = [UIColor colorWithRed:246.f/255.f green:246.f/255.f blue:246.f/255.f alpha:1];
    return customView;
}

//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}
//刷新标签
- (void)refreshTag:(NSArray *)array{
    NSMutableArray *mut = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        [mut addObject:dic[@"label"]];
    }
    self.tagArray = array;
    self.tags = mut.copy;
    [self.tableView reloadData];
}

@end
