//
//  MMJFTabBarViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/10/31.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFTabBarViewController.h"
#import "ClientHomeViewController.h"
#import "ClientLoanViewController.h"
#import "ClientInformationViewController.h"
#import "ClientMessageViewController.h"
#import "ClientMineViewController.h"
#import "LogHomeViewController.h"

#import "MMJFBaseNavigationViewController.h"

@interface MMJFTabBarViewController ()<UITabBarControllerDelegate>
@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;
@end

@implementation MMJFTabBarViewController

- (void)dealloc{
    MMJF_Log(@"C端释放了");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogonFailure:) name:@"LogonFailure" object:nil];
    
}
//移除通知
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeThe];
}

//初始化
- (void)initializeThe{
    ClientHomeViewController *homeVC = [[ClientHomeViewController alloc] init];
    ClientLoanViewController *loanVC = [[ClientLoanViewController alloc]init];
    ClientInformationViewController *informationVC = [[ClientInformationViewController alloc]init];
    ClientMessageViewController *messageVC = [[ClientMessageViewController alloc] init];
    ClientMineViewController *mainVC = [[ClientMineViewController alloc]init];
    // 1.初始化子控制器
    [self addChildVc:homeVC title:@"首页" image:@"shou-ye" selectedImage:@"shou-ye-yi-xuan"];
    
    [self addChildVc:loanVC title:@"贷款" image:@"dai-kuan" selectedImage:@"dai-kuan-yi-xuan"];
    //
    [self addChildVc:informationVC title:@"资讯" image:@"zi-xun-wei-xuan" selectedImage:@"zi-xun-c"];
    
    [self addChildVc:messageVC title:@"消息" image:@"xiao-xi" selectedImage:@"xiao-xi-yi-xuan"];
    
    [self addChildVc:mainVC title:@"我的" image:@"wo-de" selectedImage:@"wo-de-yi-xuan"];
}

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    [textAttrs setObject:[UIColor colorWithHexString:@"#1a1a1a"] forKey:NSForegroundColorAttributeName];
    [textAttrs setObject:[UIFont fontWithName:@"PingFang SC" size:10] forKey:NSFontAttributeName];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#1a1a1a"];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    self.tabBar.backgroundImage = [self drawTabBarItemBackgroundImageWithSize:self.tabBar.bounds.size];
    
   
    // 先给外面传进来的小控制器 包装 一个导航控制器
    MMJFBaseNavigationViewController *nav = [[MMJFBaseNavigationViewController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}
- (UIImage *)drawTabBarItemBackgroundImageWithSize:(CGSize)size
{
    // 准备绘图环境
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(ctx, 255 / 255, 255 / 255, 255 / 255, 1);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    
    // 获取该绘图中的图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束绘图
    UIGraphicsEndImageContext();
    return img;
}

- (void)LogonFailure:(NSNotification *)bitice{
    NSDictionary *dic = bitice.userInfo;
    [MBProgressHUD hideHUDForView:nil];
    // 创建文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    // 删除
    BOOL isDelete = [manager removeItemAtPath:MMJF_UserInfoPath error:nil];
    if (isDelete) {
        
    }
    MMJF_Log(@"%@",dic);
    if (dic.allKeys.count == 0) {
        MMJF_ShareV.isCustomer = YES;
        LogHomeViewController * loginVC = [[LogHomeViewController alloc]init];
        MMJFBaseNavigationViewController *nav = [[MMJFBaseNavigationViewController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    [self cancel];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController == [tabBarController.viewControllers objectAtIndex:3])
    {//判断消息能否进入
        ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
        if (!user) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LogonFailure" object:nil userInfo:@{}];
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
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
                    MMJF_ShareV.isCustomer = YES;
                    LogHomeViewController * loginVC = [[LogHomeViewController alloc]init];
                    MMJFBaseNavigationViewController *nav = [[MMJFBaseNavigationViewController alloc] initWithRootViewController:loginVC];
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
