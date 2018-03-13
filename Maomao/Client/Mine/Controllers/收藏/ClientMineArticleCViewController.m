//
//  ClientMineArticleCViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineArticleCViewController.h"
#import "ClientMineArticleCViewModel.h"
#import "ClientInformationDetailsViewController.h"

@interface ClientMineArticleCViewController ()
@property (weak, nonatomic) IBOutlet UITableView *articleTab;
@property (nonatomic, strong)ClientMineArticleCViewModel *artictleViewModel;
@end

@implementation ClientMineArticleCViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.artictleViewModel refreshData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpListViewModel];
}

- (void)setUpListViewModel{
    [self.artictleViewModel bindViewToViewModel:self.articleTab];
    __weak typeof(self)weakSelf = self;
    [self.artictleViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        ClientInformationDetailsViewController *vc = [[ClientInformationDetailsViewController alloc]init];
        vc.model = x;
        vc.isMy = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (ClientMineArticleCViewModel *)artictleViewModel{
    if (!_artictleViewModel) {
        _artictleViewModel = [[ClientMineArticleCViewModel alloc]init];
    }
    return _artictleViewModel;
}



@end
