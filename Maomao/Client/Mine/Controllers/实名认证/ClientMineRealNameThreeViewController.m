//
//  ClientMineRealNameThreeViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/20.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineRealNameThreeViewController.h"
#import "MaskView.h"
#import "ClientMineRealNameThreeViewModel.h"
#import "UIViewController+BackButtonHandler.h"
#import "ClientMineRealNameViewController.h"

@interface ClientMineRealNameThreeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listTab;
@property (nonatomic, strong)MaskView *card1;
@property (nonatomic, strong)ClientMineRealNameThreeViewModel *threeViewModel;
@end

@implementation ClientMineRealNameThreeViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
    [self.threeViewModel bindViewToViewModel:self.listTab];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_card1 removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    _card1 = [[[NSBundle mainBundle]loadNibNamed:@"MaskView" owner:self options:nil] lastObject];
    [self setUpViewModel];
}
//蒙版
- (void)setUpmask:(NSString *)tag{
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
        
    }
    __weak typeof(self)weakSelf = self;
    [[_card1.auditbut rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ClientMineRealNameViewController *vc = [[ClientMineRealNameViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    UIWindow *appWindow = [[UIApplication sharedApplication] keyWindow];
    [appWindow addSubview:_card1];
}
//拦截返回按钮
- (BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return NO;
}

- (void)setUpViewModel{
    __weak typeof(self)weakSelf = self;
    [self.threeViewModel.networkViewModel.authDocumentCommand
     .executionSignals
     .switchToLatest subscribeNext:^(id  _Nullable x) {
         MMJF_Log(@"%@",x);
         weakSelf.threeViewModel.authDocumentModel = [ClientMineAuthDocumentModel yy_modelWithJSON:x];
         [weakSelf setUpmask:weakSelf.threeViewModel.authDocumentModel.is_pass];
     }];
}

- (ClientMineRealNameThreeViewModel *)threeViewModel{
    if (!_threeViewModel) {
        _threeViewModel = [[ClientMineRealNameThreeViewModel alloc]init];
    }
    return _threeViewModel;
}

@end
