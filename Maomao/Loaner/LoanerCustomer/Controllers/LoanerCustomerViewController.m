//
//  LoanerCustomerViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/17.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerCustomerViewController.h"
#import "MenuListView.h"
#import "LoanerCustomerViewModel.h"
#import "LoanerHomeTopUpViewController.h"//积分充值

#import "LoanerMineCertificationViewController.h"
#import "LoanerCustomerDetailsViewController.h"
#import "LoanerStoreCustomerOrderViewController.h"

@interface LoanerCustomerViewController ()
@property (weak, nonatomic) IBOutlet UIView *dropDownMenuView;

@property (weak, nonatomic) IBOutlet UITableView *grabSingleTab;

@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;

@property (nonatomic, strong)LoanerCustomerViewModel *customerViewModel;

@property (nonatomic, copy)NSDictionary *vipDic;

@property (nonatomic, copy)NSDictionary *regionDic;
@property (nonatomic, copy)NSArray *loanArray;

@property (nonatomic, copy)NSDictionary *houseDic;

/**
 抢单id
 */
@property (nonatomic, copy)NSString *Id;
@property (nonatomic, copy)NSDictionary *carDic;

/**
 点击抢单获取改单积分
 */
@property (nonatomic, copy)NSString *scoreStr;
/**
 车产
 */
@property (nonatomic, copy)NSArray *carArray;
/**
 房产
 */
@property (nonatomic, copy)NSArray *roomArray;
@end

@implementation LoanerCustomerViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抢单";
    [self setNetWork];
    [self setScreenView];
    [self setUpListViewModel];
}

- (void)setNetWork{
    __weak typeof(self)weakSelf = self;
    //地区搜索
    [self.customerViewModel.netWorkViewModel.regionCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"%@",x);
         weakSelf.loanArray = x[@"district"];
     }];
    [self.customerViewModel.netWorkViewModel.regionCommand execute:MMJF_ShareV.locatingCity ? MMJF_ShareV.locatingCity:@""];
    //B端：首页-抢单-检查抢单资格
    [self.customerViewModel.netWorkViewModel.checkPurchaseCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"%@",x);
         NSString *is_auth = [NSString stringWithFormat:@"%@",x[@"is_auth"]];
         NSString *my_score = [NSString stringWithFormat:@"%@",x[@"my_score"]];
         NSString *is_mine = [NSString stringWithFormat:@"%@",x[@"is_mine"]];
         if ([is_mine isEqualToString:@"1"]) {//1自己的单子 0不是
             [MBProgressHUD showError:@"不能抢自己的单子"];
             return ;
         }
         if ([is_auth isEqualToString:@"3"]){
             if ([my_score floatValue] < [weakSelf.scoreStr floatValue]) {
                 [weakSelf lackIntegral];//积分不足
             }else{//支付
                 [weakSelf payPop:weakSelf.scoreStr];
             }
         }else{
             NSString *str;
             if ([is_auth isEqualToString:@"1"]) {
                 str = @"您还未实名认证，请先认证";
             }else if ([is_auth isEqualToString:@"2"]){
                 str = @"您还在认证中，查看认证情况";
             }else if ([is_auth isEqualToString:@"4"]){
                 str = @"您认证失败，查看认证情况";
             }else{
                 str = @"您认证失败，查看认证情况";
             }
             TYAlertController *alertController = [weakSelf.podStyleViewModel setUpShareTwo:str determineStr:@"实名认证" cancelStr:@"取消"];
             [weakSelf presentViewController:alertController animated:YES completion:nil];
         }

    }];
    //B端：首页-抢单-立即支付
    [self.customerViewModel.netWorkViewModel.purchaseCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"%@",x);
         if ([x isEqualToString:@"200"]) {
             [weakSelf dismissViewControllerAnimated:YES completion:nil];
             [weakSelf successful:weakSelf.scoreStr];
         }
         
     }];
    //B！抢单:配置
    [self.customerViewModel.netWorkViewModel.grabConfigCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         if ([x isKindOfClass:[NSArray class]]) {
             weakSelf.carArray = x[0][@"values"];
             weakSelf.roomArray = x[1][@"values"];
         }
    }];
    //B！抢单:配置
    [self.customerViewModel.netWorkViewModel.grabConfigCommand execute:nil];
}

//设置筛选按钮
- (void)setScreenView{
    UIImage *defImg = [UIImage imageNamed:@"xia-la-xuan-cheng-shi"];
    UIImage *selImg = [UIImage imageNamed:@"shou-qi-1"];
    NSArray *titles = @[@"订单类型", @"城市", @"车产情况",@"房产情况"];
    MenuListView *menu = [[MenuListView alloc] initWithFrame:CGRectMake(self.dropDownMenuView.x, self.dropDownMenuView.y, MMJF_WIDTH, self.dropDownMenuView.height) Titles:titles defImage:defImg selImage:selImg];
    menu.titleKey = @"tval";
    __weak typeof (menu)weakMenu = menu;
    __weak typeof(self)weakSelf = self;
    
    menu.clickMenuButton = ^(MenuButton *button, NSInteger index, BOOL selected){
        MMJF_Log(@"点击了第 %ld 个按钮，选中还是取消？:%d", index, selected);
        
        if (index == 0) {
            weakMenu.titleKey = @"tval";
            NSDictionary *dic = @{@"tval":@"会员订单",@"id":@"1"};
            NSDictionary *dic1 = @{@"tval":@"普通订单",@"id":@"0"};
            NSDictionary *dic2 = @{@"tval":@"全部订单",@"id":@""};
            weakMenu.dataSource = @[dic2,dic,dic1];
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
            if (weakSelf.carArray.count == 0) {
                NSDictionary *dic = @{@"id":@"",@"attr_value":@"暂无数据",@"pid":@""};
                weakMenu.dataSource = @[dic];
            }else{
                NSDictionary *dic = @{@"attr_value":@"不限",@"id":@"",@"pid":@""};
                NSMutableArray *mutArray = [NSMutableArray array];
                [mutArray addObject:dic];
                [mutArray addObjectsFromArray:weakSelf.carArray];
               weakMenu.dataSource = mutArray;
            }
        }else{
            weakMenu.titleKey = @"attr_value";
            if (weakSelf.roomArray.count == 0) {
                NSDictionary *dic = @{@"id":@"",@"attr_value":@"暂无数据",@"pid":@""};
                weakMenu.dataSource = @[dic];
            }else{
                NSDictionary *dic = @{@"attr_value":@"不限",@"id":@"",@"pid":@""};
                NSMutableArray *mutArray = [NSMutableArray array];
                [mutArray addObject:dic];
                [mutArray addObjectsFromArray:weakSelf.roomArray];
               weakMenu.dataSource = mutArray;
            }
        }
        [weakMenu refresh];
    };
    
    // 选中下拉列表某行时的回调（这个回调方法请务必实现！）
    menu.clickListView = ^(NSInteger tag, NSInteger index, NSDictionary *titleDic){
        MMJF_Log(@"选中了：%ld   标题：%@", tag, titleDic);
        if (tag == 0) {
            weakSelf.vipDic = titleDic;
        }else if (tag == 1){
            weakSelf.regionDic = titleDic;
        }else if (tag == 2){
            weakSelf.carDic = titleDic;
        }else{
            weakSelf.houseDic = titleDic;
        }
        [weakSelf.customerViewModel setParameter:weakSelf.vipDic[@"id"] region_id:weakSelf.regionDic[@"id"] has_house:weakSelf.houseDic[@"id"] has_car:weakSelf.carDic[@"id"]];
    };
    [self.dropDownMenuView addSubview:menu];
}
//设置列表
- (void)setUpListViewModel{
    [self.customerViewModel bindViewToViewModel:self.grabSingleTab];
    __weak typeof(self)weakSelf = self;
    [self.customerViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        weakSelf.scoreStr = [NSString stringWithFormat:@"%@",x[@"score"]];
        weakSelf.Id = [NSString stringWithFormat:@"%@",x[@"id"]];
        NSDictionary *dic = @{@"id":weakSelf.Id};
        [weakSelf.customerViewModel.netWorkViewModel.checkPurchaseCommand execute:dic];
    }];
    [self.customerViewModel.listClickSubject subscribeNext:^(id  _Nullable x) {
        LoanerCustomerDetailsViewController *vc = [[LoanerCustomerDetailsViewController alloc]init];
        vc.ID = [NSString stringWithFormat:@"%@",x[@"id"]];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}
//积分不足提示
- (void)lackIntegral{
    TYAlertController *alertController = [self.podStyleViewModel setUpShareTwo:@"积分不足，立即购买" determineStr:@"确定" cancelStr:@"取消" ];
    [self presentViewController:alertController animated:YES completion:nil];
}
//支付提示
- (void)payPop:(NSString *)str{
    TYAlertController *alertController = [self.podStyleViewModel setUpShareTitleTwoView:@"支付" soce:str unit:@"积分（分）"];
    [self presentViewController:alertController animated:YES completion:nil];
}
//抢单
- (void)successful:(NSString *)str{
    TYAlertController *alertController = [self.podStyleViewModel setUpSharePictureTwoView:@"抢单成功" img:@"cheng-gong" butTitle:@"确定" prompt1:@"支付方式：积分" prompt2:[NSString stringWithFormat:@"支付金额：%@积分",str]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (LoanerCustomerViewModel *)customerViewModel{
    if (!_customerViewModel) {
        _customerViewModel = [[LoanerCustomerViewModel alloc]init];
    }
    return _customerViewModel;
}

- (SharePodStyleViewModel *)podStyleViewModel{
    if (!_podStyleViewModel) {
        _podStyleViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        //点击
        [_podStyleViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            if ([x isEqualToString:@"积分不足，立即购买"]) {
                LoanerHomeTopUpViewController *VC = [[LoanerHomeTopUpViewController alloc]init];
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }else if ([x isEqualToString:@"您还未实名认证，请先认证"] || [x isEqualToString:@"您还在认证中，查看认证情况"] || [x isEqualToString:@"您认证失败，查看认证情况"]){
                //实名认证
                LoanerMineCertificationViewController *VC= [[LoanerMineCertificationViewController alloc]init];
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }else if ([x isEqualToString:@"支付"]){
                NSDictionary *dic = @{@"id":weakSelf.Id};
                [weakSelf.customerViewModel.netWorkViewModel.purchaseCommand execute:dic];
            }else if ([x isEqualToString:@"抢单成功"]){
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                LoanerStoreCustomerOrderViewController *vc = [[LoanerStoreCustomerOrderViewController alloc]init];
                vc.isRefer = NO;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _podStyleViewModel;
}
@end
