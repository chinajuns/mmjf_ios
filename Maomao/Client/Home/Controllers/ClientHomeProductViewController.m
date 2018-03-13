//
//  ClientHomeProductViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/29.
//  Copyright © 2017年 御顺. All rights reserved.
//  产品详情

#import "ClientHomeProductViewController.h"
#import "ClientHomeProductListViewModel.h"
#import "ClientHomeLoanInputViewController.h"
//#import "ClientHomeEvaluationViewController.h"

@interface ClientHomeProductViewController ()
/**
 贷款tab
 */
@property (weak, nonatomic) IBOutlet UITableView *productTab;

@property (nonatomic, strong)ClientHomeProductListViewModel *productListViewModel;
@end

@implementation ClientHomeProductViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品详情";
    [self setUpProductListView];
}
//我要贷款
- (IBAction)loanBut:(UIButton *)sender {
    ClientHomeLoanInputViewController *vc = [[ClientHomeLoanInputViewController alloc]init];
    vc.loaner_id = self.loaner_id;
    vc.product_id = self.Id;
    [self.navigationController pushViewController:vc animated:YES];
}

//设置列表
- (void)setUpProductListView{
    [self.productListViewModel bindViewToViewModel:self.productTab];
    NSDictionary *dic = @{@"loaner_id":self.loaner_id,@"id":self.Id,@"platform":@"system"};
    [self.productListViewModel.clientSingleCommand execute:dic];
    
}

#pragma mark--getter
- (ClientHomeProductListViewModel *)productListViewModel{
    if (!_productListViewModel) {
        _productListViewModel = [[ClientHomeProductListViewModel alloc]init];
    }
    return _productListViewModel;
}

@end
