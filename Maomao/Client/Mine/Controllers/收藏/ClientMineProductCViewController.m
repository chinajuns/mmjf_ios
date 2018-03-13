//
//  ClientMineProductCViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineProductCViewController.h"
#import "ClientMineProductCViewModel.h"
#import "ClientHomeStoreViewController.h"

@interface ClientMineProductCViewController ()
@property (weak, nonatomic) IBOutlet UITableView *productTab;


@property (nonatomic, strong)ClientMineProductCViewModel *productViewModel;
@end

@implementation ClientMineProductCViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.productViewModel refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUplistViewModel];
    
}

- (void)setUplistViewModel{
    [self.productViewModel bindViewToViewModel:self.productTab];
    __weak typeof(self)weakSelf = self;
    [self.productViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        ClientHomeStoreViewController *vc = [[ClientHomeStoreViewController alloc]init];
        vc.model = x;
        vc.isMy = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}


- (ClientMineProductCViewModel *)productViewModel{
    if (!_productViewModel) {
        _productViewModel = [[ClientMineProductCViewModel alloc]init];
    }
    return _productViewModel;
}



@end
