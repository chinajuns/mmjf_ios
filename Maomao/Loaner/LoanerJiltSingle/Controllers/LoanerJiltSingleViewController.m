//
//  LoanerJiltSingleViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/17.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerJiltSingleViewController.h"
#import "loanerJiltSingleViewModel.h"
//#import "LoanerJiltSingleMakeMoneyViewController.h"
#import "LoanerJiltsingleDetailViewController.h"
#import "LoanerJiltSingleContainerViewController.h"

@interface LoanerJiltSingleViewController ()
@property (weak, nonatomic) IBOutlet UITableView *jiltSingleTab;
@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;

@property (nonatomic, strong)loanerJiltSingleViewModel *jiltSingleViewModel;
@end

@implementation LoanerJiltSingleViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"甩单";
    [self setUpJiltSingleViewModel];
    [self setUpNavigation];
}

- (void)setUpJiltSingleViewModel{
     __weak typeof(self)weakSelf = self;
    [self.jiltSingleViewModel.netWorkViewModel.junkPublishCommand.executionSignals
     .switchToLatest subscribeNext:^(id  _Nullable x) {
         [weakSelf successful];
         [weakSelf.jiltSingleViewModel empty];
         MMJF_Log(@"%@",x);
         
     }];
    [self.jiltSingleViewModel bindViewToViewModel:self.jiltSingleTab];
}

- (void)setUpNavigation{
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:[UIImage imageNamed:@"shaui-dan-lie-biao"] forState:UIControlStateNormal];
    [right setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    right.frame = CGRectMake(0, 0, 50, 44);
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem= rightItem;
    __weak typeof(self)weakSelf = self;
    //打开右
    [[right rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        LoanerJiltSingleContainerViewController *vc = [[LoanerJiltSingleContainerViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

//甩单
- (void)successful{
    TYAlertController *alertController = [self.podStyleViewModel setUpSharePictureSingleView:@"甩单成功" img:@"cheng-gong" butTitle:@"确定"];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (loanerJiltSingleViewModel *)jiltSingleViewModel{
    if (!_jiltSingleViewModel) {
        _jiltSingleViewModel = [[loanerJiltSingleViewModel alloc]init];
    }
    return _jiltSingleViewModel;
}

- (SharePodStyleViewModel *)podStyleViewModel{
    if (!_podStyleViewModel) {
        _podStyleViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        //点击
        [_podStyleViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
            if ([x isEqualToString:@"甩单成功"]) {
                LoanerJiltSingleContainerViewController *vc = [[LoanerJiltSingleContainerViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _podStyleViewModel;
}
@end
