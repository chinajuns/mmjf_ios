//
//  ClientMineSetUpListViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineSetUpListViewModel.h"
#import "ClientHomeInputBoxTabCell.h"
#import "SystemRemindViewCell.h"

static NSString *const identify = @"SystemRemindViewCell";
static NSString *const identify1 = @"ClientHomeInputBoxTabCell";
@interface ClientMineSetUpListViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, copy)NSArray *titleArray;
@end
@implementation ClientMineSetUpListViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        self.swithSubject = [RACSubject subject];
        self.titleArray = @[@"意见反馈",@"推送通知",@"修改密码",@"关于我们",@"退出登录"];
    }
    return self;
}

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
}

/**
 刷新
 */
- (void)refresh{
    [self.tableView reloadData];
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        SystemRemindViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SystemRemindViewCell" owner:self options:nil]lastObject];
        }
        if (self.number == 0) {//关
            cell.systemSwitches.on = NO;
        }else{
            cell.systemSwitches.on = YES;
        }
        [cell.systemSwitches addTarget:self action:@selector(handleEventSwith:) forControlEvents:UIControlEventValueChanged];
        cell.systemSwitches.layer.cornerRadius = 15;
        cell.systemSwitches.layer.masksToBounds = YES;
        cell.title.text = self.titleArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ClientHomeInputBoxTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeInputBoxTabCell" owner:self options:nil]lastObject];
        }
        cell.mandatoryLab.hidden = YES;
        if (indexPath.section == 0) {
            cell.titleLabel.text = self.titleArray[indexPath.row];
        }else if (indexPath.section == 1){
            cell.titleLabel.text = self.titleArray[indexPath.row + 2];
        }else{
            cell.titleLabel.text = self.titleArray[indexPath.row + 4];
        }
        cell.contentText.hidden = YES;
        if (indexPath.section == 2) {
            cell.arrowimage.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * customView = [[UIView alloc]init];
//    customView.backgroundColor = MMJF_COLOR_Gray;
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.clickSubject sendNext:[NSString stringWithFormat:@"%ld",indexPath.row]];
    }else if (indexPath.section == 1){
        [self.clickSubject sendNext:[NSString stringWithFormat:@"%ld",indexPath.row + 2]];
    }else{
        [self.clickSubject sendNext:[NSString stringWithFormat:@"%ld",indexPath.row + 4]];
    }
    
}

-(void)handleEventSwith:(UISwitch *)sender
{
    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {
        NSLog(@"开");
        [self.swithSubject sendNext:@"开"];
    }else {
        NSLog(@"关");
        [self.swithSubject sendNext:@"关"];
    }
}
@end
