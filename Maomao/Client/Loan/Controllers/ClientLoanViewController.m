//
//  ClientLoanViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/17.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientLoanViewController.h"
#import "MenuListView.h"
#import "ClientLoanViewModel.h"
#import "ClientManagerModel.h"
#import "ClientHomeStoreViewController.h"

@interface ClientLoanViewController (){
    
}
@property (nonatomic, strong)ClientLoanViewModel *loanViewModel;
@property (weak, nonatomic) IBOutlet UITableView *loantab;
/**
 筛选view
 */
@property (weak, nonatomic) IBOutlet UIView *screenView;

/**
 搜索配置
 */
@property (nonatomic, copy)NSDictionary *dataDic;

/**
 地区搜索配置
 */
@property (nonatomic, copy)NSArray *loanArray;

@end

@implementation ClientLoanViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
    [self.loanViewModel.netWorkViewModel.regionCommand execute:MMJF_ShareV.locatingCity ? MMJF_ShareV.locatingCity:@""];
    [self setScreenView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"贷款";
    
    [self setNetWork];
    [self setUpListViewModel];
    MMJF_Log(@"%@",NSStringFromCGRect(self.loantab.bounds));
//    [self placeholder:self.loantab.bounds type:MMJFPlaceholderViewTypeLoan];
}
//设置列表
- (void)setUpListViewModel{
    [self.loanViewModel bindViewToViewModel:self.loantab];
    __weak typeof(self)weakSelf = self;
    [self.loanViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        ClientManagerModel *model = [ClientManagerModel yy_modelWithJSON:x];
        ClientHomeStoreViewController *vc = [[ClientHomeStoreViewController alloc]init];
        vc.managerModel = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}
//设置网络请求
- (void)setNetWork{
    __weak typeof(self)weakSelf =self;
    //搜索
    [self.loanViewModel.netWorkViewModel.configCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        weakSelf.dataDic = x;
    }];
    [self.loanViewModel.netWorkViewModel.configCommand execute:nil];
    //地区搜索
    [self.loanViewModel.netWorkViewModel.regionCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"11211%@",x);
        weakSelf.loanArray = x[@"district"];
         [weakSelf.loanViewModel refresh];
         
    }];
    
}

//设置筛选按钮
- (void)setScreenView{
    
    UIImage *defImg = [UIImage imageNamed:@"xia-la-xuan-cheng-shi"];
    UIImage *selImg = [UIImage imageNamed:@"shou-qi-1"];
    NSArray *titles = @[@"产品类型", @"区域", @"印象"];
    MenuListView *menu = [[MenuListView alloc] initWithFrame:CGRectMake(self.screenView.x, self.screenView.y, MMJF_WIDTH, self.screenView.height) Titles:titles defImage:defImg selImage:selImg];
    
    __weak typeof (menu)weakMenu = menu;
    __weak typeof(self)weakSelf = self;
    
    menu.clickMenuButton = ^(MenuButton *button, NSInteger index, BOOL selected){
                MMJF_Log(@"点击了第 %ld 个按钮，选中还是取消？:%d", index, selected);
        if (index == 0) {
            weakMenu.titleKey = @"attr_value";
            NSMutableArray *mutArray = [NSMutableArray array];
            NSDictionary *dic = @{@"id":@"",@"attr_value":@"不限"};
            NSArray *array = @[dic];
            [mutArray addObjectsFromArray:array];
            [mutArray addObjectsFromArray:weakSelf.dataDic[@"type"][@"values"]];
            weakMenu.dataSource = mutArray;
        }
        else if (index == 1) {
            weakMenu.titleKey = @"name";
            NSMutableArray *mutArray = [NSMutableArray array];
            NSDictionary *dic = @{@"name":@"不限",@"id":@"",@"pid":@""};
            NSArray *array = @[dic];
            [mutArray addObjectsFromArray:array];
            [mutArray addObjectsFromArray:weakSelf.loanArray];
            weakMenu.dataSource = mutArray;
        }
        else if (index == 2) {
            weakMenu.titleKey = @"attr_value";
            NSMutableArray *mutArray = [NSMutableArray array];
            NSDictionary *dic = @{@"attr_value":@"不限",@"id":@""};
            NSArray *array = @[dic];
            [mutArray addObjectsFromArray:array];
            [mutArray addObjectsFromArray:weakSelf.dataDic[@"focus"][@"values"]];
            weakMenu.dataSource = mutArray;
        }
        [weakMenu refresh];
    };
    
    // 选中下拉列表某行时的回调（这个回调方法请务必实现！）
    menu.clickListView = ^(NSInteger tag, NSInteger index, NSDictionary *titleDic){
        MMJF_Log(@"选中了：%ld   标题：%@", index, titleDic);
        if (tag == 0) {
            weakSelf.loanViewModel.loantypeDic = titleDic;
        }else if (tag == 1){
            weakSelf.loanViewModel.cityDic = titleDic;
        }else{
            weakSelf.loanViewModel.focusDic = titleDic;
        }
        NSDictionary *dic = @{@"city":MMJF_ShareV.locatingCity ? MMJF_ShareV.locatingCity:@"",@"type":[NSString stringWithFormat:@"%@",weakSelf.loanViewModel.loantypeDic[@"id"]],@"focus_id":weakSelf.loanViewModel.focusDic[@"id"],@"region_id":[NSString stringWithFormat:@"%@",weakSelf.loanViewModel.cityDic[@"id"]]};
        NSArray *array = @[@"1",dic];
        [weakSelf.loanViewModel.netWorkViewModel.loanSearchCommand execute:array];
    };
    [self.screenView addSubview:menu];
}

- (ClientLoanViewModel *)loanViewModel{
    if (!_loanViewModel) {
        _loanViewModel = [[ClientLoanViewModel alloc]init];
    }
    return _loanViewModel;
}

@end
