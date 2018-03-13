//
//  ClientMineListViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineListViewModel.h"
#import "ClientMineHeadTablCell.h"
#import "ClientMineModuleTablCell.h"
#import "ClientModuleTwoTabCell.h"
#import "ClientUserModel.h"


static NSString *const identify = @"ClientMineHeadTablCell";
static NSString *const identify1 = @"ClientMineModuleTablCell";
static NSString *const identify2 = @"ClientModuleTwoTabCell";
static NSString *const identify3 = @"ClientMineNetworkViewModel";
@interface ClientMineListViewModel()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, copy)NSString *headImg;


@end
@implementation ClientMineListViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
         self.clickSubject = [RACSubject subject];
        [self setUpPublic];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ClientMineHeadTablCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineHeadTablCell" owner:self options:nil]lastObject];
        }
        __weak typeof(self)weakSelf = self;
        __weak typeof(cell)weakCell = cell;
        [[weakCell.headBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:@"8"];
        }];
        [[weakCell.leftBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:@"9"];
        }];
        [[weakCell.rightBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [weakSelf.clickSubject sendNext:@"10"];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 1){
        ClientMineModuleTablCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineModuleTablCell" owner:self options:nil]lastObject];
        }
        __weak typeof(self)weakSelf = self;
        __weak typeof(cell)weakCell = cell;
        [weakCell.clickSubject subscribeNext:^(id  _Nullable x) {
            [weakSelf.clickSubject sendNext:x];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        ClientModuleTwoTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientModuleTwoTabCell" owner:self options:nil]lastObject];
        }
        __weak typeof(self)weakSelf = self;
        __weak typeof(cell)weakCell = cell;
        [weakCell.clickSubject subscribeNext:^(id  _Nullable x) {
            [weakSelf.clickSubject sendNext:x];
        }];
        cell.separatorInset = UIEdgeInsetsMake(0, MMJF_WIDTH, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 264;
    }else if(indexPath.section == 1){
        return 270;
    }else{
        return 168;
    }
}

- (void)setUpPublic{
    ///上传图片成功
    __weak typeof(self)weakSelf = self;
    [weakSelf.networkViewModel.imguploadCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        weakSelf.headImg = x[@"src"];
        NSDictionary *dic = @{@"url":weakSelf.headImg};
        [weakSelf.networkViewModel.userAvatarCommand execute:dic];
    }];
    //修改头像
    [weakSelf.networkViewModel.userAvatarCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
        user.header_img = weakSelf.headImg;
        BOOL ret =  [NSKeyedArchiver archiveRootObject:user toFile:MMJF_UserInfoPath];
        if (ret) {
            MMJF_Log(@"归档成功");
        }else{
            MMJF_Log(@"归档失败");
        }
        [weakSelf.tableView reloadData];
    }];
}

- (void)refresh{
    [self.tableView reloadData];
}

- (void)top{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}


- (ClientMineNetworkViewModel *)networkViewModel{
    if (!_networkViewModel) {
        _networkViewModel = [[ClientMineNetworkViewModel alloc]init];
    }
    return _networkViewModel;
}
@end
