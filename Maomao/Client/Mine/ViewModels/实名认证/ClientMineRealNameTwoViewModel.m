//
//  ClientMineRealNameTwoViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineRealNameTwoViewModel.h"
#import "ClientMineTextTabCell.h"
#import "ClientMineCertificationTabCell.h"

static NSString *const identify = @"ClientMineTextTabCell";
static NSString *const idnetify1 = @"ClientMineCertificationTabCell";
@interface ClientMineRealNameTwoViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, assign)NSInteger cotunt;

@end
@implementation ClientMineRealNameTwoViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
    [self.uploadSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        self.uploadSubject = [RACSubject subject];
        self.mutArray = [NSMutableArray array];
        self.mutImgArray = [NSMutableArray array];
        [self.mutArray addObject:@""];
        [self.mutImgArray addObject:@""];
        [self.mutArray addObject:@""];
        [self.mutImgArray addObject:@""];
        self.cotunt = 0;
        [self setNetWork];
    }
    return self;
}

- (void)bindViewToViewModel:(UITableView *)view {
    self.tableView = view;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        ClientMineTextTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineTextTabCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        ClientMineCertificationTabCell *cell = [tableView dequeueReusableCellWithIdentifier:idnetify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineCertificationTabCell" owner:self options:nil]lastObject];
        }
        self.number = cell.clickBut.tag =indexPath.row;
        __weak typeof(self)weakSelf = self;
        [[cell.clickBut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            [weakSelf.clickSubject sendNext:[NSString stringWithFormat:@"%ld",x.tag]];
        }];
        NSString *str = self.mutArray[indexPath.row];
        UIImage *img = self.mutImgArray[indexPath.row];
        [cell setUpimg:str number:self.number img:img];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 245;
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (void)setNetWork{
    ///上传图片成功
    __weak typeof(self)weakSelf = self;
    [weakSelf.publicbaseViewModel.imguploadCommand.executionSignals
     .switchToLatest subscribeNext:^(id  _Nullable x) {
         [weakSelf.mutArray setObject:x[@"src"] atIndexedSubscript:weakSelf.cotunt];
         if (weakSelf.cotunt == 0) {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 NSArray *imgs = @[weakSelf.mutImgArray[1]];
                 [weakSelf.publicbaseViewModel.imguploadCommand execute:imgs];
             });
             weakSelf.cotunt ++;
         }else{
             weakSelf.cotunt = 0;
             [weakSelf.uploadSubject sendNext:weakSelf.mutArray];
         }
         [weakSelf.tableView reloadData];
         MMJF_Log(@"%@",weakSelf.mutArray);
    }];
}

- (void)refresh{
    [self.tableView reloadData];
}

- (ClientPublicBaseViewModel *)publicbaseViewModel{
    if (!_publicbaseViewModel) {
        _publicbaseViewModel = [[ClientPublicBaseViewModel alloc]init];
    }
    return _publicbaseViewModel;
}

- (ClientMineNetworkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[ClientMineNetworkViewModel alloc]init];
    }
    return _netWorkViewModel;
}
@end
