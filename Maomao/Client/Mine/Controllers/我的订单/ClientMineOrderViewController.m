//
//  ClientMineOrderViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineOrderViewController.h"
#import <VTMagic/VTMagic.h>
#import "ClientMineOrderListViewController.h"
@interface ClientMineOrderViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (nonatomic, strong) NSArray *menuList;

@end

@implementation ClientMineOrderViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = MMJF_COLOR_Yellow;
    [self addChildViewController:self.magicController];
    self.line.constant = MMJF_HEIGHT > 800 ? 88 : 64;
    [self.backView addSubview:_magicController.view];
    [_magicController.magicView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.navigationController.navigationBar.translucent = NO;
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
    _menuList = @[@"全部", @"办理中",@"待评价",@"贷款记录"];
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
    NSString *pageId = [NSString stringWithFormat:@"Order.identifier%ld",pageIndex];
    ClientMineOrderListViewController *webviewController = [magicView dequeueReusablePageWithIdentifier:pageId];
    if (!webviewController) {
        webviewController = [[ClientMineOrderListViewController alloc] init];
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
        _magicController.magicView.itemWidth = (MMJF_WIDTH - 16) / 4;
        _magicController.magicView.sliderWidth = 60;
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
