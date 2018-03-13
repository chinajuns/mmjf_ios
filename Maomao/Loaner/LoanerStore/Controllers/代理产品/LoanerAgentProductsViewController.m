//
//  LoanerAgentProductsViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerAgentProductsViewController.h"
#import "FDSlideBar.h"
#import "LoanerAgentProductsViewModel.h"
#import "LoanerAgentSearchViewController.h"
#import "LoanerAgentDetailViewController.h"

@interface LoanerAgentProductsViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic, strong)LoanerAgentProductsViewModel *agentViewModel;
/**
 头部多按钮
 */
@property (strong, nonatomic) FDSlideBar *slideBar;


/**
 头部列表
 */
@property (nonatomic ,copy)NSArray *cates;
@property (nonatomic,assign)BOOL isOk;
@end

@implementation LoanerAgentProductsViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.agentViewModel loading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigation];
    [self setupSlideBar];
    [self setUpAgentViewModel];
}

///设置头部多按钮
- (void)setupSlideBar {
    // Init the titles of all the item
    __weak typeof(self.slideBar)weaksliderBar = self.slideBar;
    __weak typeof(self)weakSelf = self;
    [self.agentViewModel.netWorkViewModel.otherTypeCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"%@",x);
         if (weakSelf.isOk == YES) {
             return;
         }
         weakSelf.cates = x;
         NSMutableArray *muts = [NSMutableArray array];
         [muts addObject:@"全部"];
         for (NSDictionary *dic in weakSelf.cates) {
             [muts addObject:dic[@"cate_name"]];
         }
         weaksliderBar.itemsTitle = muts;
         // Set some style to the slideBar
         weaksliderBar.itemColor = [UIColor colorWithHexString:@"#1a1a1a"];
         weaksliderBar.itemSelectedColor = [UIColor colorWithHexString:@"#4d4d4d"];
         weaksliderBar.sliderColor = MMJF_COLOR_Yellow;
         //设置滑动到哪了
         //         [weaksliderBar selectSlideBarItemAtIndex:1];
         weakSelf.isOk = YES;
    }];
    [self.agentViewModel.netWorkViewModel.otherTypeCommand execute:nil];
    [self.backView addSubview:self.slideBar];
}

//设置导航条
- (void)setUpNavigation{
    self.title = @"代理产品";
//    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
//    [right setImage:[UIImage imageNamed:@"sou-suo"] forState:UIControlStateNormal];
//    [right setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
//    right.frame = CGRectMake(0, 0, 50, 44);
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
//    self.navigationItem.rightBarButtonItem= rightItem;
//    __weak typeof(self)weakSelf = self;
//    //打开右抽屉
//    [[right rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
//        LoanerAgentSearchViewController *vc = [[LoanerAgentSearchViewController alloc]init];
//        [weakSelf.navigationController pushViewController:vc animated:YES];
//    }];
}

- (void)setUpAgentViewModel{
    [self.agentViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    //代理详情
    [self.agentViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        NSDictionary *dic = [weakSelf.agentViewModel getListDic];
        LoanerAgentDetailViewController *vc = [[LoanerAgentDetailViewController alloc]init];
        vc.dict = dic;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (LoanerAgentProductsViewModel *)agentViewModel{
    if (!_agentViewModel) {
        _agentViewModel = [[LoanerAgentProductsViewModel alloc]init];
    }
    return _agentViewModel;
}

- (FDSlideBar *)slideBar{
    if (!_slideBar) {
        _slideBar = [[FDSlideBar alloc]init];
        _slideBar.backgroundColor = [UIColor whiteColor];
        // Add the callback with the action that any item be selected
        __weak typeof(self)weakSelf = self;
        [_slideBar slideBarItemSelectedCallback:^(NSUInteger idx) {
            if (idx == 0) {
                weakSelf.agentViewModel.cate_id = @"";
            }else{
                weakSelf.agentViewModel.cate_id = weakSelf.cates[idx - 1][@"id"];
                MMJF_Log(@"%@",weakSelf.agentViewModel.cate_id);
            }
            
            [weakSelf.agentViewModel loading];
        }];
    }
    return _slideBar;
}
@end
