//
//  ClientHomeLoanInputViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/11/29.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeLoanInputViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "ButtonCell.h"
#import "PopUpWindowViewModel.h"
#import "ClientMineTextVeiwTabCell.h"

static NSString *const identify2 = @"ButtonCell";
static NSString *const identify = @"ClientHomeInputBoxTabCell";
static NSString *const identify3 = @"ClientMineTextVeiwTabCell";
@interface ClientHomeLoanInputViewModel ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ButtonDelegate>{
    NSArray *_titleArray1;
    NSArray *_titleArray2;
    NSArray *_titleArray3;
    NSArray *_titleArray4;
}
@property (nonatomic,strong) UITableView *tableView;
/**
 弹窗
 */
@property (nonatomic, strong)PopUpWindowViewModel *popUpWindowViewModel;
@property (nonatomic, strong)NSMutableDictionary *mutDic1;
@property (nonatomic, strong)NSMutableDictionary *mutDic2;
@property (nonatomic, strong)NSMutableDictionary *mutDic3;
@property (nonatomic, strong)NSMutableDictionary *mutDic4;
@property (nonatomic, strong)NSMutableDictionary *mutDic4_1;
/**
 判断是否有小数点
 */
@property (nonatomic, assign)BOOL isHaveDian;

/**
 判断首字母为零
 */
@property (nonatomic, assign)BOOL isZero;

@property (nonatomic, strong)NSMutableArray *dataSouce;//请求数据

@property (nonatomic, copy)NSString *textStr;
@end
@implementation ClientHomeLoanInputViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
    [self.chooseRACSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.chooseRACSubject = [RACSubject subject];
        self.clickSubject = [RACSubject subject];
        self.mutDict = [NSMutableDictionary dictionary];
        _mutDic1 = [NSMutableDictionary dictionary];
        _mutDic2 = [NSMutableDictionary dictionary];
        _mutDic3 = [NSMutableDictionary dictionary];
        _mutDic4 = [NSMutableDictionary dictionary];
        _mutDic4_1 = [NSMutableDictionary dictionary];
        _titleArray1 = @[@"贷款金额(万元)",@"贷款期限(月)",@"贷款类型"];
        _titleArray2 = @[@"姓名",@"年龄(岁)",@"所在地址",@"婚姻状况"];
        _titleArray3 = @[@"职业身份",@"当前工龄(年)",@"月收入(元)",@"工资发放形式"];
        _titleArray4 = @[@"是否有本地社保",@"是否有本地公积金",@"个人信用情况",@"名下房产",@"名下车产"];
        self.textStr = @"";
        self.dataSouce = [NSMutableArray array];
//        self.titleArray = @[@"姓名",@"贷款金额(万元)",@"职业身份",@"是否有本地公积金",@"是否有本地社保",@"名下房产类型",@"车产情况",@"月收入(元)",@"发放方式",@"您的信用情况",@"年龄"];
    }
    return self;
}

- (void)bindViewToViewModel:(UIView *)view{
    self.tableView = (UITableView *)view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
}

#pragma mark--UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
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
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 4){
        ClientHomeInputBoxTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeInputBoxTabCell" owner:self options:nil]lastObject];
        }
         cell.mandatoryLab.hidden = NO;
        cell.arrowimage.hidden = NO;
        cell.contentLine.constant = 22;
        if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.row == 0 && indexPath.section == 1) || (indexPath.section == 2 && indexPath.row == 1) || (indexPath.section == 2 && indexPath.row == 2)) {
            cell.contentText.placeholder = @"请输入";
            cell.arrowimage.hidden = YES;
            cell.contentLine.constant = 15;
            if (indexPath.section == 1) {
                cell.contentText.keyboardType = UIKeyboardTypeDefault;
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
        if (indexPath.row == 0) {
            ClientMineTextVeiwTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify3];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineTextVeiwTabCell" owner:self options:nil]lastObject];
            }
            cell.dividerView.hidden = YES;
            cell.separatorInset = UIEdgeInsetsMake(0, MMJF_WIDTH, 0, 0);
            cell.title.text = @"信息简述";
            cell.title.font = [UIFont fontWithName:@"PingFang SC" size:13];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(cell)weakcell =cell;
            __weak typeof(self)weakSelf = self;
            [cell setUpText:@"描述个人详细信息" maxNumber:200 color:[UIColor colorWithHexString:@"#fafafa"] fontSize:12 inputText:self.textStr];
            // 设置文本框最大行
            cell.numberWordsLab.text = [NSString stringWithFormat:@"%ld/%d",self.textStr.length,200];
            // 设置文本框最大行数
            [cell.input textValueDidChanged:^(NSString *text, CGFloat textHeight) {
                if (textHeight > 162) {
                    CGRect frame = weakcell.input.frame;
                    frame.size.height = textHeight;
                    weakcell.input.frame = frame;
                }
                weakSelf.textStr = text;
                weakcell.numberWordsLab.text = [NSString stringWithFormat:@"%ld/%d",text.length,200];
            }];
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
            [mutDic addEntriesFromDictionary:_mutDic1];
            [mutDic addEntriesFromDictionary:_mutDic2];
            [mutDic addEntriesFromDictionary:_mutDic3];
            [mutDic addEntriesFromDictionary:_mutDic4_1];
            MMJF_Log(@"sssss%@",_mutDict);
            [cell setUpData:@"提交" number:0 dict:mutDic count:13];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 4){
        return 50;
    }else{
        if (indexPath.row == 0) {
            return 186;
        }
        return 110;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, 40)];
    customView.backgroundColor = [UIColor colorWithRed:241.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1];
    if (section < 4) {
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
        }else{
            label.text = @"资产信息:";
        }
        [customView addSubview:label];
    }
    return customView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section < 4) {
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
    if (textField.tag == 0 || textField.tag == 10 || textField.tag == 21 || textField.tag == 22) {
        return YES;
    }
    [self.tableView endEditing:YES];
    if (textField.tag == 11) {
        [self.popUpWindowViewModel appearClick:0.65 control:1 number:textField.tag dataArray:nil titleStr:@"年龄(岁)"];
    }else if(textField.tag == 12){
        [self.popUpWindowViewModel appearClick:0.65 control:2 number:textField.tag dataArray:nil titleStr:@"地区"];
    }else{
        NSArray *array = [self getArray:textField.tag];
       
        [self.popUpWindowViewModel appearClick:0.65 control:0 number:textField.tag dataArray:array titleStr:@"请选择"];
    }
    __weak typeof(self)weakSelf = self;
    [[weakSelf.popUpWindowViewModel.popUpWindowView.determineBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSDictionary *dic;
        if (x.tag == 11) {
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
            if (textField.tag > 32) {
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
    NSDictionary *dic = @{@"name":textField.text};
    if (textField.tag < 10) {
        [_mutDic1 setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
    }else if(textField.tag == 10){
        [_mutDic2 setObject:dic forKey:[NSString stringWithFormat:@"%ld",textField.tag]];
    }else{
        if (textField.tag == 21) {
            if ([textField.text integerValue] > 50) {
                [MBProgressHUD showError:@"工龄过大"];
                return;
            }
        }
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
        _isZero = NO;
        
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
            //判断工资8位
            if (textField.tag == 22) {
                //判断
                if (range.location <= 8) {
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
                    if (textField.tag == 1) {
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
    NSString *name = self.mutDict[@"10"][@"name"];
    NSString *apply_number = self.mutDict[@"0"][@"name"];
    NSString *region_id = self.mutDict[@"12"][@"region_id"];
    NSString *province_id = self.mutDict[@"12"][@"province_id"];
    NSString *city_id = self.mutDict[@"12"][@"city_id"];
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
    NSString *age = self.mutDict[@"11"][@"id"];
    
    NSString *loaner_id = self.loaner_id;
    NSString *loan_type = [NSString stringWithFormat:@"%@",self.mutDict[@"2"][@"id"]];
    NSString *str = self.mutDict[@"13"][@"name"];
    NSString *is_marry;
    if ([str isEqualToString:@"已婚"]) {
        is_marry = @"1";
    }else{
        is_marry = @"0";
    }
    NSString *time_limit = [NSString stringWithFormat:@"%@",self.mutDict[@"1"][@"id"]];
    NSString *income = self.mutDict[@"22"][@"name"];
    NSString *work_time = [NSString stringWithFormat:@"%@年",self.mutDict[@"21"][@"name"]];
    
    NSDictionary *dic;
    if (self.product_id.length == 0) {
        dic = @{@"name":name,@"apply_number":apply_number,@"region_id":region_id,@"province_id":province_id,@"city_id":city_id,@"assets_information":assets_information1,@"job_information":job_information,@"age":age,@"loaner_id":loaner_id,@"loan_type":loan_type,@"is_marry":is_marry,@"time_limit":time_limit,@"describe":self.textStr,@"income":income,@"work_time":work_time};
    }else{
       dic = @{@"name":name,@"apply_number":apply_number,@"region_id":region_id,@"province_id":province_id,@"city_id":city_id,@"assets_information":assets_information1,@"job_information":job_information,@"age":age,@"loaner_id":loaner_id,@"product_id":self.product_id,@"loan_type":loan_type,@"is_marry":is_marry,@"time_limit":time_limit,@"describe":self.textStr,@"income":income,@"work_time":work_time};
    }
    [self.applyCommand execute:dic];
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
        case 13://婚姻状况
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



#pragma mark--getter
- (PopUpWindowViewModel *)popUpWindowViewModel{
    if (!_popUpWindowViewModel) {
        _popUpWindowViewModel = [[PopUpWindowViewModel alloc]init];
    }
    return _popUpWindowViewModel;
}

// C端： 首页:贷款申请:基本配置
- (RACCommand *)clientConfigCommand{
    if (!_clientConfigCommand) {
        _clientConfigCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [MMJF_NetworkShare v1clientConfigId:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    if (![baseModel.msg isEqualToString:@"已取消"]) {
                        [MBProgressHUD showError:baseModel.msg];
                    }
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    __weak typeof(self)weakSelf = self;
    [_clientConfigCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        
        NSArray *work = x[@"work"];
        NSArray *assets = x[@"assets"];
        NSArray *basic = x[@"basic"];
        [weakSelf.dataSouce addObjectsFromArray:work];
        [weakSelf.dataSouce addObjectsFromArray:assets];
        [weakSelf.dataSouce addObjectsFromArray:basic];
        MMJF_Log(@"%@",weakSelf.dataSouce);
    }];
    return _clientConfigCommand;
}
// C端：首页:贷款申请:申请
- (RACCommand *)applyCommand{
    if (!_applyCommand) {
        _applyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientApply:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    if (![baseModel.msg isEqualToString:@"已取消"]) {
                        [MBProgressHUD showError:baseModel.msg];
                    }
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    __weak typeof(self)weakSelf = self;
    [_applyCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        weakSelf.mutDict = [NSMutableDictionary dictionary];
        weakSelf.mutDic1 = [NSMutableDictionary dictionary];
        weakSelf.mutDic2 = [NSMutableDictionary dictionary];
        weakSelf.mutDic3 = [NSMutableDictionary dictionary];
        weakSelf.mutDic4 = [NSMutableDictionary dictionary];
        weakSelf.mutDic4_1 = [NSMutableDictionary dictionary];
        weakSelf.textStr = @"";
        [weakSelf.tableView reloadData];
        [weakSelf.clickSubject sendNext:x];
    }];
    return _applyCommand;
}
@end
