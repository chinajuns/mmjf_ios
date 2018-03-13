//
//  LoanerShareEditorViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerShareEditorViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "LoanerCooperationTabCell.h"
#import "LoanerStoreHeadPortraitTabCell.h"

static NSString *const identify = @"ClientHomeInputBoxTabCell";
static NSString *const identify3 = @"LoanerCooperationTabCell";
static NSString *const identify4 = @"LoanerStoreHeadPortraitTabCell";
@interface LoanerShareEditorViewModel()<UITableViewDelegate,UITableViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSArray *_titleArray;
}

@property (nonatomic, strong)UITableView *tableView;

@end
@implementation LoanerShareEditorViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        _titleArray = @[@"姓名",@"所在城市",@"机构名称",@"从业时间"];
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
    if (section == 1) {
        return _titleArray.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1){
        ClientHomeInputBoxTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeInputBoxTabCell" owner:self options:nil]lastObject];
        }
        
        if (indexPath.row == 0) {
            cell.contentText.placeholder = @"请输入";
            cell.arrowimage.hidden = YES;
            cell.contentLine.constant = 15;
            cell.contentText.keyboardType = UIKeyboardTypeDefault;
        }
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.contentText.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2){
        LoanerCooperationTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerCooperationTabCell" owner:self options:nil]lastObject];
        }
        cell.separatorInset = UIEdgeInsetsMake(0, MMJF_WIDTH, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        LoanerStoreHeadPortraitTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerStoreHeadPortraitTabCell" owner:self options:nil]lastObject];
        }
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0 || indexPath.section == 1) {
        return 50;
    }else{
        return 181;
    }
    
}
@end
