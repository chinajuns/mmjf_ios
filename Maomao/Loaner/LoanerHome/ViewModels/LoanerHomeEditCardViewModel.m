//
//  LoanerHomeEditCardViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerHomeEditCardViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "ButtonCell.h"
#import "LoanerCooperationTabCell.h"

static NSString *const identify2 = @"ButtonCell";
static NSString *const identify = @"ClientHomeInputBoxTabCell";
static NSString *const identify3 = @"LoanerCooperationTabCell";
@interface LoanerHomeEditCardViewModel()<UITableViewDelegate,UITableViewDataSource,ButtonDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong)UITableView *tableView;
@end
@implementation LoanerHomeEditCardViewModel

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
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        ClientHomeInputBoxTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeInputBoxTabCell" owner:self options:nil]lastObject];
        }
        cell.contentText.placeholder = @"请输入";
        cell.arrowimage.hidden = YES;
        cell.contentLine.constant = 15;
        if (indexPath.row == 0) {
            cell.contentText.keyboardType = UIKeyboardTypeDefault;
        }else if(indexPath.row == 1){
            cell.contentText.keyboardType = UIKeyboardTypeDecimalPad;
        }else{
            cell.contentText.keyboardType = UIKeyboardTypeASCIICapable;
        }
        cell.contentText.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1){
        LoanerCooperationTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerCooperationTabCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil]lastObject];
        }
        cell.delegate = self;
        [cell setUpData:@"提交" number:0 dict:@{@"tval":@"ss"} count:3];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 50;
    }else if (indexPath.section == 1){
        return 181;
    }else{
        return 100;
    }
    
}
@end
