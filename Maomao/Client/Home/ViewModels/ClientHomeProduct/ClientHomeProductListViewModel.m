//
//  ClientHomeProductViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeProductListViewModel.h"
#import "ClientHomeProductDetailsTabCell.h"
#import "ApplicationRequirementsTabCell.h"
#import "RequiredMaterialTabCell.h"
#import "ButtonCell.h"

static NSString *const identify = @"ClientHomeProductDetailsTabCell";
static NSString *const identify1 = @"ApplicationRequirementsTabCell";
static NSString *const identify2 = @"RequiredMaterialTabCell";
static NSString *const identify3 = @"ButtonCell";
@interface ClientHomeProductListViewModel()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@end
@implementation ClientHomeProductListViewModel

- (void)dealloc{
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)bindViewToViewModel:(UIView *)view {
    self.tableView = (UITableView *)view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 200;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView= [UIView new];
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ClientHomeProductDetailsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeProductDetailsTabCell" owner:self options:nil]lastObject];
        }
        //    NSDictionary *dic = self.dataSource[indexPath.row];
        [cell setUpdata:self.productModel];
        cell.separatorInset = UIEdgeInsetsMake(0, MMJF_WIDTH, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        ApplicationRequirementsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ApplicationRequirementsTabCell" owner:self options:nil]lastObject];
        }
        cell.key1 = @"option";
        cell.key2 = @"option_values";
        [cell setUpdata:self.productModel.options];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        RequiredMaterialTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RequiredMaterialTabCell" owner:self options:nil]lastObject];
        }
        cell.separatorInset = UIEdgeInsetsMake(0, MMJF_WIDTH, 0, 0);
        [cell setUpData:self.productModel.need_data];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 211;
    }else{
        return UITableViewAutomaticDimension;
    }
    
}


- (RACCommand *)clientSingleCommand{
    if (!_clientSingleCommand) {
        self.clientSingleCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [MMJF_NetworkShare v1clientSingle:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    [MBProgressHUD showSuccess:baseModel.msg];
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
        __weak typeof(self)weakSelf = self;
        [self.clientSingleCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            MMJF_Log(@"%@",x);
            weakSelf.productModel = [ClientHomeProductModel yy_modelWithJSON:x];
            [weakSelf.tableView reloadData];
        }];
    }
    return _clientSingleCommand;
}

@end
