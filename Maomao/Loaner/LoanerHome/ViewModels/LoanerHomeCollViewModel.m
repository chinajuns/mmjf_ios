//
//  LoanerHomeCollViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerHomeCollViewModel.h"
#import "LoanerHomeCollCell.h"

static NSString *const identify = @"LoanerHomeCollCell";
@interface LoanerHomeCollViewModel()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *_imageArray;
    NSArray *_titleArray;
}
@property (nonatomic, strong)UICollectionView *collectionView;
@end
@implementation LoanerHomeCollViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
        _imageArray = @[@"ji-fen-2",@"qiang-dan",@"qian-bao",@"shaui-dan",@"zi-xun",@"wei-ming-pian",@"fang-dai-ji-suan-qi"];
        _titleArray = @[@"积分",@"抢单",@"钱包",@"甩单",@"资讯",@"微名片",@"房贷计算器"];
    }
    return self;
}

- (void)bindViewToViewModel:(UICollectionView *)view {
    self.collectionView = view;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"LoanerHomeCollCell" bundle:nil] forCellWithReuseIdentifier:identify];
}

#pragma mark-UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //重用cell
    LoanerHomeCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.cardImage.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.cardLab.text = _titleArray[indexPath.row];
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 75);
    
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return (MMJF_WIDTH - 280)/5;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (MMJF_WIDTH == 320) {
        return 5;
    }else{
       return 20;
    }
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (MMJF_WIDTH == 320) {
        return UIEdgeInsetsMake(5, 10, 0, 10);
    }else{
        return UIEdgeInsetsMake(29, 10, 0, 10);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.clickSubject sendNext:[NSString stringWithFormat:@"%ld",indexPath.row]];
}

@end
