//
//  LoanerStoreCreateViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreCreateViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "LoanerCooperationTabCell.h"
#import "LoanerStoreHeadPortraitTabCell.h"
#import "ThereHintsButTabCell.h"

static NSString *const identify2 = @"ThereHintsButTabCell";
static NSString *const identify = @"ClientHomeInputBoxTabCell";
static NSString *const identify3 = @"LoanerCooperationTabCell";
static NSString *const identify4 = @"LoanerStoreHeadPortraitTabCell";
@interface LoanerStoreCreateViewModel()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSArray *_titleArray;
    NSArray *_cotentArray;
}

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableDictionary *mutDic;

@property (nonatomic, copy)NSString *textStr;
/**
 判断是否有小数点
 */
@property (nonatomic, assign)BOOL isHaveDian;
/**
 判断首字母为零
 */
@property (nonatomic, assign)BOOL isZero;
@end
@implementation LoanerStoreCreateViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        _titleArray = @[@"姓名",@"所在城市",@"机构名称",@"当前工龄(年)",@"最高可贷金额(万元)"];
        self.mutDic = [NSMutableDictionary dictionary];
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
    __weak typeof(self)weakSelf = self;
    _cotentArray = @[weakSelf.model.true_name,[NSString stringWithFormat:@"%@-%@-%@",weakSelf.model.address[@"province"],weakSelf.model.address[@"city"],weakSelf.model.address[@"district"]],weakSelf.model.mechanism];
    [self.tableView reloadData];
}
//获取数据
- (NSDictionary *)getData{
    __weak typeof(self)weakSelf = self;
    NSString *str = weakSelf.mutDic[@"1"][@"name"];
    if (str.length == 0) {
        str = @"";
    }
    NSDictionary *dic = @{@"work_time":weakSelf.mutDic[@"0"][@"name"],@"introduce":str,@"max_loan":weakSelf.mutDic[@"2"][@"name"]};
    return dic;
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
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
        cell.arrowimage.hidden = YES;
        cell.contentLine.constant = 15;
        if (indexPath.row == 3) {
            cell.contentText.placeholder = @"请输入";
            cell.contentText.keyboardType = UIKeyboardTypeNumberPad;
            cell.contentText.text = [self.mutDic objectForKey:@"0"][@"name"];
        }else if (indexPath.row == 4) {
            cell.contentText.placeholder = @"请输入";
            cell.contentText.keyboardType = UIKeyboardTypeDecimalPad;
            cell.contentText.text = [self.mutDic objectForKey:@"2"][@"name"];
        }else{
            cell.contentText.placeholder = @"";
            cell.contentText.enabled = NO;
            cell.contentText.text = _cotentArray[indexPath.row];
        }
        cell.contentText.tag = indexPath.row;
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
        // 设置文本框最大行数
        __weak typeof(cell)weakCell = cell;
        __weak typeof(self)weakSelf = self;
        [cell setUpText:[self.mutDic objectForKey:@"1"][@"name"] placeholderStr:@"实例：专业从事无抵押信用贷款资讯服务。无需抵押，无需担保，额度1-50万，最快当天到账。"];
        cell.input.text = self.textStr;
        cell.countLab.text = [NSString stringWithFormat:@"%ld/%d",self.textStr.length,50];
        [cell.input textValueDidChanged:^(NSString *text, CGFloat textHeight) {
            if (textHeight > 100) {
                CGRect frame = weakCell.input.frame;
                frame.size.height = textHeight;
                weakCell.input.frame = frame;
            }
            weakSelf.textStr = text;
            weakCell.countLab.text = [NSString stringWithFormat:@"%ld/%d",text.length,50];
            NSDictionary *dic = @{@"name":text};
            [weakSelf.mutDic setObject:dic forKey:@"1"];
            NSIndexSet *indexSet =[[NSIndexSet alloc]initWithIndex:3];
            [weakSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        cell.title.text = @"店铺描述";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 0){
        LoanerStoreHeadPortraitTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerStoreHeadPortraitTabCell" owner:self options:nil]lastObject];
        }
        [cell.headerimg sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:self.model.header_img]] placeholderImage:[UIImage imageNamed:@"denglu-mei-you-tou-xiang"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        ThereHintsButTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ThereHintsButTabCell" owner:self options:nil]lastObject];
        }
        NSDictionary *strDic = self.mutDic[@"0"];
        NSDictionary *strDic1 = self.mutDic[@"2"];
        NSDictionary *dic;
        if ([strDic isKindOfClass:[NSDictionary class]] && [strDic1 isKindOfClass:[NSDictionary class]]) {
            dic = @{@"0":strDic,@"2":strDic1};
        }
        [cell setUpData:@"确定发布" number:0 dict:dic count:2];
        __weak typeof(self)weakSelf = self;
        [cell.cilckBut setTitle:@"提交" forState:UIControlStateNormal];
        [[cell.cilckBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:@""];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0 || indexPath.section == 1) {
        return 50;
    }else if (indexPath.section == 2){
        return 181;
    }else{
        return 120;
    }
    
}
//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([NSString hasEmoji:textField.text] || [NSString stringContainsEmoji:textField.text]) {
        [MBProgressHUD showError:@"不支持输入表情"];
        return;
    }
    if (textField.tag == 3) {
        NSDictionary *dic = @{@"name":textField.text};
        [_mutDic setObject:dic forKey:@"0"];
    }else{
        NSDictionary *dic = @{@"name":textField.text};
        [_mutDic setObject:dic forKey:@"2"];
    }
    
    [_tableView reloadData];
}
//控制只能输入小数点后2位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //不支持系统表情的输入
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        [MBProgressHUD showError:@"不支持输入表情"];
        return NO;
    }
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        _isHaveDian = NO;
    }
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    if (range.length == 1 && string.length == 0) {
        _isHaveDian = _isZero = NO;
        
        return YES;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            if (single != '.') {
                if (_isZero == YES && _isHaveDian == NO) {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    _isZero = YES;
                }
            }
            //判断工龄2位
            if (textField.tag == 3) {
                //判断
                if (range.location <= 1) {
                    return YES;
                }else{
                    return NO;
                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!_isHaveDian)//text中还没有小数点
                {
                    _isHaveDian = YES;
                    return YES;
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (_isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 1) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    if (textField.tag == 4) {
                        NSInteger existedLength = textField.text.length;
                        NSInteger selectedLength = range.length;
                        NSInteger replaceLength = string.length;
                        if (existedLength - selectedLength + replaceLength > 8) {
                            return NO;
                        }
                        return YES;
                    }
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}

@end
