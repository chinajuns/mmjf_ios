//
//  ClientHomeEvaluationViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeEvaluationViewController.h"
#import <VTMagic/VTMagic.h>
#import "YZTagList.h"
#import "TQStarRatingView.h"
#import "ClientHomeViewModel.h"
#import "ClientEvaluationOfViewController.h"

@interface ClientHomeEvaluationViewController ()<VTMagicViewDataSource, VTMagicViewDelegate,StarRatingViewDelegate>
@property (nonatomic, strong) VTMagicController *magicController;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UIView *starsView;
@property (weak, nonatomic) IBOutlet UIView *tagsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;

@property (weak, nonatomic) IBOutlet UIView *evaluationView;
@property (nonatomic, strong)ClientHomeViewModel *netWorkViewModel;

@property (nonatomic, strong)  NSArray *menuList;
@end

@implementation ClientHomeEvaluationViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部评价";
    self.edgesForExtendedLayout = UIRectEdgeAll;
//    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:self.magicController];
    [self.evaluationView addSubview:_magicController.view];
    [self.view setNeedsUpdateConstraints];
    [self setUpdata];
    [self generateTestData];
    [_magicController.magicView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
- (void)generateTestData {
    _menuList = @[@"全部", @"好评", @"中评", @"差评"];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return _menuList;
}


- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#b3b3b3"] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor colorWithHexString:@"#1a1a1a"] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:16.f];
    }
    return menuItem;
}


- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
//    NSLog(@"sss%@",_menuList[pageIndex]);
    NSString *pageId = [NSString stringWithFormat:@"page.identifier%ld",pageIndex];
    ClientEvaluationOfViewController *webviewController = [magicView dequeueReusablePageWithIdentifier:pageId];
    if (!webviewController) {
       webviewController = [[ClientEvaluationOfViewController alloc] init];
    }
    webviewController.Id = _Id;
    webviewController.number = pageIndex;
    return webviewController;
}

#pragma mark - accessor methods
- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        //        _magicController.magicView.navigationHeight = 24;
        _magicController.magicView.sliderColor = [UIColor colorWithHexString:@"#1a1a1a"];
        _magicController.magicView.sliderHeight = 1;
        _magicController.magicView.sliderWidth = 40;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0, 15, 15, 80);
        _magicController.magicView.navigationHeight = 30.f;
        _magicController.magicView.againstStatusBar = YES;
        _magicController.magicView.sliderExtension = 10.0;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}


//设置标签
- (void)setUptagListView:(NSArray *)tags{
    NSMutableArray *mutArray = [NSMutableArray array];
    for (NSDictionary *dic in tags) {
        NSString *str = [NSString stringWithFormat:@"%@(%@)",dic[@"tag"],dic[@"times"]];
        [mutArray addObject:str];
    }
    // 创建标签列表
    YZTagList *tagList = [[YZTagList alloc] init]; // 高度可以设置为0，会自动跟随标题计算
    tagList.frame = CGRectMake(0, 0, MMJF_WIDTH, self.tagsView.height);
    // 需要排序
    tagList.isSort = NO;
    tagList.tagMargin  = 15;
    tagList.tagListCols = 3;
    tagList.tagSize = CGSizeMake((MMJF_WIDTH - 60) / 3, 25);
    // 设置标签背景色
    tagList.tagBackgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    // 设置标签颜色
    tagList.tagColor = [UIColor colorWithHexString:@"#b3b3b3"];
    tagList.tagFont = [UIFont fontWithName:@"PingFang SC" size:11];
    /**
     *  这里一定先设置标签列表属性，然后最后去添加标签
     */
    [tagList addTags:mutArray selectedStrs:nil];
    CGFloat h = 220;
    if (mutArray.count % 3 > 0) {
        if (mutArray.count / 3 > 2) {
            h = (mutArray.count/3 - 2) * 25 + 25;
        }
        h += 25;
    }else{
        if (mutArray.count / 3 > 2) {
            h = (mutArray.count/3 - 2) * 25;
        }else if (mutArray.count / 3 == 1){
            h = 220 - 30;
        }
    }
    self.line.constant = h;
    [self.tagsView addSubview:tagList];
}
//设置打分控件
- (void)setUpScoreView:(NSString *)average{
    TQStarRatingView * serviceStar = [[TQStarRatingView alloc] initWithFrame:self.starsView.bounds numberOfStar:kNUMBER_OF_STAR spacing:0];
    serviceStar.delegate = self;
    self.scoreLab.text = [NSString stringWithFormat:@"%@",average];
    CGFloat scoce = [average floatValue] * 2 / 10;
    [serviceStar setScore:scoce withAnimation:YES];
    [self.starsView addSubview:serviceStar];
}

- (void)starRatingView:(TQStarRatingView *)view score:(float)score{
    //    NSLog(@"ssss%f",score);
    //    if (view.tag == 1) {
    //        _serviceFloat = [NSString stringWithFormat:@"%.1f",score * 5];
    //    }else if (view.tag == 2){
    //        _authorityFloat = [NSString stringWithFormat:@"%.1f",score * 5];
    //    }else{
    //        _companyFloat = [NSString stringWithFormat:@"%.1f",score * 5];
    //    }
}
//设置数据
- (void)setUpdata{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.averageCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        [weakSelf setUptagListView:x[@"tag"]];
        [weakSelf setUpScoreView:x[@"average"]];
    }];
    [self.netWorkViewModel.averageCommand execute:self.Id];
}

- (ClientHomeViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[ClientHomeViewModel alloc]init];
    }
    return _netWorkViewModel;
}
@end
