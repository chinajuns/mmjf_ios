//
//  ClientRightDrawerViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/11/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientRightDrawerViewModel.h"
#import "HomeReusableView.h"
#import "ClientRightCollectionViewCell.h"
static NSString *const identify = @"ClientRightCollectionViewCell";
static NSString *const reusa = @"HomeReusableView";
@interface ClientRightDrawerViewModel()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableDictionary *_chooseDict;
    NSArray *_dataSouce;
}
@property (nonatomic, strong)UICollectionView *collectionView;
@end
@implementation ClientRightDrawerViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _chooseDict = [NSMutableDictionary dictionary];
        [self clientAttrConfig];
    }
    return self;
}

- (void)bindViewToViewModel:(UIView *)view {
    self.collectionView = (UICollectionView *)view;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ClientRightCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identify];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusa];
}

#pragma mark-UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _dataSouce.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = _dataSouce[section][@"values"];
    return array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //重用cell
    ClientRightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    NSDictionary *dic = _dataSouce[indexPath.section][@"values"][indexPath.row];
    [cell.rightBut setTitle:dic[@"options"] forState:UIControlStateNormal];
    NSDictionary *dic1 = [_chooseDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
    NSString *str = dic1[@"row"];
    cell.rightBut.selected = NO;
    cell.rightBut.backgroundColor = [UIColor whiteColor];
    cell.rightBut.layer.borderWidth = 0.5;
    if (str.length != 0) {
        if (indexPath.row == [str integerValue]) {
            cell.rightBut.selected = YES;
            cell.rightBut.backgroundColor = [UIColor colorWithHexString:@"#fff6cc"];
            cell.rightBut.layer.borderWidth = 0;
        }
    }
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = [NSString stringWithFormat:@"%@",_dataSouce[indexPath.section][@"id"]];
    if ([Id isEqualToString:@"1"] || [Id isEqualToString:@"2"]) {
        return CGSizeMake((collectionView.width - 40) / 2, 25);
    }
    return CGSizeMake((collectionView.width - 50) / 3, 25);
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 12, 0, 12);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(MMJF_WIDTH, 45);

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HomeReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reusa forIndexPath:indexPath];
    for (UIView *view in header.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.section != 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 5, collectionView.width, 1)];
        view.backgroundColor = MMJF_COLOR_Gray;
        [header addSubview:view];
    }
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(10, 5, 200, 35);
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"#1a1a1a"];
    NSDictionary *dic = _dataSouce[indexPath.section];
    label.text = dic[@"name"];
    [header addSubview:label];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataSouce[indexPath.section][@"values"][indexPath.row];
    NSDictionary *dic1 = @{@"name":_dataSouce[indexPath.section][@"name"],@"row":[NSString stringWithFormat:@"%ld",indexPath.row],@"id":dic[@"id"]};
    [_chooseDict setObject:dic1 forKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
    MMJF_Log(@"ffff%@",_chooseDict);
    [self.collectionView reloadData];
}

/**
 获取筛选条件
 */
- (NSDictionary *)getScreeningIds{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < _dataSouce.count; i ++) {
        id object = [_chooseDict objectForKey:[NSString stringWithFormat:@"%d",i]];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSString *str = object[@"name"];
            if ([str isEqualToString:@"需求额度"]) {
                NSDictionary *dic = @{@"loan_number":object[@"id"]};
                [mutDic addEntriesFromDictionary:dic];
            }else if ([str isEqualToString:@"贷款期限"]){
                NSDictionary *dic = @{@"time_limit":object[@"id"]};
                [mutDic addEntriesFromDictionary:dic];
            }else if ([str isEqualToString:@"放款时间"]){
                NSDictionary *dic = @{@"loan_day":object[@"id"]};
                [mutDic addEntriesFromDictionary:dic];
            }else if ([str isEqualToString:@"还款方式"]){
                NSDictionary *dic = @{@"way":object[@"id"]};
                [mutDic addEntriesFromDictionary:dic];
            }
        }
    }
    
    return mutDic.copy;
}

- (void)emptyChoose{
    [_chooseDict removeAllObjects];
    [self.collectionView reloadData];
}

///C端：首页:搜索配置
- (void)clientAttrConfig{
    self.clientAttrConfigCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block调用：执行命令的时候就会调用
        MMJF_Log(@"%@", input);
        [MBProgressHUD showMessage:@"正在加载" toView:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:nil];
        });
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [MMJF_NetworkShare v1clientAttrConfig:^(MMJFBaseModel *baseModel) {
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
    __weak typeof(self)weakSelf =self;
    [self.clientAttrConfigCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        _dataSouce = x;
        [weakSelf.collectionView reloadData];
    }];
}
@end
