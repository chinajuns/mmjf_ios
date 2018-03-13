//
//  ClientMineCollectionViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineCollectionViewController.h"
#import <VTMagic/VTMagic.h>
#import "ClientMineProductCViewController.h"
#import "ClientMineArticleCViewController.h"

@interface ClientMineCollectionViewController ()<VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) NSArray *menuList;
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;

@end

@implementation ClientMineCollectionViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.view.backgroundColor = MMJF_COLOR_Yellow;
    [self addChildViewController:self.magicController];
    self.line.constant = MMJF_HEIGHT > 800 ? 24 : 0;
    
    [self.backview addSubview:_magicController.view];
//    [self.view setNeedsUpdateConstraints];
    
    [_magicController.magicView reloadData];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:[UIImage imageNamed:@"fan-hui"] forState:UIControlStateNormal];
//    [right setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    right.frame = CGRectMake(0, 0, 50, 44);
    _magicController.magicView.leftNavigatoinItem = right;
    __weak typeof(self)weakSelf = self;
    //打开右抽屉
    [[right rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
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

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    _menuList = @[@"信贷经理", @"文章"];
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
    NSString *pageId = [NSString stringWithFormat:@"Collection.identifier%ld",pageIndex];
    if (pageIndex == 0) {
        ClientMineProductCViewController *webviewController = [magicView dequeueReusablePageWithIdentifier:pageId];
        if (!webviewController) {
            webviewController = [[ClientMineProductCViewController alloc] init];
        }
        return webviewController;
    }else{
        ClientMineArticleCViewController *webviewController = [magicView dequeueReusablePageWithIdentifier:pageId];
        if (!webviewController) {
            webviewController = [[ClientMineArticleCViewController alloc] init];
        }
        return webviewController;
    }
}

#pragma mark - accessor methods
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = MMJF_COLOR_Yellow;
        _magicController.magicView.sliderColor = [UIColor colorWithHexString:@"#1a1a1a"];
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0, -60, 0, 0);
        _magicController.magicView.sliderHeight = 1;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        _magicController.magicView.navigationHeight = 44.f;
        _magicController.magicView.scrollEnabled = NO;
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}


@end
