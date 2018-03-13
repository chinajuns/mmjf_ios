//
//  MMJFBaseNavigationViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/10/31.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseNavigationViewController.h"

@interface MMJFBaseNavigationViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) id popDelegate;

@end

@implementation MMJFBaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigtionBackButton];
}
//设置返回
- (void)setNavigtionBackButton{
    _popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationBar.tintColor = [UIColor blackColor];
    // 方法一
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"fan-hui"];
    
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"fan-hui"];
    
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 11.0) { // iOS系统版本 >= 8.0
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
    } else{ //iOS系统版本 < 11.0
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
    }
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //判断2次点击到的控制器是不是同一控制器
    if ([self.topViewController isKindOfClass:[viewController class]]) {
        return;
    }
    if (self.childViewControllers.count) { // 不是根控制器
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    [super pushViewController:viewController animated:animated];
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers[0]) { // 是根控制器
        
        self.interactivePopGestureRecognizer.delegate = nil;
    }else{ // 非根控制器
        self.interactivePopGestureRecognizer.delegate = _popDelegate;
        
    }
}

@end
