//
//  ClientMineOrdereEvaluationViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineOrdereEvaluationViewModel.h"
#import "ClientMineComprehensiveTabCell.h"
#import "ClientMineImpressionTabCell.h"
#import "ClientMineTextVeiwTabCell.h"
#import "ButtonCell.h"

static NSString *const identify = @"ClientMineComprehensiveTabCell";
static NSString *const identify1 = @"ClientMineImpressionTabCell";
static NSString *const identify2 = @"ClientMineTextVeiwTabCell";
static NSString *const identify3 = @"ButtonCell";
@interface ClientMineOrdereEvaluationViewModel()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSArray *types;
@property (nonatomic, strong)NSArray *focuss;

@property (nonatomic, copy)NSArray *focussAll;
/**
 订单id
 */
@property (nonatomic, copy)NSString *orderId;
/**
 打分
 */
@property (nonatomic, copy)NSString *score;
@property (nonatomic, strong)NSMutableArray *selecteds;
@property (nonatomic, copy)NSString *input;
@property (nonatomic, copy)NSString *textStr;
@end
@implementation ClientMineOrdereEvaluationViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.clickSubject = [RACSubject subject];
        self.selecteds = [NSMutableArray array];
        self.input = @"";
        
    }
    return self;
}

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setUpNetwork];
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
        ClientMineComprehensiveTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineComprehensiveTabCell" owner:self options:nil]lastObject];
        }
        [cell setUpData:self.types];
        __weak typeof(self)weakSelf = self;
        [cell.starsSubject subscribeNext:^(NSDictionary *x) {
            MMJF_Log(@"%@",x);
            weakSelf.score = [weakSelf convertToJsonData:x];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        ClientMineImpressionTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineImpressionTabCell" owner:self options:nil]lastObject];
        }
        [cell setUptagListView:self.focuss selecteds:self.selecteds];
        __weak typeof(self)weakSelf = self;
        [cell.arraySubject subscribeNext:^(id  _Nullable x) {
            
            [weakSelf.selecteds addObject:x];
        }];
        [cell.removeSubject subscribeNext:^(id  _Nullable x) {
            [weakSelf.selecteds removeObject:x];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 2){
        ClientMineTextVeiwTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineTextVeiwTabCell" owner:self options:nil]lastObject];
        }
        cell.colorView.backgroundColor = [UIColor whiteColor];
        cell.input.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
        [cell setUpText:@"信贷经理有哪些地方让你印象深刻？快分享一下" maxNumber:200 color:[UIColor whiteColor] fontSize:11 inputText:self.textStr];
        __weak typeof(self)weakSelf = self;
        __weak typeof(cell)weakcell = cell;
        cell.numberWordsLab.text = [NSString stringWithFormat:@"%ld/%d",self.textStr.length,200];
        // 设置文本框最大行
        [cell.input textValueDidChanged:^(NSString *text, CGFloat textHeight) {
            if (textHeight > 162) {
                CGRect frame = weakcell.input.frame;
                frame.size.height = textHeight;
                weakcell.input.frame = frame;
            }
            weakSelf.textStr = text;
            weakcell.numberWordsLab.text = [NSString stringWithFormat:@"%ld/%d",text.length,200];
            weakSelf.input = text;
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil]lastObject];
        }
        [cell.operationBut setTitle:@"提交" forState:UIControlStateNormal];
        __weak typeof(self)weakSelf = self;
        [[cell.operationBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSMutableArray *mutArray = [NSMutableArray array];
            for (int i = 0; i < weakSelf.focussAll.count; i ++) {
                NSDictionary *dic = weakSelf.focussAll[i];
                NSString *str = dic[@"attr_value"];
                for (int j = 0; j < weakSelf.selecteds.count; j ++) {
                    NSString *str1 = weakSelf.selecteds[j];
                    if ([str isEqualToString:str1]) {
                        [mutArray addObject:dic[@"id"]];
                    }
                }
            }
            NSString *str = [mutArray componentsJoinedByString:@","];
            if (str.length == 0) {
                [MBProgressHUD showError:@"印象不能为空"];
                return;
            }
            NSDictionary *dic = @{@"id":weakSelf.orderId,@"comment":weakSelf.input,@"focus":str,@"score":weakSelf.score};
            [weakSelf.networkViewModel.userAddScoreCommand execute:dic];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 183;
    }else if (indexPath.section == 1){
        return 180;
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
    customView.backgroundColor = [UIColor colorWithRed:241.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1];
    return customView;
}
//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}

//设置网络请求
- (void)setUpNetwork{
    [self.networkViewModel.scoreTypeCommand execute:nil];
}
//刷新
- (void)refresh:(NSDictionary *)dic orderid:(NSString *)orderId{
    self.types = dic[@"type"];
    NSDictionary *dic1 = @{[NSString stringWithFormat:@"%@",self.types[0][@"id"]]:@"5.0",[NSString stringWithFormat:@"%@",self.types[1][@"id"]]:@"5.0",[NSString stringWithFormat:@"%@",self.types[2][@"id"]]:@"5.0"};
    self.score = [self convertToJsonData:dic1];
    self.orderId = orderId;
    self.focussAll = dic[@"focus"];
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSDictionary *dic in self.focussAll) {
        [mutArray addObject:dic[@"attr_value"]];
    }
    self.focuss = mutArray;
    [self.tableView reloadData];
}

- (ClientMineNetworkViewModel *)networkViewModel{
    if (!_networkViewModel) {
        _networkViewModel = [[ClientMineNetworkViewModel alloc]init];
    }
    return _networkViewModel;
}
@end
