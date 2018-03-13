//
//  LoanerMineCertificationViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerMineCertificationViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "ButtonCell.h"
#import "LoanerCooperationTabCell.h"
#import "LoanerStoreHeadPortraitTabCell.h"
#import "PopUpWindowViewModel.h"

static NSString *const identify2 = @"ButtonCell";
static NSString *const identify = @"ClientHomeInputBoxTabCell";
static NSString *const identify3 = @"LoanerCooperationTabCell";
static NSString *const identify4 = @"LoanerStoreHeadPortraitTabCell";
@interface LoanerMineCertificationViewModel()<UITableViewDataSource,UITableViewDelegate,ButtonDelegate,UITextFieldDelegate>{
    NSArray *_titleArray;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableDictionary *mutDict;
/**
 弹窗
 */
@property (nonatomic, strong)PopUpWindowViewModel *popUpWindowViewModel;
@end
@implementation LoanerMineCertificationViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        _titleArray = @[@"姓名",@"身份证号",@"所在区域",@"机构类型",@"机构名称",@"所属部门"];
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
        cell.mandatoryLab.hidden = YES;
        cell.contentText.tag = indexPath.row;
        if (indexPath.row > 1 && indexPath.row < 4) {
            cell.arrowimage.hidden = NO;
            cell.contentLine.constant = 22;
        }else{
            cell.contentText.placeholder = @"请输入";
            cell.arrowimage.hidden = YES;
            cell.contentLine.constant = 15;
            if (indexPath.row == 1) {
                cell.contentText.keyboardType = UIKeyboardTypeASCIICapable;
            }else{
                cell.contentText.keyboardType = UIKeyboardTypeDefault;
            }
        }
        NSDictionary *dic = [_mutDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        cell.contentText.text = dic[@"name"];
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.contentText.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 0){
        LoanerStoreHeadPortraitTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerStoreHeadPortraitTabCell" owner:self options:nil]lastObject];
        }
        cell.titleLab.text = @"免冠照片";
        if (self.img) {
            cell.headerimg.image = self.img;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil]lastObject];
        }
        [cell setUpData:@"下一步" number:0 dict:self.mutDict count:7];
        __weak typeof(self)weakSelf = self;
        [[cell.operationBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:weakSelf.mutDict];
        }];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0 || indexPath.section == 1) {
        return 50;
    }else{
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.clickSubject sendNext:@"0"];
    }
    
}

//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}

#pragma mark--UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.tableView endEditing:YES];
    if (textField.tag == 2) {
        [self.popUpWindowViewModel appearClick:0.65 control:2 number:textField.tag dataArray:nil titleStr:@"行政区域"];
       
    }else if (textField.tag == 3){
        NSDictionary *dic1 = @{@"id":@"",@"name":@"银行",@"pid":@""};
        NSDictionary *dic2 = @{@"id":@"",@"name":@"小贷公司",@"pid":@""};
        NSDictionary *dic3 = @{@"id":@"",@"name":@"投资资讯",@"pid":@""};
        NSDictionary *dic4 = @{@"id":@"",@"name":@"其他",@"pid":@""};
        NSArray *array = @[dic1,dic2,dic3,dic4];
        [self.popUpWindowViewModel appearClick:0.65 control:0 number:textField.tag dataArray:array titleStr:@"请选择"];
    }else{
        return YES;
    }
    __weak typeof(self)weakSelf = self;
    [[weakSelf.popUpWindowViewModel.popUpWindowView.determineBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSDictionary *dic = weakSelf.popUpWindowViewModel.selectedDic;
        [weakSelf.popUpWindowViewModel exitClick];
        [weakSelf.mutDict setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
        [weakSelf.tableView reloadData];
    }];
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([NSString hasEmoji:textField.text] || [NSString stringContainsEmoji:textField.text]) {
        [MBProgressHUD showError:@"不支持输入表情"];
        return;
    }
    if (textField.tag == 1) {
        if (![CManager validateIdentityCard:textField.text]) {
            [MBProgressHUD showError:@"请填写正确的身份证号码"];
            [_tableView reloadData];
            return;
        }
    }
    NSDictionary *dic = @{@"name":textField.text};
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

- (void)refresh:(NSString *)imgUrl{
    NSDictionary *dic = @{@"name":imgUrl};
    [_mutDict setObject:dic forKey:[NSString stringWithFormat:@"%d",6]];
    [self.tableView reloadData];
}

- (PopUpWindowViewModel *)popUpWindowViewModel{
    if (!_popUpWindowViewModel) {
        _popUpWindowViewModel = [[PopUpWindowViewModel alloc]init];
    }
    return _popUpWindowViewModel;
}
@end
