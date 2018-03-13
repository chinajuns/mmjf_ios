//
//  ClientMessageViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/17.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMessageViewController.h"
#import <VTMagic/VTMagic.h>
#import "ClientMessageListViewController.h"
#define kSearchBarWidth (35.0f)

@interface ClientMessageViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSArray *menuList;
@end

@implementation ClientMessageViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self.view setNeedsUpdateConstraints];
    if (self.isSecondary == YES) {
        [self integrateComponents];
    }
    [_magicController.magicView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

#pragma mark - functional methods
- (void)integrateComponents {
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"fan-hui"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    searchButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    searchButton.frame = CGRectMake(0, 0, kSearchBarWidth, 20);
    [self.magicController.magicView setLeftNavigatoinItem:searchButton];
}
#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    _menuList = @[@"订单消息", @"系统消息"];
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#1a1a1a"] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#1a1a1a"] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:16.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    NSString *pageId = [NSString stringWithFormat:@"InfomationList.identifier%ld",pageIndex];
    ClientMessageListViewController *webviewController = [magicView dequeueReusablePageWithIdentifier:pageId];
    if (!webviewController) {
        webviewController = [[ClientMessageListViewController alloc] init];
    }
    webviewController.number = pageIndex;
    return webviewController;
}
//返回按钮
- (void)leftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - accessor methods
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = MMJF_COLOR_Yellow;
        _magicController.magicView.sliderColor = [UIColor colorWithHexString:@"#1a1a1a"];
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        if (MMJF_HEIGHT > 800) {
            _magicController.magicView.navigationHeight = 66.f;
            _magicController.magicView.navigationInset = UIEdgeInsetsMake(22, 0, 0, 0);
        }else{
            _magicController.magicView.navigationHeight = 44.f;
        }
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}


@end
