//
//  ClientMineRealNameThreeViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/20.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineRealNameThreeViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "CertificationPhotosTabCell.h"
#import "XLPhotoBrowser.h"

static NSString *const identify = @"ClientHomeInputBoxTabCell";
static NSString *const identify1 = @"CertificationPhotosTabCell";
@interface ClientMineRealNameThreeViewModel()<UITableViewDelegate,UITableViewDataSource,XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, copy)NSArray *titleArray;
@property (nonatomic, strong)NSMutableArray *imags;
@end
@implementation ClientMineRealNameThreeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.titleArray = @[@"真实姓名",@"地址",@"身份证号"];
        self.imags = [NSMutableArray array];
        __weak typeof(self)weakSelf = self;
        [self.networkViewModel.authDocumentCommand.executionSignals
         .switchToLatest subscribeNext:^(id  _Nullable x) {
             MMJF_Log(@"%@",x);
             weakSelf.authDocumentModel = [ClientMineAuthDocumentModel yy_modelWithJSON:x];
             [weakSelf.imags addObject:[NSString stringWithFormat:@"%@%@",MMJF_ShareV.image_url,weakSelf.authDocumentModel.front_identity]];
             [weakSelf.imags addObject:[NSString stringWithFormat:@"%@%@",MMJF_ShareV.image_url,weakSelf.authDocumentModel.back_identity]];
             [weakSelf.tableView reloadData];
        }];
    }
    return self;
}

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.networkViewModel.authDocumentCommand execute:nil];
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
    if (indexPath.section == 0) {
        ClientHomeInputBoxTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeInputBoxTabCell" owner:self options:nil]lastObject];
        }
        cell.mandatoryLab.hidden = YES;
        cell.titleLabel.text = self.titleArray[indexPath.row];
        cell.arrowimage.hidden = YES;
        cell.contentLine.constant = 15;
        cell.contentText.placeholder = @"请输入";
        cell.contentText.enabled = NO;
        if (indexPath.row == 0) {
            cell.contentText.text = self.authDocumentModel.true_name;
        }else if (indexPath.row == 1){
            cell.contentText.text = self.authDocumentModel.address;
        }else{
            cell.contentText.text = self.authDocumentModel.identity_number;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        CertificationPhotosTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CertificationPhotosTabCell" owner:self options:nil]lastObject];
        }
        [cell.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:self.authDocumentModel.front_identity]]];
        [cell.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:self.authDocumentModel.back_identity]]];
        __weak typeof(self)weakSelf = self;
        [cell.clickBut subscribeNext:^(id  _Nullable x) {
            XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:weakSelf.imags currentImageIndex:[x integerValue]];
            browser.browserStyle = XLPhotoBrowserStyleIndexLabel; // 微博样式
            
        }];
        cell.separatorInset = UIEdgeInsetsMake(0, MMJF_WIDTH, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return 90;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, 40)];
    customView.backgroundColor = [UIColor colorWithRed:241.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, MMJF_WIDTH, 30)];
    label.font = [UIFont fontWithName:@"PingFang SC" size:11];
    label.textColor = [UIColor colorWithHexString:@"#4d4d4d"];
    label.frame = CGRectMake(12, 5, MMJF_WIDTH, 30);
    if (section == 0) {
        label.text = @"个人信息:";
    }else{
        label.text = @"身份证:";
    }
    [customView addSubview:label];
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
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

- (ClientMineNetworkViewModel *)networkViewModel{
    if (!_networkViewModel) {
        _networkViewModel = [[ClientMineNetworkViewModel alloc]init];
    }
    return _networkViewModel;
}
@end
