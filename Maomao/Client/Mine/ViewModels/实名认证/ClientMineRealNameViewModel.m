//
//  ClientMineRealNameViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineRealNameViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "ButtonCell.h"
#import "PopUpWindowViewModel.h"

static NSString *const identify1 = @"ButtonCell";
static NSString *const identify = @"ClientHomeInputBoxTabCell";
@interface ClientMineRealNameViewModel()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableDictionary *mutDict;
@property (nonatomic, copy)NSArray *titleArray;
/**
 弹窗
 */
@property (nonatomic, strong)PopUpWindowViewModel *popUpWindowViewModel;
@end

@implementation ClientMineRealNameViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        self.titleArray = @[@"真实姓名",@"地址",@"身份证号"];
        self.mutDict = [NSMutableDictionary dictionary];
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
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil]lastObject];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell setUpData:@"下一步" number:0 dict:self.mutDict count:3];
        __weak typeof(self)weakSelf = self;
        [[cell.operationBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:weakSelf.mutDict];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ClientHomeInputBoxTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeInputBoxTabCell" owner:self options:nil]lastObject];
        }
        cell.mandatoryLab.hidden = YES;
        cell.titleLabel.text = self.titleArray[indexPath.row];
        if (indexPath.row != 1) {
            cell.arrowimage.hidden = YES;
            cell.contentLine.constant = 15;
            cell.contentText.placeholder = @"请输入";
        }
        if (indexPath.row == 2) {
            cell.contentText.keyboardType = UIKeyboardTypeASCIICapable;
        }
        NSDictionary *dic = [_mutDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        cell.contentText.text = dic[@"name"];
        cell.contentText.tag = indexPath.row;
        cell.contentText.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return 180;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * customView = [[UIView alloc]init];
    customView.backgroundColor = MMJF_COLOR_Gray;
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    return 10;
}

//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}


#pragma mark--UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 0 || textField.tag == 2) {
        return YES;
    }
    [self.popUpWindowViewModel appearClick:0.65 control:2 number:textField.tag dataArray:nil titleStr:@"行政区域"];
    __weak typeof(self)weakSelf = self;
    [[weakSelf.popUpWindowViewModel.popUpWindowView.determineBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSDictionary *dic = weakSelf.popUpWindowViewModel.selectedDic;
        [weakSelf.popUpWindowViewModel exitClick];
        [weakSelf.mutDict setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
        [weakSelf.tableView reloadData];
    }];
    [self.tableView endEditing:YES];
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([NSString hasEmoji:textField.text] || [NSString stringContainsEmoji:textField.text]) {
        [MBProgressHUD showError:@"不支持输入表情"];
        return;
    }
    NSDictionary *dic = @{@"name":textField.text};
    if (textField.tag == 2) {
        if (![CManager validateIdentityCard:textField.text]) {
            [MBProgressHUD showError:@"身份证号码不正确"];
            [_tableView reloadData];
            return;
        }
    }
    [_mutDict setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
    [_tableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //不支持系统表情的输入
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        [MBProgressHUD showError:@"不支持输入表情"];
        return NO;
    }
    return YES;
}

- (PopUpWindowViewModel *)popUpWindowViewModel{
    if (!_popUpWindowViewModel) {
        _popUpWindowViewModel = [[PopUpWindowViewModel alloc]init];
    }
    return _popUpWindowViewModel;
}
@end
