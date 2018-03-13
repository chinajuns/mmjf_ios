//
//  CYTabBarController.m
//  蚁巢
//
//  Created by 张春雨 on 2016/11/17.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "CYTabBarController.h"
#import "MMJFBaseLoanerNavViewController.h"
#import "LogHomeViewController.h"

#import "LoanerHomeViewController.h"
#import "LoanerCustomerViewController.h"
#import "LoanerJiltSingleViewController.h"
#import "LoanerMineViewController.h"
#import "LoanerMineCertificationViewController.h"

#if  __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
#import "UITabBarItem+BadgeColor.h"
#endif

@interface CYTabBarController ()
// center button of place ( -1:none center button >=0:contain center button)
@property(assign , nonatomic) NSInteger centerPlace;
// Whether center button to bulge
@property(assign , nonatomic,getter=is_bulge) BOOL bulge;
// items
@property (nonatomic,strong) NSMutableArray <UITabBarItem *>*items;
// safeArea of bottom
@property (nonatomic,assign) CGFloat safeBottomInsets;
@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;
@end

@implementation CYTabBarController {
    int tabBarItemTag;
    BOOL firstInit;
    CGRect tabbarFrame;
}

- (void)dealloc{
    MMJF_Log(@"B端释放了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centerPlace = -1;
//    ContentView *view = [[ContentView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    [view setValue:self forKeyPath:@"controller"];
//    [self.view addSubview:view];
    /**
     *  配置外观
     */
    [CYTabBarConfig shared].selectedTextColor = [UIColor colorWithHexString:@"#1a1a1a"];
    [CYTabBarConfig shared].textColor = [UIColor colorWithHexString:@"#1a1a1a"];
    [CYTabBarConfig shared].backgroundColor = [UIColor whiteColor];
    [CYTabBarConfig shared].selectIndex = 0;
    [CYTabBarConfig shared].centerBtnIndex = 2;
    /**
     *  style 1 (中间按钮突出 ， 设为按钮 , 底部有文字)
     */
    MMJFBaseLoanerNavViewController *nav1 = [[MMJFBaseLoanerNavViewController alloc]initWithRootViewController:[LoanerHomeViewController new]];
    [self addChildController:nav1 title:@"首页" imageName:@"shou-ye" selectedImageName:@"shou-ye-yi-xuan"];
    MMJFBaseLoanerNavViewController *nav2 = [[MMJFBaseLoanerNavViewController alloc]initWithRootViewController:[LoanerCustomerViewController new]];
    [self addChildController:nav2 title:@"抢单" imageName:@"qiang-dan-1" selectedImageName:@"qiang-dan-xuan-zhong"];
    MMJFBaseLoanerNavViewController *nav3 = [[MMJFBaseLoanerNavViewController alloc]initWithRootViewController:[LoanerJiltSingleViewController new]];
    [self addChildController:nav3 title:@"甩单" imageName:@"shaui-dan-1" selectedImageName:@"shuai-dan"];
    MMJFBaseLoanerNavViewController *nav4 = [[MMJFBaseLoanerNavViewController alloc]initWithRootViewController:[LoanerMineViewController new]];
    [self addChildController:nav4 title:@"我的" imageName:@"wo-de" selectedImageName:@"wo-de-yi-xuan"];
    [self addCenterController:nil bulge:YES title:@"店铺" imageName:@"dian-pu" selectedImageName:@"dian-pu"];
}

/**
 *  Initialize selected
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!firstInit) {
        firstInit = YES;
        NSInteger index = [CYTabBarConfig shared].selectIndex;
        if (index < 0) {
            self.selectedIndex = (self.centerPlace != -1 && self.items[self.centerPlace].tag != -1)
            ? self.centerPlace
            : 0;
        } else if (index >= self.viewControllers.count){
            self.selectedIndex = self.viewControllers.count-1;
        }
        else {
            self.selectedIndex = index;
        }
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogonFailure:) name:@"LogonFailure" object:nil];
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
//退出登录
- (void)LogonFailure:(NSNotification *)bitice{
    NSDictionary *dic = bitice.userInfo;
    [MBProgressHUD hideHUDForView:nil];
    // 创建文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    // 删除
    BOOL isDelete = [manager removeItemAtPath:MMJF_UserInfoPath error:nil];
    if (isDelete) {
        
    }
    if (dic.allKeys.count == 0) {
        MMJF_ShareV.isCustomer = NO;
        LogHomeViewController * loginVC = [[LogHomeViewController alloc]init];
        MMJFBaseLoanerNavViewController *nav = [[MMJFBaseLoanerNavViewController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    [self cancel];
    
}


/**
 *  Add other button for child’s controller
 */
- (void)addChildController:(id)Controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    UIViewController *vc = [self findViewControllerWithobject:Controller];
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    
    vc.tabBarItem.tag = tabBarItemTag++;
    [self.items addObject:vc.tabBarItem];
    [self addChildViewController:Controller];
}

/**
 *  Add center button
 */
- (void)addCenterController:(id)Controller bulge:(BOOL)bulge title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName{
    _bulge = bulge;
    if (Controller) {
        [self addChildController:Controller title:title imageName:imageName selectedImageName:selectedImageName];
        self.centerPlace = tabBarItemTag-1;
    }else{
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:title
                                                          image:[UIImage imageNamed:imageName]
                                                  selectedImage:[UIImage imageNamed:selectedImageName]];
        item.tag = -1;
        [self.items addObject:item];
        self.centerPlace = tabBarItemTag;
    }
}

/**
 *  getter
 */
- (CYTabBar *)tabbar{
    if (self.items.count && !_tabbar) {
        _tabbar = [[CYTabBar alloc]initWithFrame:CGRectZero];
        [_tabbar setValue:self forKey:@"controller"];
        [_tabbar setValue:[NSNumber numberWithBool:self.bulge] forKey:@"bulge"];
        [_tabbar setValue:[NSNumber numberWithInteger:self.centerPlace] forKey:@"centerPlace"];
        _tabbar.items = self.items;
        
        //remove tabBar
        for (UIView *loop in self.tabBar.subviews) {
            [loop removeFromSuperview];
        }
        self.tabBar.hidden = YES;
        [self.tabBar removeFromSuperview];
    }
    return _tabbar;
}
- (NSMutableArray <UITabBarItem *>*)items{
    if(!_items){
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)InitializeTabbar{
    [_tabbar setValue:[NSNumber numberWithBool:self.bulge] forKey:@"bulge"];
    [_tabbar setValue:[NSNumber numberWithInteger:self.centerPlace] forKey:@"centerPlace"];
    _tabbar.items = self.items;
}

/**
 *  Update current select controller
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    
    
    if (selectedIndex >= self.viewControllers.count){
        @throw [NSException exceptionWithName:@"selectedTabbarError"
                                       reason:@"No controller can be used,Because of index beyond the viewControllers,Please check the configuration of tabbar."
                                     userInfo:nil];
    }
    if (selectedIndex == 2) {
        if ([MMJF_ShareV.is_auth isEqualToString:@"3"]) {
            
        }else if ([MMJF_ShareV.is_auth isEqualToString:@"0"]){
            [MBProgressHUD showError:@"似乎与互联网断开连接"];
            return;
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"checkAuthentication" object:nil userInfo:nil];
            return;
        }
    }
    [super setSelectedIndex:selectedIndex];
    UIViewController *viewController = [self findViewControllerWithobject:self.viewControllers[selectedIndex]];
    [self.tabbar removeFromSuperview];
    [viewController.view addSubview:self.tabbar];
    [self.tabbar setValue:[NSNumber numberWithInteger:selectedIndex] forKeyPath:@"selectButtoIndex"];
    [self.tabbar setNeedsLayout];
}

/**
 *  Layout tabBar for superView
 */
- (void)setLayoutTabBar:(UIView *)layoutTabBar {
    self.safeBottomInsets = 0;
    if (@available(iOS 11.0, *)) {
        self.safeBottomInsets = self.view.safeAreaInsets.bottom;
    }
    
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    CGRect rect = CGRectMake(0,
                             h-49-self.safeBottomInsets-layoutTabBar.frame.origin.y,
                             layoutTabBar.frame.size.width,
                             49+self.safeBottomInsets);
    self.tabbar.frame = rect;
}


/**
 *  Catch viewController
 */
- (UIViewController *)findViewControllerWithobject:(id)object{
    while ([object isKindOfClass:[UITabBarController class]] || [object isKindOfClass:[UINavigationController class]]){
        object = ((UITabBarController *)object).viewControllers.firstObject;
    }
    return object;
}

/**
 *  hidden tabbar and do animated
 */
- (void)setCYTabBarHidden:(BOOL)hidden animated:(BOOL)animated{
    NSTimeInterval time = animated ? 0.3 : 0.0;
    if (self.tabbar.isHidden) {
        self.tabbar.hidden = NO;
        [UIView animateWithDuration:time animations:^{
            self.tabbar.transform = CGAffineTransformIdentity;
        }];
    }else{
        CGFloat h = self.tabbar.frame.size.height;
        [UIView animateWithDuration:time-0.1 animations:^{
            self.tabbar.transform = CGAffineTransformMakeTranslation(0,h);
        }completion:^(BOOL finished) {
            self.tabbar.hidden = YES;
        }];
    }
}

- (void)cancel{
    TYAlertController *alertController = [self.podStyleViewModel setUpShareCancelView:@"您的账号已在别处登录" isC:MMJF_ShareV.isCustomer];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (SharePodStyleViewModel *)podStyleViewModel{
    if (!_podStyleViewModel) {
        _podStyleViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        //点击
        [_podStyleViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            if ([x isEqualToString:@"您的账号已在别处登录"]) {
                [weakSelf dismissViewControllerAnimated:NO completion:^{
                    MMJF_ShareV.isCustomer = NO;
                    LogHomeViewController * loginVC = [[LogHomeViewController alloc]init];
                    MMJFBaseLoanerNavViewController *nav = [[MMJFBaseLoanerNavViewController alloc] initWithRootViewController:loginVC];
                    [weakSelf presentViewController:nav animated:YES completion:nil];
                }];
            }else if ([x isEqualToString:@"取消"]){
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    return _podStyleViewModel;
}
@end


