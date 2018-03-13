//
//  ClientHomeViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/17.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeViewController.h"
#import "XLCardSwitch.h"
#import "FDSlideBar.h"
#import "ClientHomeTitleView.h"
#import "UITabBar+badge.h"
#import "ClientHomeStoreViewController.h"
#import "GYZChooseCityController.h"

#import "ClientHomePositionViewModel.h"
//#import "ClientHomeMarkMapViewModel.h"
#import "ClientHomeDistrictMongoliaViewModel.h"
#import "ClientHomeViewModel.h"

//#import "ClientGeocodeViewModel.h"

@interface ClientHomeViewController ()<GYZChooseCityDelegate,XLCardSwitchDelegate>
@property (nonatomic,strong) XLCardSwitch *cardSwitch;
/**
 获得滑动到那个位置
 */
@property (nonatomic,assign) NSInteger currentIndex;
/**
 列表数据view
 */
@property (weak, nonatomic) IBOutlet UIView *backView;
/**
 头部多按钮
 */
@property (strong, nonatomic) FDSlideBar *slideBar;
@property (weak, nonatomic) IBOutlet UIView *promptView;

/**
 首页网络请求
 */
@property (nonatomic, strong)ClientHomeViewModel *homeViewModel;
/**
 头部按钮
 */
@property (weak, nonatomic) IBOutlet UIView *topBackView;
/**
 头部选中按钮
 */
@property (nonatomic, copy)NSString *topStr;
@property (nonatomic, copy)NSString *topId;
/**
 区
 */
@property (nonatomic, copy)NSString *areaStr;
/**
 区ID
 */
@property (nonatomic, copy)NSString *areaID;
@property (nonatomic, strong)UIButton *leftBut;

/**
 列表数据
 */
@property (nonatomic, copy)NSArray *dataList;
/**
 标题定位
 */
@property (nonatomic, copy)NSString *positionStr;
@property (nonatomic, strong)ClientHomeTitleView *card;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

/**
 地图定位
 */
@property (nonatomic, strong)ClientHomePositionViewModel *positionViewModel;

/**
 标注
 */
//@property (nonatomic, strong)ClientHomeMarkMapViewModel *markMapViewModel;

/**
 划分行政区
 */
@property (nonatomic, strong)ClientHomeDistrictMongoliaViewModel *districtViewModel;

/**
 编码
 */
//@property (nonatomic, strong)ClientGeocodeViewModel *geocodeViewModel;

/**
 头部筛选条件
 */
@property (nonatomic, copy)NSArray *topArray;
@property (weak, nonatomic) IBOutlet UILabel *promptLab;

@property (nonatomic, copy)NSDictionary *idsDic;
@end

@implementation ClientHomeViewController

- (void)dealloc{
    self.mapView = nil;
    self.positionViewModel = nil;
    self.districtViewModel = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.mapView viewWillAppear];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if (self.positionStr.length == 0) {
        //设置定位代理
        [self.positionViewModel setUpdelegate];
        //开始定位
        [self.positionViewModel startLocation];
        //定位罗盘模式
        [self.positionViewModel startFollowHeading];
        
    }
    self.districtViewModel.isMark = NO;
    [self.districtViewModel setUpdelegate];
     [self setUpNavigation];
    [self cancel:nil];
    //获取
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ClientRightDrawerViewController:) name:@"ClientRightDrawerViewController" object:nil];
}

//移除
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.mapView viewWillDisappear];
    //移除定位
    [self.positionViewModel stopLocation];
    //移除定位代理
    [self.positionViewModel clearDelegate];
    [self.districtViewModel clearDelegate];
    self.cardSwitch.hidden = YES;
    [self.card removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.districtViewModel bindViewToViewModel:self.mapView];
    
    //设置定位ViewModel
    [self setUpPositionMap];
    [self setUpLisetViewModel];
    ///设置头部多按钮
    [self setupSlideBar];
}
//筛选通知方法
- (void)ClientRightDrawerViewController:(NSNotification *)bitice{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    NSDictionary *ids = bitice.userInfo;
    if ([ids allKeys].count == 0) {
        self.idsDic = @{};
    }else{
        self.idsDic = ids;
        [mutDic addEntriesFromDictionary:ids];
    }
    NSDictionary *dic = @{@"city":self.positionStr};
    if (self.positionStr.length == 0) {
        //获取首页:顾问推荐
        [self.homeViewModel.clientManagerCommand execute:nil];
    }else{
        [mutDic addEntriesFromDictionary:dic];
        self.areaStr = @"";
        self.districtViewModel.isRegion = NO;
        self.districtViewModel.isMark = NO;
        //首页:地图搜索
        if (self.areaStr.length != 0) {
            NSDictionary *dic1 = @{@"region":self.areaID};
            [mutDic addEntriesFromDictionary:dic1];
        }else if (self.topStr.length != 0){
            NSDictionary *dic2 = @{@"type":self.topId};
            [mutDic addEntriesFromDictionary:dic2];
        }
        MMJF_Log(@"%@",mutDic);
        [self.homeViewModel.clientMapCommand execute:mutDic.copy];
    }
}

///设置头部多按钮
- (void)setupSlideBar {
    [self setUpToData];
    [self.topBackView addSubview:self.slideBar];
}
//移动动画
- (void)changeFrame:(UIButton *)sender{
    [UIView beginAnimations:@"FrameAni"context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if (sender.selected) {
        self.topBackView.frame = CGRectMake(self.topBackView.x, 0, self.topBackView.width, self.topBackView.height);
    }else{
       self.topBackView.frame = CGRectMake(self.topBackView.x, -50, self.topBackView.width, self.topBackView.height);
    }
    
    [UIView commitAnimations];
}
//设置首页数据
- (void)setUpHomeData{
    //获取首页:顾问推荐
    [self.homeViewModel.clientManagerCommand execute:nil];
}
//设置头部筛选数据
- (void)setUpToData{
    __weak typeof(self)weakSelf = self;
    //首页:地图：顶部条件
    [self.homeViewModel.topConfigCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        NSArray *values = x[0][@"values"];
        weakSelf.topArray = values;
        NSMutableArray *mutArray = [NSMutableArray array];
        [mutArray addObject:@"全部"];
        for (NSDictionary *dic in values) {
            [mutArray addObject:dic[@"name"]];
        }
        weakSelf.slideBar.itemsTitle = mutArray;
        weakSelf.slideBar.itemColor = [UIColor colorWithHexString:@"#b3b3b3"];
        weakSelf.slideBar.itemSelectedColor = [UIColor colorWithHexString:@"#4d4d4d"];
    }];
    //首页:地图：顶部条件
    [self.homeViewModel.topConfigCommand execute:nil];
    
}

#pragma mark--设置viewModel
//设置listViewModel
- (void)setUpLisetViewModel{
    _cardSwitch = [[XLCardSwitch alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, 170)];
    _cardSwitch.delegate = self;
    //分页切换
    _cardSwitch.pagingEnabled = true;
    [self.backView addSubview:_cardSwitch];
    __weak typeof(self)weakSelf = self;
    [self.homeViewModel.clientManagerCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        weakSelf.cardSwitch.items = x;
        weakSelf.dataList = x;
        weakSelf.currentIndex = 0;
        [weakSelf.cardSwitch switchToIndex:0 animated:NO];
    }];
    
    //首页:地图搜索
    [self.homeViewModel.clientMapCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        weakSelf.cardSwitch.hidden = NO;
        [weakSelf.districtViewModel addPointAnnotation:x[@"map"]];
        if (weakSelf.areaStr.length != 0) {
            [weakSelf.districtViewModel districtSearch:weakSelf.areaStr];
        }
        NSArray *array = x[@"list"][@"data"];
        if (array.count == 0) {
            weakSelf.cardSwitch.hidden = YES;
            weakSelf.promptView.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.promptView.hidden = YES;
            });
            return ;
        }
        weakSelf.cardSwitch.items = x[@"list"][@"data"];
        weakSelf.dataList = x[@"list"][@"data"];
        weakSelf.currentIndex = 0;
        [weakSelf.cardSwitch switchToIndex:0 animated:NO];
    }];
}

#pragma mark CardSwitchDelegate

- (void)XLCardSwitchDidSelectedAt:(NSInteger)index {
    MMJF_Log(@"选中了：%zd",index);
    if (index > self.dataList.count - 1) {
        return;
    }
    NSDictionary *dic = self.dataList[index];
    ClientHomeStoreViewController *vc = [[ClientHomeStoreViewController alloc]init];
    vc.managerModel = [ClientManagerModel yy_modelWithJSON:dic];
    [self.navigationController pushViewController:vc animated:YES];
}


//设置定位ViewModel
- (void)setUpPositionMap{
    //定位成功或失败信号订阅
    __weak typeof(self)weakSelf = self;
    //绑定定位ViewModel
    [self.positionViewModel bindViewToViewModel:weakSelf.mapView];
    
    [weakSelf.positionViewModel.positionSubject subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        if ([x isEqualToString:@"failure"]) {
            [MBProgressHUD showError:@"定位失败" toView:weakSelf.view];
            weakSelf.card.positionStr.text = @"定位失败";
            //设置首页数据
            [weakSelf setUpHomeData];
        }else{
            [weakSelf.positionViewModel startFollowing];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.positionViewModel stopLocation];
            });
            
            
        }
    }];
    [weakSelf.positionViewModel.locationSubject subscribeNext:^(id  _Nullable x) {
        weakSelf.card.positionStr.text = x[@"City"];
        weakSelf.positionStr = x[@"City"];
        [weakSelf setUpGeocode];
        //首页:地图搜索
        NSDictionary *dic = @{@"city":weakSelf.positionStr};
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
        [mutDic addEntriesFromDictionary:dic];
        [mutDic addEntriesFromDictionary:weakSelf.idsDic];
        [weakSelf.homeViewModel.clientMapCommand execute:mutDic.copy];
        MMJF_ShareV.locatingCity = x[@"City"];
    }];
}
//设置定位标注
- (void)setUpMarkMap{
    __weak typeof(self)weakSelf = self;
    //点击
    [weakSelf.districtViewModel.mapclickSubject  subscribeNext:^(id  _Nullable x) {
        NSDictionary *dic;
        NSString *title = x[@"title"];
        if ([title isEqualToString:@"全取消"]) {
            weakSelf.areaStr = @"";
            weakSelf.areaID = @"";
//            [weakSelf.districtViewModel remove];
            if (weakSelf.topStr.length == 0) {
                //首页:地图搜索
                dic = @{@"city":weakSelf.positionStr};
            }else{
                //首页:地图搜索
                dic = @{@"city":weakSelf.positionStr,@"type":weakSelf.topId};
            }
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            [mutDic addEntriesFromDictionary:dic];
            [mutDic addEntriesFromDictionary:weakSelf.idsDic];
            [weakSelf.homeViewModel.clientMapCommand execute:mutDic.copy];
        }else if ([title isEqualToString:@"取消"]){
            weakSelf.areaStr = @"";
            weakSelf.areaID = @"";
//            [weakSelf.districtViewModel remove];
        }
        else{
//            [weakSelf setUpDistrict];
            [weakSelf.districtViewModel districtSearch:x[@"title"]];
            weakSelf.areaStr = x[@"title"];
            weakSelf.areaID = x[@"ID"];
            if (weakSelf.topStr.length == 0) {
                //首页:地图搜索
                dic = @{@"city":weakSelf.positionStr,@"region":weakSelf.areaID};
            }else{
                //首页:地图搜索
                dic = @{@"city":weakSelf.positionStr,@"region":weakSelf.areaID,@"type":weakSelf.topId};
            }
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            [mutDic addEntriesFromDictionary:dic];
            [mutDic addEntriesFromDictionary:weakSelf.idsDic];
            [weakSelf.homeViewModel.clientMapCommand execute:mutDic.copy];
        }
        
    }];
}
//划分行政区
- (void)setUpDistrict{
    __weak typeof(self)weakSelf = self;
    
    [weakSelf.districtViewModel.retrieveSubject subscribeNext:^(id  _Nullable x) {
        
    }];
}
//设置编码
- (void)setUpGeocode{
    [self.districtViewModel onClickGeocode:self.positionStr];
    __weak typeof(self)weakSelf = self;
    [weakSelf.districtViewModel.geoCodeSubject subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[NSDictionary class]]) {//成功
            MMJF_ShareV.lat = x[@"lat"];
            MMJF_ShareV.lng = x[@"lng"];
        }else{
            
        }
        //设置定位标注
        [weakSelf setUpMarkMap];
    }];
    
}

//设置小红点
- (void)littleEed{
    __weak typeof(self)weakSelf = self;
    [self.homeViewModel.checkNoticeCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSString *str = [NSString stringWithFormat:@"%@",x[@"no_read"]];
        if ([str isEqualToString:@"1"]) {
            //进入就设置消息的小红点
            [weakSelf.tabBarController.tabBar showBadgeOnItmIndex:3];
        }else{
            //进入就设置消息的小红点
            [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
        
    }];
    //首页:未读消息：检查
    [self.homeViewModel.checkNoticeCommand execute:nil];
}

#pragma mark--设置导航条
- (void)setUpNavigation{
    __weak typeof(self)weakSelf = self;
    ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
    if (user) {
        [self littleEed];
    }
    [self setNavigationTitle];
    self.leftBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBut setImage:[UIImage imageNamed:@"lei-xing-shang-la"] forState:UIControlStateNormal];
    [self.leftBut setImage:[UIImage imageNamed:@"lei-xing-xia-la"] forState:UIControlStateSelected];
    self.leftBut.frame = CGRectMake(0, 0, 50, 44);
    [self.leftBut setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    [view addSubview:self.leftBut];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem= leftItem;
    
    //按钮点击
    [[weakSelf.leftBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf changeFrame:x];
        x.selected = !x.selected;
    }];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:[UIImage imageNamed:@"shai-xuan"] forState:UIControlStateNormal];
    [right setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    right.frame = CGRectMake(0, 0, 50, 44);
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem= rightItem;
    //打开右抽屉
    [[right rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
       [weakSelf.viewDeckController openSide:IIViewDeckSideRight animated:YES];
    }];
    
}
//设置导航栏中间按钮
- (void)setNavigationTitle{
    self.navigationItem.titleView = [UIView new];
    self.card = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeTitleView" owner:self options:nil] lastObject];
    //iOS 11的坑老方法加载按钮不能点击 --已填
    self.card.frame = CGRectMake(self.navigationController.navigationBar.x + 80, 0, self.navigationController.navigationBar.width - 160, self.navigationController.navigationBar.height);
    [self.navigationController.navigationBar addSubview:self.card];
    
    __weak typeof(self)weakSelf = self;
    //点击事件
    [[weakSelf.card.clickBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        GYZChooseCityController *cityPickerVC = [[GYZChooseCityController alloc] init];
        
        [cityPickerVC setDelegate:weakSelf];
        cityPickerVC.hotCitys = @[@"100010000", @"200010000", @"300210000", @"600010000", @"300110000"];
        [weakSelf presentViewController:cityPickerVC animated:YES completion:nil];
    }];
}

#pragma mark - GYZCityPickerDelegate
- (void)cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.card.positionStr.text = city.cityName;
        self.positionStr = city.cityName;
        MMJF_ShareV.locatingCity = city.cityName;
        [self mapSearch];
        //设置编码
        [self setUpGeocode];
    });
    
    [chooseCityController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController{
    
}

- (void)cancel:(GYZChooseCityController *)cancel{
    if (self.positionStr.length == 0) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.card.positionStr.text = self.positionStr;
        self.positionStr = self.positionStr;
        MMJF_ShareV.locatingCity = self.positionStr;
        [self mapSearch];
        //设置编码
        [self setUpGeocode];
    });
}

#pragma mark--getter

//定位
- (ClientHomePositionViewModel *)positionViewModel{
    if (!_positionViewModel) {
        _positionViewModel= [[ClientHomePositionViewModel alloc]init];
    }
    return _positionViewModel;
}

//划分行政区
- (ClientHomeDistrictMongoliaViewModel *)districtViewModel{
    if (!_districtViewModel) {
        _districtViewModel = [[ClientHomeDistrictMongoliaViewModel alloc]init];
    }
    return _districtViewModel;
}


//网络请求
- (ClientHomeViewModel *)homeViewModel{
    if (!_homeViewModel) {
        _homeViewModel = [[ClientHomeViewModel alloc]init];
    }
    return _homeViewModel;
}
//列表选择
- (FDSlideBar *)slideBar{
    if (!_slideBar) {
        _slideBar = [[FDSlideBar alloc] init];
        _slideBar.backgroundColor = [UIColor whiteColor];
        // Set some style to the slideBar
        
        _slideBar.sliderColor = [UIColor colorWithHexString:@"#4d4d4d"];
        __weak typeof(self)weakSelf = self;
        // Add the callback with the action that any item be selected
        [_slideBar slideBarItemSelectedCallback:^(NSUInteger idx) {
            weakSelf.districtViewModel.isRegion = NO;
            NSDictionary *dic;
            if (idx == 0) {
                weakSelf.topStr = @"";
                weakSelf.topId = @"";
                weakSelf.areaStr = @"";
                if (weakSelf.areaStr.length == 0) {
                    dic = @{@"city":weakSelf.positionStr};
                }else{
                    dic = @{@"city":weakSelf.positionStr,@"region":weakSelf.areaID};
                }
                
            }else{
                weakSelf.areaStr = @"";
                weakSelf.topStr = weakSelf.topArray[idx - 1][@"name"];
                weakSelf.topId = weakSelf.topArray[idx - 1][@"id"];
                if (weakSelf.areaStr.length == 0) {
                    dic = @{@"city":weakSelf.positionStr,@"type":weakSelf.topId};
                }else{
                    dic = @{@"city":weakSelf.positionStr,@"region":weakSelf.areaID,@"type":weakSelf.topId};
                }
            }
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            [mutDic addEntriesFromDictionary:dic];
            [mutDic addEntriesFromDictionary:weakSelf.idsDic];
            //首页:地图搜索
            [weakSelf.homeViewModel.clientMapCommand execute:mutDic.copy];
        }];
    }
    return _slideBar;
}

- (void)mapSearch{
    NSDictionary *dic;
    self.areaStr = @"";
    if (self.topStr.length == 0) {
        //首页:地图搜索
        dic = @{@"city":self.positionStr};
    }else{
        //首页:地图搜索
        dic = @{@"city":self.positionStr,@"type":self.topId};
    }
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    [mutDic addEntriesFromDictionary:dic];
    [mutDic addEntriesFromDictionary:self.idsDic];
    [self.homeViewModel.clientMapCommand execute:mutDic.copy];
}
@end
