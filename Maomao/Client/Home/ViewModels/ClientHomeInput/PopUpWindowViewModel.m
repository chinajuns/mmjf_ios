//
//  PopUpWindowViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/11/29.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "PopUpWindowViewModel.h"

@interface PopUpWindowViewModel()<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSInteger _provinceIndex;   // 省份选择 记录
    NSInteger _cityIndex;       // 市选择 记录
    NSInteger _districtIndex;   // 区选择 记录
}
@property (nonatomic, strong)UIDatePicker *datePicker;

@property (nonatomic, strong)UIPickerView *pickerView;

@property (nonatomic, assign)CGFloat coefficient;

@property (nonatomic, assign)NSInteger number;
/**
 *  数据源
 */
@property (nonatomic, strong) NSArray * arrayDS;

@property (nonatomic, copy)NSArray *dataArray;
@end
@implementation PopUpWindowViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)appearClick:(CGFloat)coefficient control:(NSInteger)control number:(NSInteger)number dataArray:(NSArray *)dataArray titleStr:(NSString *)titleStr{
    // ------全屏遮罩
    self.BGView                 = [[UIView alloc] init];
    self.BGView.frame           = [[UIScreen mainScreen] bounds];
    self.BGView.tag             = 100;
    self.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    self.BGView.opaque = NO;
    self.coefficient = coefficient;
    //--UIWindow的优先级最高，Window包含了所有视图，在这之上添加视图，可以保证添加在最上面
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:self.BGView];
    __weak typeof(self)weakSelf = self;
    // ------给全屏遮罩添加的点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exitClick)];
    gesture.numberOfTapsRequired = 1;
    gesture.cancelsTouchesInView = NO;
    [self.BGView addGestureRecognizer:gesture];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.BGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
    }];
    self.number = control;
    self.dataArray = dataArray;
    // ------底部弹出的View
    self.popUpWindowView                 = [[[NSBundle mainBundle]loadNibNamed:@"PopUpWindowView" owner:self options:nil] lastObject];

    self.popUpWindowView.frame           = CGRectMake(0,MMJF_HEIGHT * coefficient, MMJF_WIDTH, MMJF_HEIGHT * (1 - coefficient));
    
    self.popUpWindowView.cancelBut.tag = self.popUpWindowView.determineBut.tag = number;
    [appWindow addSubview:self.popUpWindowView];
    
    self.popUpWindowView.titleLabel.text = titleStr;
    // ------View出现动画
    self.popUpWindowView.transform = CGAffineTransformMakeTranslation(0.01, MMJF_HEIGHT);
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.popUpWindowView.transform = CGAffineTransformMakeTranslation(0.01, 0.01);
        if (control == 1) {//时间选择器
            [weakSelf.popUpWindowView addSubview:weakSelf.datePicker];
            
        }else if (control == 0){//单行
            [weakSelf.pickerView selectRow:0 inComponent:0 animated:YES];
            [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
            [weakSelf.pickerView reloadAllComponents];
            [weakSelf.popUpWindowView addSubview:weakSelf.pickerView];
            
        }else{//2地址选择器
            _provinceIndex = _cityIndex = _districtIndex = 0;
            [weakSelf.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
            [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
            [self pickerView:self.pickerView didSelectRow:0 inComponent:1];
            [self pickerView:self.pickerView didSelectRow:0 inComponent:2];
            [weakSelf.popUpWindowView addSubview:weakSelf.pickerView];
            
            [weakSelf.pickerView reloadAllComponents];
        }
    }];
    
}

-(void)resetPickerSelectRow
{
    [self.pickerView selectRow:_provinceIndex inComponent:0 animated:YES];
    [self.pickerView selectRow:_cityIndex inComponent:1 animated:YES];
    [self.pickerView selectRow:_districtIndex inComponent:2 animated:YES];
}

/**
 * 功能： View退出
 */
- (void)exitClick {
    
    MMJF_Log(@"====");
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.popUpWindowView.transform = CGAffineTransformMakeTranslation(0.01, MMJF_HEIGHT);
        weakSelf.popUpWindowView.alpha = 0.2;
        weakSelf.BGView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [weakSelf.BGView removeFromSuperview];
        [weakSelf.popUpWindowView removeFromSuperview];
    }];
    
}
#pragma mark UIPickerViewDataSource 数据源方法
// 返回多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.number == 2) {
        return 3;
    }
    return 1;
    
}

// 返回多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.number == 2) {
        if(component == 0){
            return self.arrayDS.count;
        }
        else if (component == 1){
            return [self.arrayDS[_provinceIndex][@"city"] count];
        }
        else{
            return [self.arrayDS[_provinceIndex][@"city"][_cityIndex][@"district"] count];
        }
    }
    return self.dataArray.count;
    
}

#pragma mark UIPickerViewDelegate 代理方法

// 返回每行的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.number == 2) {
        if(component == 0){
            return self.arrayDS[row][@"name"];
        }
        else if (component == 1){
            return self.arrayDS[_provinceIndex][@"city"][row][@"name"];
        }
        else{
            return self.arrayDS[_provinceIndex][@"city"][_cityIndex][@"district"][row][@"name"];
        }
    }
    NSDictionary *dic = self.dataArray[row];
    return dic[@"name"];
//    return self.foodsData[component][row];
}
// 选中行显示在label上
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.number == 2) {
        if(component == 0){
            _provinceIndex = row;
            _cityIndex = 0;
            _districtIndex = 0;
            
            [self.pickerView reloadComponent:1];
            [self.pickerView reloadComponent:2];
        }
        else if (component == 1){
            _cityIndex = row;
            _districtIndex = 0;
            
            [self.pickerView reloadComponent:2];
        }
        else{
            _districtIndex = row;
        }
        NSString * address = [NSString stringWithFormat:@"%@-%@-%@", self.arrayDS[_provinceIndex][@"name"], self.arrayDS[_provinceIndex][@"city"][_cityIndex][@"name"], self.arrayDS[_provinceIndex][@"city"][_cityIndex][@"district"][_districtIndex][@"name"]];
        NSString * city_id = [NSString stringWithFormat:@"%@",self.arrayDS[_provinceIndex][@"city"][_cityIndex][@"id"]];
        NSString *province_id = [NSString stringWithFormat:@"%@",self.arrayDS[_provinceIndex][@"id"]];
        NSString *region_id = [NSString stringWithFormat:@"%@",self.arrayDS[_provinceIndex][@"city"][_cityIndex][@"district"][_districtIndex][@"id"]];
        NSDictionary *dic = @{@"name":address,@"city_id":city_id,@"province_id":province_id,@"region_id":region_id};
        self.selectedDic = dic;
        // 重置当前选中项
        [self resetPickerSelectRow];
    }else{
        NSDictionary *dic = self.dataArray[row];
        self.selectedDic = dic;
    }
    
}

//重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont fontWithName:@"PingFang SC" size:20]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

///返回年龄
- (NSDictionary *)ageWithDateOfBirth
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_datePicker.date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    //实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
    NSString *dateString = [dateFormat stringFromDate:_datePicker.date];
    NSDictionary *dic = @{@"id":dateString,@"name":[NSString stringWithFormat:@"%ld",iAge]};
    return dic;
}

#pragma mark--getter

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(self.popUpWindowView.backView.x, self.popUpWindowView.backView.y, MMJF_WIDTH, MMJF_HEIGHT * (1 - self.coefficient) - 49)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        MMJF_Log(@"%@",NSStringFromCGRect(self.popUpWindowView.backView.frame));
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(self.popUpWindowView.backView.x, self.popUpWindowView.backView.y, MMJF_WIDTH, MMJF_HEIGHT * (1 - self.coefficient) - 49)];
        NSDate *minDate = [NSDate date];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        _datePicker.locale = locale;
        _datePicker.maximumDate = minDate;
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePicker;
}

// 读取本地Plist加载数据源
- (NSArray *)arrayDS
{
    if(!_arrayDS){
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *fileName = [path stringByAppendingPathComponent:@"local.plist" ];
        _arrayDS = [NSArray arrayWithContentsOfFile:fileName];
    }
    return _arrayDS;
}
@end
