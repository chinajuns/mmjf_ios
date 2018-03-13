//
//  ClientMineAccountBindingViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/6.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineAccountBindingViewController.h"
#import "ClientMineNetworkViewModel.h"
#import "ClientMineBindModel.h"
#import <UMSocialCore/UMSocialCore.h>

@interface ClientMineAccountBindingViewController ()
@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;

@property (weak, nonatomic) IBOutlet UIButton *clickBut;
//绑定标识
@property (weak, nonatomic) IBOutlet UILabel *logoLab;

@property (nonatomic, strong)ClientMineNetworkViewModel *networkViewModel;

@property (nonatomic, strong)ClientMineBindModel *model;
@end

@implementation ClientMineAccountBindingViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号绑定";
    [self setUpData];
}

- (void)setUpData{
    __weak typeof(self)weakSelf = self;
    //个人中心：个人：绑定记录
    [self.networkViewModel.memberOauthBind.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        if ([x isKindOfClass:[NSArray class]]) {
            NSArray *array = x;
            for (NSDictionary *dic in array) {
                weakSelf.model = [ClientMineBindModel yy_modelWithJSON:dic];
                if ([weakSelf.model.type isEqualToString:@"wehcat"]) {
                    weakSelf.logoLab.text = @"已绑定";
                }
            }
        }else{
            NSString *str = [NSString stringWithFormat:@"%@",x];
            if ([str isEqualToString:@"5000"]) {
                weakSelf.model = [ClientMineBindModel yy_modelWithJSON:@{}];
                weakSelf.logoLab.text = @"未绑定";
            }
        }
    }];
    [self.networkViewModel.memberOauthBind execute:nil];
    
    //个人中心：第三方绑定
    [self.networkViewModel.memberSetOauthBind.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        if ([weakSelf.model.type isEqualToString:@"wehcat"]) {
            [MBProgressHUD showSuccess:@"解绑成功"];
        }else{
            [MBProgressHUD showSuccess:@"绑定成功"];
        }
        [weakSelf.networkViewModel.memberOauthBind execute:nil];
    }];
    
    [[self.clickBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        if ([weakSelf.model.type isEqualToString:@"wehcat"]) {
             [weakSelf bindingSuccessful];
        }else{
            [weakSelf getUserInfoForPlatform];
        }
    }];
}

//绑定成功提示
- (void)bindingSuccessful{
    TYAlertController *alertController = [self.podStyleViewModel setUpShareTwo:@"确定解绑微信?" determineStr:@"确定" cancelStr:@"取消"];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getUserInfoForPlatform
{
    __weak typeof(self)weakSelf = self;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        MMJF_Log(@" uid: %@", resp.unionId);
        if (resp.unionId.length == 0) {
            return;
        }
        NSDictionary *dic;
        if ([weakSelf.model.type isEqualToString:@"wehcat"]) {
            dic = @{@"type":@"wehcat",@"unionid":resp.unionId,@"id":weakSelf.model.Id,@"action":@"cancel"};
        }else{
            dic = @{@"type":@"wehcat",@"unionid":resp.unionId,@"action":@"add"};
        }
        
        [weakSelf.networkViewModel.memberSetOauthBind execute:dic];
    }];
}
//
- (SharePodStyleViewModel *)podStyleViewModel{
    if (!_podStyleViewModel) {
        _podStyleViewModel = [[SharePodStyleViewModel alloc]init];
        __weak typeof(self)weakSelf = self;
        //点击
        [_podStyleViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
            if ([x isEqualToString:@"确定解绑微信?"]) {
                [weakSelf getUserInfoForPlatform];
            }
        }];
    }
    return _podStyleViewModel;
}

- (ClientMineNetworkViewModel *)networkViewModel{
    if (!_networkViewModel) {
        _networkViewModel = [[ClientMineNetworkViewModel alloc]init];
    }
    return _networkViewModel;
}

@end
