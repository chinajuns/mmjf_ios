//
//  loanerJiltSingleViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "loanerJiltSingleViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "ButtonCell.h"
#import "LoanerCooperationTabCell.h"
#import "PopUpWindowViewModel.h"
#import "GetMoneyTabCell.h"

static NSString *const identify2 = @"ButtonCell";
static NSString *const identify = @"ClientHomeInputBoxTabCell";
static NSString *const identify3 = @"LoanerCooperationTabCell";
static NSString *const identfiy4 = @"GetMoneyTabCell";
@interface loanerJiltSingleViewModel()<UITableViewDelegate,UITableViewDataSource,ButtonDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSArray *_titleArray1;
    NSArray *_titleArray2;
    NSArray *_titleArray3;
    NSArray *_titleArray4;
    NSMutableDictionary *_mutDic1;
    NSMutableDictionary *_mutDic2;
    NSMutableDictionary *_mutDic3;
    NSMutableDictionary *_mutDic4;
    NSMutableDictionary *_mutDic4_1;
    NSMutableDictionary *_mutDic5;
}
@property (nonatomic, strong)NSMutableArray *dataSouce;//请求数据
@property (nonatomic, strong)UITableView *tableView;
/**
 弹窗
 */
@property (nonatomic, strong)PopUpWindowViewModel *popUpWindowViewModel;
/**
 判断是否有小数点
 */
@property (nonatomic, assign)BOOL isHaveDian;
/**
 判断首字母为零
 */
@property (nonatomic, assign)BOOL isZero;
@property (nonatomic, copy)NSString *textStr;
@end
@implementation loanerJiltSingleViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutDict = [NSMutableDictionary dictionary];
        _mutDic1 = [NSMutableDictionary dictionary];
        _mutDic2 = [NSMutableDictionary dictionary];
        _mutDic3 = [NSMutableDictionary dictionary];
        _mutDic4 = [NSMutableDictionary dictionary];
        _mutDic4_1 = [NSMutableDictionary dictionary];
        _mutDic5 = [NSMutableDictionary dictionary];
        _titleArray1 = @[@"贷款金额(万元)",@"贷款期限(月)",@"贷款类型"];
        _titleArray2 = @[@"姓名",@"手机号码",@"年龄(岁)",@"所在地址",@"婚姻状况"];
        _titleArray3 = @[@"职业身份",@"当前工龄",@"月收入(元)",@"工资发放形式"];
        _titleArray4 = @[@"是否有本地社保",@"是否有本地公积金",@"个人信用情况",@"名下房产",@"名下车产"];
        self.textStr = @"";
        self.dataSouce = [NSMutableArray array];
        [self setUpNetWork];
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
    return 7;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return  _titleArray1.count;
    }else if(section == 1){
        return _titleArray2.count;
    }else if (section == 2){
        return _titleArray3.count;
    }else if (section == 3){
        return _titleArray4.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 4){
        ClientHomeInputBoxTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeInputBoxTabCell" owner:self options:nil]lastObject];
        }
        cell.mandatoryLab.hidden = NO;
        cell.contentText.placeholder = @"请选择";
        cell.arrowimage.hidden = NO;
        cell.contentLine.constant = 22;
        if ((indexPath.section == 0 && indexPath.row == 0) || ((indexPath.row == 0 || indexPath.row == 1) && indexPath.section == 1) || (indexPath.section == 2 && indexPath.row == 1) || (indexPath.section == 2 && indexPath.row == 2)) {
            cell.contentText.placeholder = @"请输入";
            cell.arrowimage.hidden = YES;
            cell.contentLine.constant = 15;
            if (indexPath.section == 1 && indexPath.row == 0) {
                cell.contentText.keyboardType = UIKeyboardTypeDefault;
            }else if(indexPath.row == 1 && indexPath.section == 1){
                cell.contentText.keyboardType = UIKeyboardTypePhonePad;
            }else if(indexPath.section == 0){
                cell.contentText.keyboardType = UIKeyboardTypeDecimalPad;
            }else{
                cell.contentText.keyboardType = UIKeyboardTypeNumberPad;
            }
        }
        if (indexPath.section == 0) {
            NSDictionary *dic = [_mutDic1 objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
            [cell setUpData:_titleArray1[indexPath.row] content:dic[@"name"] index:indexPath];
        }else if (indexPath.section == 1){
            NSDictionary *dic = [_mutDic2 objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row + indexPath.section * 10]];
            [cell setUpData:_titleArray2[indexPath.row] content:dic[@"name"] index:indexPath];
        }else if (indexPath.section == 2){
            NSDictionary *dic = [_mutDic3 objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row + indexPath.section * 10]];
            [cell setUpData:_titleArray3[indexPath.row] content:dic[@"name"] index:indexPath];
        }else{
            if (!(indexPath.row > 2 && indexPath.row < 5)) {
                cell.mandatoryLab.hidden = YES;
            }
            NSDictionary *dic = [_mutDic4 objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row + indexPath.section * 10]];
            [cell setUpData:_titleArray4[indexPath.row] content:dic[@"name"] index:indexPath];
        }
        cell.contentText.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.section == 4) {
            LoanerCooperationTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerCooperationTabCell" owner:self options:nil]lastObject];
            }
            [cell setUpText:self.textStr placeholderStr:@"描述客户详细信息"];
            __weak typeof(cell)weakCell = cell;
            __weak typeof(self)weakSelf = self;
            cell.input.maxNumber = 300;
            // 设置文本框最大行
            cell.countLab.text = [NSString stringWithFormat:@"%ld/%d",self.textStr.length,300];
            cell.input.text = self.textStr;
            [cell.input textValueDidChanged:^(NSString *text, CGFloat textHeight) {
                if (textHeight > 162) {
                    CGRect frame = weakCell.input.frame;
                    frame.size.height = textHeight;
                    weakCell.input.frame = frame;
                }
                weakSelf.textStr = text;
                weakCell.countLab.text = [NSString stringWithFormat:@"%ld/%d",text.length,300];
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section == 5){
            GetMoneyTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identfiy4];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"GetMoneyTabCell" owner:self options:nil]lastObject];
            }
            cell.separatorInset = UIEdgeInsetsMake(0, MMJF_WIDTH, 0, 0); 
            cell.unitPriceText.delegate = self;
            cell.unitPriceText.tag = indexPath.row + indexPath.section * 10;
            NSDictionary *dic = [_mutDic5 objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row + indexPath.section * 10]];
            cell.unitPriceText.text = dic[@"name"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ButtonCell" owner:self options:nil]lastObject];
            }
            cell.delegate = self;
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            [_mutDict addEntriesFromDictionary:_mutDic1];
            [_mutDict addEntriesFromDictionary:_mutDic2];
            [_mutDict addEntriesFromDictionary:_mutDic3];
            [_mutDict addEntriesFromDictionary:_mutDic4];
            [_mutDict addEntriesFromDictionary:_mutDic5];
            [mutDic addEntriesFromDictionary:_mutDic1];
            [mutDic addEntriesFromDictionary:_mutDic2];
            [mutDic addEntriesFromDictionary:_mutDic3];
            [mutDic addEntriesFromDictionary:_mutDic4_1];
            [mutDic addEntriesFromDictionary:_mutDic5];
            MMJF_Log(@"sssss%@",_mutDict);
            [cell setUpData:@"提交" number:0 dict:mutDic count:15];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 4) {
        return 50;
    }else{
        if (indexPath.section == 4) {
            return 181;
        }else if (indexPath.section == 5){
            return 220;
        }else{
            return 100;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, 40)];
    customView.backgroundColor = [UIColor colorWithRed:241.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1];
    if (section < 4 || section == 5) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, MMJF_WIDTH, 30)];
        label.font = [UIFont fontWithName:@"PingFang SC" size:11];
        label.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
        label.frame = CGRectMake(12, 5, MMJF_WIDTH, 30);
        if (section == 0) {
            label.text = @"贷款信息:";
        }else if (section == 1){
            label.text = @"基本信息:";
        }else if (section == 2){
            label.text = @"工作信息:";
        }else if(section == 3){
            label.text = @"资产信息:";
        }else{
            label.text = @"甩单价:";
        }
        [customView addSubview:label];
    }
    return customView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section < 4 || section == 5) {
        return 40;
    }else{
        return 0;
    }
}

//回收键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}

#pragma mark--UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 0 || textField.tag == 10 || textField.tag == 11 || textField.tag == 50 || textField.tag == 21 || textField.tag == 22) {
        return YES;
    }
    [self.tableView endEditing:YES];
    if (textField.tag == 12) {
        [self.popUpWindowViewModel appearClick:0.65 control:1 number:textField.tag dataArray:nil titleStr:@"年龄"];
    }else if(textField.tag == 13){
        [self.popUpWindowViewModel appearClick:0.65 control:2 number:textField.tag dataArray:nil titleStr:@"行政区域"];
    }else{
        NSArray *array = [self getArray:textField.tag];
        [self.popUpWindowViewModel appearClick:0.65 control:0 number:textField.tag dataArray:array titleStr:@"请选择"];
    }
    __weak typeof(self)weakSelf = self;
    [[weakSelf.popUpWindowViewModel.popUpWindowView.determineBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSDictionary *dic;
        if (x.tag == 12) {
            dic = [weakSelf.popUpWindowViewModel ageWithDateOfBirth];
        }else{
            dic = weakSelf.popUpWindowViewModel.selectedDic;
        }
        [weakSelf.popUpWindowViewModel exitClick];
        if (textField.tag < 10) {
            [_mutDic1 setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
        }else if (textField.tag > 9 && textField.tag < 20){
            [_mutDic2 setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
        }else if (textField.tag > 19 && textField.tag < 30){
            [_mutDic3 setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
        }else{
            [_mutDic4 setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
            if (textField.tag > 32 && textField.tag < 40) {
                [_mutDic4_1 setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
            }
        }
        [weakSelf.tableView reloadData];
    }];
    [[weakSelf.popUpWindowViewModel.popUpWindowView.cancelBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.popUpWindowViewModel exitClick];
    }];
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([NSString hasEmoji:textField.text] || [NSString stringContainsEmoji:textField.text]) {
        [MBProgressHUD showError:@"不支持输入表情"];
        return;
    }
    if (textField.tag == 11) {
        if (![CManager validateMobile:textField.text]) {
            [MBProgressHUD showError:@"手机号码不正确"];
            [_tableView reloadData];
            return;
        }
    }
    NSDictionary *dic = @{@"name":textField.text};
    if (textField.tag < 10) {
        [_mutDic1 setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
    }else if (textField.tag == 50){
        [_mutDic5 setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
    }else if (textField.tag > 9 && textField.tag < 20){
        [_mutDic2 setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
    }else{
        [_mutDic3 setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
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
    if (textField.tag == 10) {
        return YES;
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
            if (textField.tag == 21) {
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
                    if (textField.tag == 22) {
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

#pragma mark--ButtonDelegate
//下一步点击事件
- (void)handleEvent:(UIButton *)sender{
    [self.tableView endEditing:YES];
    NSString *apply_number = self.mutDict[@"0"][@"name"];
    NSString *loan_type = [NSString stringWithFormat:@"%@",self.mutDict[@"2"][@"id"]];
    
    NSString *time_limit = [NSString stringWithFormat:@"%@",self.mutDict[@"1"][@"id"]];
    NSString *name = self.mutDict[@"10"][@"name"];
    NSString *mobile = self.mutDict[@"11"][@"name"];
    NSString *age = self.mutDict[@"12"][@"id"];
    NSString *region_id = self.mutDict[@"13"][@"region_id"];
    NSString *province_id = self.mutDict[@"13"][@"province_id"];
    NSString *city_id = self.mutDict[@"13"][@"city_id"];
    NSString *str = self.mutDict[@"14"][@"name"];
    NSString *is_marry;
    if ([str isEqualToString:@"已婚"]) {
        is_marry = @"1";
    }else{
        is_marry = @"0";
    }
    NSString *assets_information = [NSString stringWithFormat:@"%@,%@,%@,%@,%@",self.mutDict[@"30"][@"id"],self.mutDict[@"31"][@"id"],self.mutDict[@"32"][@"id"],self.mutDict[@"33"][@"id"],self.mutDict[@"34"][@"id"]];
    NSArray *array = [assets_information componentsSeparatedByString:@","];
    NSMutableArray *mutStr = [NSMutableArray array];
    for (id str in array) {
        if (![str isEqualToString:@"(null)"]) {
            NSString *str1 = [NSString stringWithFormat:@"%@",str];
            if (str1.length != 0) {
                [mutStr addObject:str];
            }
        }
        
    }
    NSString *assets_information1 = [mutStr componentsJoinedByString:@","];
    NSString *job_information = [NSString stringWithFormat:@"%@,%@",self.mutDict[@"20"][@"id"],self.mutDict[@"23"][@"id"]];
    NSString *price = self.mutDict[@"50"][@"name"];
    NSString *income = self.mutDict[@"22"][@"name"];
    NSString *work_time = [NSString stringWithFormat:@"%@年",self.mutDict[@"21"][@"name"]];;
    NSDictionary *dic = @{@"name":name,@"apply_number":apply_number,@"region_id":region_id,@"province_id":province_id,@"city_id":city_id,@"assets_information":assets_information1,@"job_information":job_information,@"age":age,@"mobile":mobile,@"loan_type":loan_type,@"is_marry":is_marry,@"time_limit":time_limit,@"describe":self.textStr,@"price":price,@"income":income,@"work_time":work_time};
    [self.netWorkViewModel.junkPublishCommand  execute:dic];
}

//清空数据
- (void)empty{
    self.mutDict = [NSMutableDictionary dictionary];
    _mutDic1 = [NSMutableDictionary dictionary];
    _mutDic2 = [NSMutableDictionary dictionary];
    _mutDic3 = [NSMutableDictionary dictionary];
    _mutDic4 = [NSMutableDictionary dictionary];
    _mutDic4_1 = [NSMutableDictionary dictionary];
    _mutDic5 = [NSMutableDictionary dictionary];
    self.textStr = @"";
    [self.tableView reloadData];
}

//获取配置数据
- (NSArray *)getArray:(NSInteger)tag{
    switch (tag) {
        case 1://贷款期限
            for (NSDictionary *dic in self.dataSouce) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([str isEqualToString:@"30"]) {
                    NSArray *array = dic[@"values"];
                    if (array.count != 0) {
                        return array;
                    }
                }
            }
            break;
        case 2://贷款类型
            for (NSDictionary *dic in self.dataSouce) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([str isEqualToString:@"1"]) {
                    NSArray *array = dic[@"values"];
                    if (array.count != 0) {
                        return array;
                    }
                }
            }
            break;
        case 14://婚姻状况
        {
            NSDictionary *dic2 = @{@"id":@"",@"name":@"已婚",@"pid":@""};
            NSDictionary *dic1 = @{@"id":@"",@"name":@"未婚",@"pid":@""};
            return @[dic2,dic1];
        }
            break;
        case 20: //职业身份
            for (NSDictionary *dic in self.dataSouce) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([str isEqualToString:@"19"]) {
                    NSArray *array = dic[@"values"];
                    if (array.count != 0) {
                        return array;
                    }
                }
            }
            break;
//        case 21://当前工龄
//            for (NSDictionary *dic in self.dataSouce) {
//                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
//                if ([str isEqualToString:@"48"]) {
//                    NSArray *array = dic[@"values"];
//                    if (array.count != 0) {
//                        return array;
//                    }
//                }
//            }
//            break;
//        case 22://月收入
//            for (NSDictionary *dic in self.dataSouce) {
//                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
//                if ([str isEqualToString:@"49"]) {
//                    NSArray *array = dic[@"values"];
//                    if (array.count != 0) {
//                        return array;
//                    }
//                }
//            }
//            break;
        case 23://工资发放形式
            for (NSDictionary *dic in self.dataSouce) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([str isEqualToString:@"50"]) {
                    NSArray *array = dic[@"values"];
                    if (array.count != 0) {
                        return array;
                    }
                }
            }
            break;
        case 30 ://是否有本地社保
            for (NSDictionary *dic in self.dataSouce) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([str isEqualToString:@"21"]) {
                    NSArray *array = dic[@"values"];
                    if (array.count != 0) {
                        return array;
                    }
                }
            }
            break;
        case 31://是否拥有公积金
            for (NSDictionary *dic in self.dataSouce) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([str isEqualToString:@"20"]) {
                    NSArray *array = dic[@"values"];
                    if (array.count != 0) {
                        return array;
                    }
                }
            }
            break;
        case 32://信用情况
            for (NSDictionary *dic in self.dataSouce) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([str isEqualToString:@"29"]) {
                    NSArray *array = dic[@"values"];
                    if (array.count != 0) {
                        return array;
                    }
                }
            }
            break;
        case 33://名下房产
            for (NSDictionary *dic in self.dataSouce) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([str isEqualToString:@"26"]) {
                    NSArray *array = dic[@"values"];
                    if (array.count != 0) {
                        return array;
                    }
                }
            }
            break;
        case 34://名下车产
            for (NSDictionary *dic in self.dataSouce) {
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"id"]];
                if ([str isEqualToString:@"25"]) {
                    NSArray *array = dic[@"values"];
                    if (array.count != 0) {
                        return array;
                    }
                }
            }
            break;
        default:
            break;
    }
    NSDictionary *dic = @{@"id":@"",@"name":@"无数据",@"pid":@""};
    return @[dic];
}
//设置网络
- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.clientConfigCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSArray *work = x[@"work"];
        NSArray *assets = x[@"assets"];
        NSArray *basic = x[@"basic"];
        [weakSelf.dataSouce addObjectsFromArray:work];
        [weakSelf.dataSouce addObjectsFromArray:assets];
        [weakSelf.dataSouce addObjectsFromArray:basic];
        MMJF_Log(@"%@",weakSelf.dataSouce);
    }];
    [self.netWorkViewModel.clientConfigCommand execute:nil];
}

#pragma mark--getter
- (PopUpWindowViewModel *)popUpWindowViewModel{
    if (!_popUpWindowViewModel) {
        _popUpWindowViewModel = [[PopUpWindowViewModel alloc]init];
    }
    return _popUpWindowViewModel;
}

- (LoanerJiltSingleNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerJiltSingleNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
}
@end
