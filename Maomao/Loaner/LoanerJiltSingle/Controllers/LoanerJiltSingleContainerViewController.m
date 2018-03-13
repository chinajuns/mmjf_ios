//
//  LoanerJiltSingleContainerViewController.m
//  Maomao
//
//  Created by 御顺 on 2018/1/3.
//  Copyright © 2018年 御顺. All rights reserved.
//

#import "LoanerJiltSingleContainerViewController.h"
#import <VTMagic/VTMagic.h>
#import "LoanerJiltsingleListViewController.h"

@interface LoanerJiltSingleContainerViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSArray *menuList;
@end

@implementation LoanerJiltSingleContainerViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    self.title = @"甩单记录";
    [super viewDidLoad];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [_magicController.magicView reloadData];
}

- (void)updateViewConstraints {
    UIView *magicView = _magicController.view;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    
    [super updateViewConstraints];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    _menuList = @[@"全部", @"审核",@"进行中",@"已成交",@"已过期"];
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#4d4d4d"] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#4d4d4d"] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:13.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    NSString *pageId = [NSString stringWithFormat:@"OrderList.identifier%ld",pageIndex];
    LoanerJiltsingleListViewController *webviewController = [magicView dequeueReusablePageWithIdentifier:pageId];
    if (!webviewController) {
        webviewController = [[LoanerJiltsingleListViewController alloc] init];
    }
    webviewController.number = pageIndex;
    return webviewController;
}

#pragma mark - accessor methods
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.sliderColor = MMJF_COLOR_Yellow;
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0, 0, 10, 0);
        _magicController.magicView.itemWidth = (MMJF_WIDTH - 16) / 5;
        _magicController.magicView.sliderWidth = 50;
        _magicController.magicView.sliderHeight = 1;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        _magicController.magicView.navigationHeight = 24.f;
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}
@end
