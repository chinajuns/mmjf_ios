//
//  LoanerStoreOrderDetaillViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreOrderDetaillViewController.h"
#import "LoanerStoreOrderDetailViewModel.h"
#import "ZWPullMenuView.h"
#import "LoanerStoreNetWorkViewModel.h"
#import "FSActionSheet.h"
#import "LoanerJiltSingleContainerViewController.h"

@interface LoanerStoreOrderDetaillViewController ()<FSActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTab;
@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;
@property (nonatomic, strong)LoanerStoreNetWorkViewModel *networkViewModel;
@property (nonatomic, strong)LoanerStoreOrderDetailViewModel *detailViewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewLine;

/**
 显示两个按钮hidden=No 三个按钮hidden = yes
 */
@property (weak, nonatomic) IBOutlet UIView *backViewtwo;
/**
 都不显示hidden = yes
 */
@property (weak, nonatomic) IBOutlet UIView *backViewone;

@property (nonatomic, strong)LoanerOrderDetailModel *model;
@end

@implementation LoanerStoreOrderDetaillViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSDictionary *dic = @{@"id":self.Id};
    [self.networkViewModel.orderDetailCommand execute:dic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigation];
    [self setUpNetWork];
    [self setUpDetaiViewModel];
}

//设置导航条
- (void)setUpNavigation{
    self.title = @"订单详情";
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

//绑定成功提示
- (void)bindingSuccessful:(NSString *)img title:(NSString *)title{
    TYAlertController *alertController = [self.podStyleViewModel setUpSharePictureSingleView:title img:img butTitle:@"完成"];
    [self presentViewController:alertController animated:YES completion:nil];
}
//输入提示框
- (void)inputSigning:(NSString *)title{
    TYAlertController *alertController = [self.podStyleViewModel setUpShareTextTwo:title determineStr:@"提交" cancelStr:@"取消" unit:@"万元"];
    [self presentViewController:alertController animated:YES completion:nil];
}
//失败titletitle
- (void)failure{
    NSArray *array = @[@"资料不齐全",@"资料与实际不符"];
    TYAlertController *alertController = [self.podStyleViewModel setUpShareTabTwo:@"失败原因" determineStr:@"提交" cancelStr:@"取消" whyArray:array];
    [self presentViewController:alertController animated:YES completion:nil];
}

//底部按钮
- (IBAction)bottomBut:(UIButton *)sender {
    if (sender.tag == 0) {//失败
        [self failure];
    }else if (sender.tag == 1){//下一步
        NSString *str = [NSString stringWithFormat:@"%@",self.model.process];
        if ([str isEqualToString:@"11"]) {
            [self inputSigning:@"签约金额"];
        }else if ([str isEqualToString:@"12"]){
            NSDictionary *dic = @{@"id":self.Id,@"status":@"2"};
            [self.networkViewModel.orderProcessCommand execute:dic];
        }else if ([str isEqualToString:@"36"]){
            [self inputSigning:@"放款金额"];
        }
    }else{//甩单
        [self inputSigning:@"甩单积分"];
    }
}

- (void)setUpMenuView:(UIButton *)sender{
    NSArray *titleArray = @[@"联系客户",@"举报"];
    NSArray *imageArray = @[@"lian-xi-ke-fu",@"ju-bao-hui"];
    
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender
                                                       titleArray:titleArray
                                                       imageArray:imageArray];
    
    
    menuView.zwPullMenuStyle = PullMenuLightStyle;
    __weak typeof(self)weakSelf = self;
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        if (menuRow == 0) {//联系客服
            
        }
        else{//举报
            [weakSelf setUpSheet];
        }
    };
}

//设置弹窗
- (void)setUpSheet{
    NSArray *array = @[@"存在欺诈行为",@"信贷经理乱收费",@"服务态度恶劣"];
    FSActionSheet *sheet = [[FSActionSheet alloc] initWithTitle:@"举报" delegate:self cancelButtonTitle:@"取消" highlightedButtonTitle:@"" otherButtonTitles:array];
    __weak typeof(self)weakSelf = self;
    [sheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
        NSDictionary *dic = @{@"id":weakSelf.Id,@"reason":array[selectedIndex]};
        [weakSelf.networkViewModel.shopReportCommand execute:dic];
    }];
}

- (void)setUpDetaiViewModel{
    self.detailViewModel.isRefer = self.isRefer;
    [self.detailViewModel bindViewToViewModel:self.listTab];
}

- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    //订单详情
    [self.networkViewModel.orderDetailCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"%@",x);
         weakSelf.model = [LoanerOrderDetailModel yy_modelWithJSON:x];
         weakSelf.detailViewModel.model = weakSelf.model;
         [weakSelf.detailViewModel refresh];
         NSString *str = [NSString stringWithFormat:@"%@",weakSelf.model.process];
         weakSelf.backViewone.hidden = NO;
         if ([str isEqualToString:@"11"]) {
             weakSelf.backViewtwo.hidden = YES;
         }else{
             weakSelf.backViewtwo.hidden = NO;
         }
         if ([str isEqualToString:@"38"] || [str isEqualToString:@"37"]) {
             weakSelf.backViewone.hidden = YES;
             weakSelf.backViewLine.constant = 0;
         }
    }];
    
    //B端：店铺-客户订单-拒绝申请
    [self.networkViewModel.customerOrderRefuseCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"%@",x);
         [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    //B端：店铺-客户订单-甩单(用户申请的订单甩出去)
    [self.networkViewModel.orderJunkCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        [weakSelf bindingSuccessful:@"cheng-gong" title:@"甩单成功"];
    }];
    //B端：店铺-客户订单-详情执行流程审批
    [self.networkViewModel.orderProcessCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        NSString *str = [NSString stringWithFormat:@"%@",weakSelf.model.process];
        if ([str isEqualToString:@"11"]) {
            [weakSelf bindingSuccessful:@"ji-fen-tu-an" title:@"提交成功"];
        }
        NSDictionary *dic = @{@"id":weakSelf.Id};
        [weakSelf.networkViewModel.orderDetailCommand execute:dic];
    }];
}

- (LoanerStoreOrderDetailViewModel *)detailViewModel{
    if (!_detailViewModel) {
        _detailViewModel = [[LoanerStoreOrderDetailViewModel alloc]init];
    }
    return _detailViewModel;
}

- (LoanerStoreNetWorkViewModel *)networkViewModel{
    if (!_networkViewModel) {
        _networkViewModel = [[LoanerStoreNetWorkViewModel alloc]init];
    }
    return _networkViewModel;
}

- (SharePodStyleViewModel *)podStyleViewModel{
    if (!_podStyleViewModel) {
        _podStyleViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        //点击
        [_podStyleViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            if ([x isKindOfClass:[NSDictionary class]]) {
                NSString *str = x[@"value"];
                NSString *str1 = x[@"title"];
                if ([str1 isEqualToString:@"签约金额"]){
                    NSDictionary *dic = @{@"id":weakSelf.Id,@"status":@"1",@"money":str};
                    [weakSelf.networkViewModel.orderProcessCommand execute:dic];
                }else if ([str1 isEqualToString:@"放款金额"]){
                    NSDictionary *dic = @{@"id":weakSelf.Id,@"status":@"3",@"money":str};
                    [weakSelf.networkViewModel.orderProcessCommand execute:dic];
                }else if ([str1 isEqualToString:@"甩单积分"]){
                    NSDictionary *dic = @{@"id":weakSelf.Id,@"score":str};
                    [weakSelf.networkViewModel.orderJunkCommand execute:dic];
                }else if ([str1 isEqualToString:@"失败原因"]){
                    NSDictionary *dic = @{@"id":weakSelf.Id,@"reason":str};
                    [weakSelf.networkViewModel.customerOrderRefuseCommand execute:dic];
                }
            }else{
                if ([x isEqualToString:@"甩单成功"]) {
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    LoanerJiltSingleContainerViewController *vc = [[LoanerJiltSingleContainerViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }];
    }
    return _podStyleViewModel;
}
@end
