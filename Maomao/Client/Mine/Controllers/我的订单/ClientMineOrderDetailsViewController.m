//
//  ClientMineOrderDetailsViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/6.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineOrderDetailsViewController.h"
#import "ClientHomeListCardView.h"
#import "ClientMineOrderStatusCardView.h"
#import "ClientMineOrderDetailsViewModel.h"
#import "ZWPullMenuView.h"
#import "FSActionSheet.h"
#import "ClientMineNetworkViewModel.h"

@interface ClientMineOrderDetailsViewController ()<FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabe;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *stateView;

@property (weak, nonatomic) IBOutlet UITableView *orderDetailTab;

@property (nonatomic, strong)ClientMineNetworkViewModel *networkViewModel;

@property (nonatomic, strong)ClientMineOrderDetailsViewModel *orderDetailViewModel;
@end

@implementation ClientMineOrderDetailsViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self setUpNavigation];
    [self setUpListCard:self.dict[@"loaner"]];
    [self setUpStatusCard:self.dict[@"processing"] all_process:self.dict[@"all_process"] process:self.dict[@"process"]];
    [self setUpOrderDetail:self.dict[@"processing"]];
}
//设置listCard
- (void)setUpListCard:(NSDictionary *)dict{
    ClientHomeListCardView *card = [[[NSBundle mainBundle]loadNibNamed:@"ClientHomeListCardView" owner:self options:nil] lastObject];
    card.frame = self.backView.bounds;
    [card setUpdata:dict];
    card.cardClick.userInteractionEnabled = NO;
    [self.backView addSubview:card];
}
//设置导航条
- (void)setUpNavigation{
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:[UIImage imageNamed:@"geng-duo-1"] forState:UIControlStateNormal];
    [right setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    right.frame = CGRectMake(0, 0, 50, 44);
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem= rightItem;
    __weak typeof(self)weakSelf = self;
    //打开右抽屉
    [[right rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf setUpMenuView:x];
    }];
}
//设置状态Card
- (void)setUpStatusCard:(NSArray *)processing all_process:(NSArray *)all_process process:(NSString *)process{
    ClientMineOrderStatusCardView *card1 = [[[NSBundle mainBundle]loadNibNamed:@"ClientMineOrderStatusCardView" owner:self options:nil] lastObject];
    card1.frame = self.stateView.bounds;
    [self.stateView addSubview:card1];
    [card1 setUpData:processing all_process:all_process process:process];
}
//设置列表viewModel
- (void)setUpOrderDetail:(NSArray *)processing{
    [self.orderDetailViewModel bindViewToViewModel:self.orderDetailTab];
    [self.orderDetailViewModel setUpData:processing];
}

- (void)setUpMenuView:(UIButton *)sender{
    NSArray *titleArray = @[@"联系客服",@"举报"];
    NSArray *imageArray = [NSArray array];
    imageArray = @[@"lian-xi-ke-fu",
                   @"ju-bao-hui"];
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender
                                                       titleArray:titleArray
                                                       imageArray:imageArray];
    
    
    menuView.zwPullMenuStyle = PullMenuLightStyle;
    __weak typeof(self)weakSelf = self;
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        if (menuRow == 1) {//举报
            [weakSelf setUpSheet];
        }
        else{//联系客服
            
        }
    };
}
//设置弹窗
- (void)setUpSheet{
    NSArray *array = @[@"存在欺诈行为",@"信贷经理乱收费",@"服务态度恶劣"];
    FSActionSheet *sheet = [[FSActionSheet alloc] initWithTitle:@"举报" delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:@"" otherButtonTitles:array];
    __weak typeof(self)weakSelf = self;
    [sheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
        NSDictionary *dic = @{@"to_uid":weakSelf.dict[@"loaner_id"],@"loan_id":weakSelf.dict[@"id"],@"comment":array[selectedIndex]};
        [weakSelf.networkViewModel.reportCommand execute:dic];
    }];
}

- (ClientMineOrderDetailsViewModel *)orderDetailViewModel{
    if (!_orderDetailViewModel) {
        _orderDetailViewModel = [[ClientMineOrderDetailsViewModel alloc]init];
    }
    return _orderDetailViewModel;
}

- (ClientMineNetworkViewModel *)networkViewModel{
    if (!_networkViewModel) {
        _networkViewModel = [[ClientMineNetworkViewModel alloc]init];
    }
    return _networkViewModel;
}
@end
