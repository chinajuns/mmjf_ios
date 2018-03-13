//
//  LoanerMineRecertificationViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerMineRecertificationViewController.h"
#import "LoanerMineRecertificationViewModel.h"
#import "LoanerMineNetWorkViewModel.h"
#import "MaskView.h"
#import "LoanerMineCertificationViewController.h"
#import "UIViewController+BackButtonHandler.h"

@interface LoanerMineRecertificationViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listTab;
@property (nonatomic, strong)LoanerMineNetWorkViewModel *netWorkViewModel;
@property (nonatomic, strong)LoanerMineRecertificationViewModel *recertificationViewModel;
@property (nonatomic, strong)MaskView *card1;
@end

@implementation LoanerMineRecertificationViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.netWorkViewModel.profileCommand execute:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_card1 removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    [self setUpRecerViewModel];
    [self setUpNetWork];
}

- (BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return NO;
}


//重新提交
- (IBAction)againBut:(UIButton *)sender {
    
}

- (void)setUpRecerViewModel{
    [self.recertificationViewModel bindViewToViewModel:self.listTab];
}

//蒙版
- (void)setUpmask:(NSString *)tag{
    _card1 = [[[NSBundle mainBundle]loadNibNamed:@"MaskView" owner:self options:nil] lastObject];
    _card1.frame = CGRectMake(0, 64, MMJF_WIDTH, MMJF_HEIGHT);
    if ([tag isEqualToString:@"2"]) {
        _card1.image.image = [UIImage imageNamed:@"shen-he-zhong"];
        _card1.auditbut.hidden = YES;
        _card1.titleLab.text = @"实名认证审核中";
    }else if ([tag isEqualToString:@"3"]){
        return;
    }else if ([tag isEqualToString:@"4"]){
        _card1.image.image = [UIImage imageNamed:@"ic_audit_fail"];
        _card1.titleLab.text = @"实名认证审核失败";
        __weak typeof(self)weakSelf = self;
        [[_card1.auditbut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            LoanerMineCertificationViewController *vc = [[LoanerMineCertificationViewController alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:_card1];
}

//设置网络请求
- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.profileCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        LoanerManagerProfileModel *model = [LoanerManagerProfileModel yy_modelWithJSON:x];
        weakSelf.recertificationViewModel.model = model;
        [weakSelf.recertificationViewModel refresh];
        [weakSelf setUpmask:model.is_pass];
    }];
    
}

- (LoanerMineRecertificationViewModel *)recertificationViewModel{
    if (!_recertificationViewModel) {
        _recertificationViewModel = [[LoanerMineRecertificationViewModel alloc]init];
    }
    return _recertificationViewModel;
}

- (LoanerMineNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerMineNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
}
@end
