//
//  LoanerMineRecertificationViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerMineRecertificationViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "LoanerCooperationTabCell.h"
#import "LoanerStoreHeadPortraitTabCell.h"
#import "CertificationPhotosTabCell.h"
#import "XLPhotoBrowser.h"

static NSString *const identify5 = @"CertificationPhotosTabCell";
static NSString *const identify2 = @"ButtonCell";
static NSString *const identify = @"ClientHomeInputBoxTabCell";
static NSString *const identify3 = @"LoanerCooperationTabCell";
static NSString *const identify4 = @"LoanerStoreHeadPortraitTabCell";

@interface LoanerMineRecertificationViewModel()<UITableViewDataSource,UITableViewDelegate,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>{
    NSArray *_titleArray;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSArray *cotents;
@property (nonatomic, copy)NSArray *imgs1;
@property (nonatomic, copy)NSArray *imgs2;
@end
@implementation LoanerMineRecertificationViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        _titleArray = @[@"姓名",@"身份证号",@"所在地址",@"机构类型",@"机构名称",@"所属部门"];
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
        cell.arrowimage.hidden = YES;
        cell.contentLine.constant = 15;
        cell.contentText.keyboardType = UIKeyboardTypeDefault;
        if (self.cotents.count != 0) {
            cell.contentText.text = self.cotents[indexPath.row];
        }
        cell.titleLabel.text = _titleArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 0){
        LoanerStoreHeadPortraitTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify4];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanerStoreHeadPortraitTabCell" owner:self options:nil]lastObject];
        }
        cell.titleLab.text = @"免冠照片";
        [cell.headerimg sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:self.model.header_img]] placeholderImage:[UIImage imageNamed:@"denglu-mei-you-tou-xiang"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CertificationPhotosTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify5];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CertificationPhotosTabCell" owner:self options:nil]lastObject];
        }
        NSArray *array;
        if (indexPath.section == 2) {
            [cell setUpdata:self.imgs1];
            array = self.imgs1;
        }else{
            [cell setUpdata:self.imgs2];
            array = self.imgs2;
        }
        [cell.clickBut subscribeNext:^(id  _Nullable x) {
            XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:array currentImageIndex:[x integerValue]];
            browser.browserStyle = XLPhotoBrowserStyleIndexLabel; // 微博样式
            
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0 || indexPath.section == 1) {
        return 50;
    }else{
        return 110;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }else{
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, 40)];
    customView.backgroundColor = [UIColor colorWithRed:241.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1];
    NSArray *array = @[@"个人信息:",@"",@"身份证:",@"资质证明:"];
    if (section != 1) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, MMJF_WIDTH, 30)];
        label.font = [UIFont fontWithName:@"PingFang SC" size:11];
        label.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
        label.frame = CGRectMake(12, 5, MMJF_WIDTH, 30);
        label.text = array[section];
        [customView addSubview:label];
    }
    return customView;
}

- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex
{
    // do something yourself
    switch (actionSheetindex) {
        case 4: // 删除
        {
            
        }
            break;
        case 1: // 保存
        {
            MMJF_Log(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
            [browser saveCurrentShowImage];
        }
            break;
        default:
        {
            MMJF_Log(@"点击了actionSheet索引是:%zd , 当前展示的图片索引是:%zd",actionSheetindex,currentImageIndex);
        }
            break;
    }
}

- (void)refresh{
    self.cotents = @[self.model.true_name,self.model.identity_number,self.model.address,self.model.mechanism_type,self.model.mechanism,self.model.department];
    
    self.imgs1 = @[[NSString stringWithFormat:@"%@%@",MMJF_ShareV.image_url,self.model.front_identity],[NSString stringWithFormat:@"%@%@",MMJF_ShareV.image_url,self.model.back_identity]];
    self.imgs2 = @[[NSString stringWithFormat:@"%@%@",MMJF_ShareV.image_url,self.model.work_card],[NSString stringWithFormat:@"%@%@",MMJF_ShareV.image_url,self.model.card],[NSString stringWithFormat:@"%@%@",MMJF_ShareV.image_url,self.model.contract_page],[NSString stringWithFormat:@"%@%@",MMJF_ShareV.image_url,self.model.logo_personal]];
    [self.tableView reloadData];
}
@end
