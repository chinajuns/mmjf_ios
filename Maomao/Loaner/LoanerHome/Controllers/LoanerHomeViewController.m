//
//  LoanerHomeViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/17.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerHomeViewController.h"
#import "SDCycleScrollView.h"
#import "LoanerHomeCollViewModel.h"
#import "LoanerHomeMicroBCViewController.h"
#import "LoanerHomeMortgageCalculatorViewController.h"
#import "ClientMineIntegralDetailsViewController.h"
#import "LoanerHomeWalletViewController.h"
#import "ClientInformationViewController.h"
#import "CYTabBarController.h"
#import "ClientMessageViewController.h"
#import "LoanerHomeNetWorkViewModel.h"
#import "ClientHomePositionViewModel.h"
#import "LoanerMineCertificationViewController.h"
#import "ClientMineWebPageViewController.h"

@interface LoanerHomeViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;

@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet UIView *functionView;

@property (weak, nonatomic) IBOutlet UIView *grabSingleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *functionLine;
@property (weak, nonatomic) IBOutlet UILabel *total_orderLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *grabSinfleLine;
@property (weak, nonatomic) IBOutlet UICollectionView *functionCollection;

@property (nonatomic, strong)LoanerHomeCollViewModel *collViewModel;
@property (nonatomic, strong)LoanerHomeNetWorkViewModel *netWorkViewModel;
/**
 地图定位
 */
@property (nonatomic, strong)ClientHomePositionViewModel *positionViewModel;
@property (nonatomic, strong)SharePodStyleViewModel *podViewModel;
@property (nonatomic, strong)TYAlertController *alertController;
@property (weak, nonatomic) IBOutlet UIButton *positionBut;
/**
 城市
 */
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UIButton *messageBut;

@property (weak, nonatomic) IBOutlet UILabel *badgeLab;

/**
 轮播图
 */
@property (nonatomic, strong)NSMutableArray *banners;
@end

@implementation LoanerHomeViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (MMJF_ShareV.locatingCity.length == 0) {
        [self setUpPositionMap];
        //设置定位代理
        [self.positionViewModel setUpdelegate];
        //开始定位
        [self.positionViewModel startLocation];
        //定位罗盘模式
        [self.positionViewModel startFollowHeading];
    }else{
        //根据城市定位获取轮播
        NSDictionary *dic = @{@"city_name":self.cityLab.text,@"ad_position_id":@"1"};
        [self.netWorkViewModel.indexCommand execute:dic];
    }
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //移除定位
    [self.positionViewModel stopLocation];
    //移除定位代理
    [self.positionViewModel clearDelegate];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (MMJF_WIDTH == 320) {
        self.functionLine.priority = 1000;
        self.grabSinfleLine.priority = 1000;
    }
    if (MMJF_HEIGHT > 800) {
        self.topLine.constant = 52;
    }
    [self setUpCollViewModel];
    [self setUpclick];
    
    [self setUpMessage];
    //根据城市定位获取轮播(先默认成都获取)
    [self setUpData];
}
//设置未读消息
- (void)setUpMessage{
    self.badgeLab.layer.cornerRadius = 4;
    self.badgeLab.layer.masksToBounds = YES;
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.checkNoticeCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSString *str = [NSString stringWithFormat:@"%@",x[@"no_read"]];
        if ([str isEqualToString:@"1"]) {
            //进入就设置消息的小红点
            weakSelf.badgeLab.hidden = NO;
        }else{
            //进入就设置消息的小红点
            weakSelf.badgeLab.hidden = YES;
        }
    }];
    //首页:未读消息：检查
    [self.netWorkViewModel.checkNoticeCommand execute:nil];
}

//设置轮播图
- (void)setUpBanner{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, MMJF_WIDTH, self.bannerView.frame.size.height) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    cycleScrollView.imageURLStringsGroup = self.banners;
    cycleScrollView.pageControlBottomOffset = 40;
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [self.bannerView addSubview:cycleScrollView];
    
}

//设置定位ViewModel
- (void)setUpPositionMap{
    //绑定定位ViewModel
//    [self.positionViewModel bindViewToViewModel:self.mapView];
    //定位成功或失败信号订阅
    __weak typeof(self)weakSelf = self;
    [weakSelf.positionViewModel.positionSubject subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        if ([x isEqualToString:@"failure"]) {
            [MBProgressHUD showError:@"定位失败" toView:weakSelf.view];
        }else{
            
            [weakSelf.positionViewModel startFollowing];
        }
    }];
    [weakSelf.positionViewModel.locationSubject subscribeNext:^(id  _Nullable x) {
        weakSelf.cityLab.text = x[@"City"];
        MMJF_ShareV.locatingCity = x[@"City"];
        //根据城市定位获取轮播
        NSDictionary *dic = @{@"city_name":weakSelf.cityLab.text,@"ad_position_id":@"1"};
        [weakSelf.netWorkViewModel.indexCommand execute:dic];
    }];
}

//设置功能列表
- (void)setUpCollViewModel{
    [self.collViewModel bindViewToViewModel:self.functionCollection];
    __weak typeof(self)weakSelf = self;
    [weakSelf.collViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        if ([x isEqualToString:@"1"]) {
            [weakSelf jump:1];
        }else if ([x isEqualToString:@"3"]){
            NSString *str;
            if ([MMJF_ShareV.is_auth isEqualToString:@"1"]) {
                str = @"您还未实名认证，请先认证";
            }else if ([MMJF_ShareV.is_auth isEqualToString:@"2"]){
                str = @"您还在认证中，查看认证情况";
            }else if ([MMJF_ShareV.is_auth isEqualToString:@"4"]){
                str = @"您认证失败，查看认证情况";
            }else{
                [weakSelf jump:2];
                return ;
            }
            TYAlertController *alertController = [weakSelf.podViewModel setUpShareTwo:str determineStr:@"实名认证" cancelStr:@"取消"];
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
        else if ([x isEqualToString:@"5"]){
            //微名片
            LoanerHomeMicroBCViewController *vc = [[LoanerHomeMicroBCViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else if ([x isEqualToString:@"6"]){
            //房贷计算器
            ClientMineWebPageViewController *vc = [[ClientMineWebPageViewController alloc]init];
            vc.number = 6;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else if ([x isEqualToString:@"0"]){
            //积分B/C端公用
            ClientMineIntegralDetailsViewController *vc = [[ClientMineIntegralDetailsViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else if ([x isEqualToString:@"2"]){
            //钱包
            LoanerHomeWalletViewController *vc = [[LoanerHomeWalletViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        else if ([x isEqualToString:@"4"]){
            //资讯B/C端公用
            ClientInformationViewController *vc = [[ClientInformationViewController alloc]init];
            vc.isB = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (IBAction)grabSingleBut:(UIButton *)sender {
    [self jump:1];
}


//点击事件
- (void)setUpclick{
    __weak typeof(self)weakSelf = self;
    //点击消息
    [[self.messageBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        //系统消息B/C端公用
        ClientMessageViewController *vc = [[ClientMessageViewController alloc]init];
        vc.isSecondary = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    //点击定位
    [[self.positionBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        
    }];
}
//设置数据
- (void)setUpData{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.indexCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        if (![x isKindOfClass:[NSDictionary class]]) {
            MMJF_ShareV.is_auth = @"0";
        }else{
            weakSelf.banners = [NSMutableArray array];
            NSArray *banner = x[@"banner"];
            for (NSString *str in banner) {
                if ([str containsString:@"http"]) {
                    [weakSelf.banners addObject:str];
                }else{
                    NSString* str1 = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.image_url,str];
                    [weakSelf.banners addObject:str1];
                }
            }
            weakSelf.total_orderLab.text = [NSString stringWithFormat:@"今日可抢%@单",x[@"total_order"]];
            MMJF_ShareV.loaner_id = [NSString stringWithFormat:@"%@",x[@"loaner_id"]];
            MMJF_ShareV.is_auth = [NSString stringWithFormat:@"%@",x[@"is_auth"]];
        }
        
        [weakSelf setUpBanner];
    }];
}

#pragma mark--getter
- (LoanerHomeCollViewModel *)collViewModel{
    if (!_collViewModel) {
        _collViewModel = [[LoanerHomeCollViewModel alloc]init];
    }
    return _collViewModel;
}

- (LoanerHomeNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerHomeNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
}
//定位
- (ClientHomePositionViewModel *)positionViewModel{
    if (!_positionViewModel) {
        _positionViewModel= [[ClientHomePositionViewModel alloc]init];
    }
    return _positionViewModel;
}

- (SharePodStyleViewModel *)podViewModel{
    if (!_podViewModel) {
        _podViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        [_podViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            //实名认证
            LoanerMineCertificationViewController *VC= [[LoanerMineCertificationViewController alloc]init];
            [weakSelf.navigationController pushViewController:VC animated:YES];
        }];
    }
    return _podViewModel;
}
@end
