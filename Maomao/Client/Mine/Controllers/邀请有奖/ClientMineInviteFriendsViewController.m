//
//  ClientMineInviteFriendsViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/6.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineInviteFriendsViewController.h"
#import "ClientMIneInviteAnnotationsViewController.h"
#import "ClientMineWebPageViewController.h"
#import "ClientMineNetworkViewModel.h"
#import <UShareUI/UShareUI.h>
#import "ClientMineInviteInfo.h"

@interface ClientMineInviteFriendsViewController ()<UMSocialShareMenuViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *peopleLab;

@property (weak, nonatomic) IBOutlet UILabel *pointsLab;

@property (weak, nonatomic) IBOutlet UIButton *shareBut;
@property (weak, nonatomic) IBOutlet UIButton *qrCodeBut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine;
@property (weak, nonatomic) IBOutlet UITextView *lnviteCodeText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;
/**
 二维码
 */
@property (nonatomic, copy)NSString *qrCodeStr;
@property (nonatomic, strong)SharePodStyleViewModel *podStyleViewModel;
@property (nonatomic, strong)ClientMineNetworkViewModel *networkViewModel;
@end

@implementation ClientMineInviteFriendsViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    [self.networkViewModel.memberInviteInfo execute:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (MMJF_HEIGHT > 800) {
        self.bottomLine.constant = 22;
        self.topLine.constant = 51;
    }
    [self setUpUMShare];
    [self setUpNetwork];
}
//二维码
- (void)qrCodeAlert{
    TYAlertController *alertController = [self.podStyleViewModel setUpShareImgView:[NSString judgeHttp:self.qrCodeStr]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)clickBut:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (sender.tag == 1){
        ClientMineWebPageViewController *vc = [[ClientMineWebPageViewController alloc]init];
        vc.number = 5;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 2){//分享邀请
        [self shareMenu];
    }else if (sender.tag == 3){//二维码邀请
        [self qrCodeAlert];
    }
}
//个人中心：分享：二维码
- (void)setUpNetwork{
    __weak typeof(self)weakSelf = self;
    [self.networkViewModel.webGetQrcode.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        weakSelf.qrCodeStr = x[@"qrcode"];
    }];
    [self.networkViewModel.memberInviteInfo.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        ClientMineInviteInfo *model = [ClientMineInviteInfo yy_modelWithJSON:x];
        //设置网页地址
        NSString *url = [NSString stringWithFormat:@"%@share.html?mobile=%@",MMJF_H5Url,model.mobile];
        NSDictionary *dic = @{@"url":url};
        weakSelf.peopleLab.text = [NSString stringWithFormat:@"%@",model.count];
        weakSelf.pointsLab.text = [NSString stringWithFormat:@"%@",model.number];
        weakSelf.lnviteCodeText.text = model.mobile;
        [weakSelf.networkViewModel.webGetQrcode execute:dic];
    }];
}

- (void)setUpUMShare{
    //设置用户自定义的平台
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),
                                               @(UMSocialPlatformType_WechatTimeLine),
                                               @(UMSocialPlatformType_WechatSession),
                                               @(UMSocialPlatformType_QQ),
                                               @(UMSocialPlatformType_Qzone),
                                               @(UMSocialPlatformType_UserDefine_Begin+1)
                                               ]];
    
    //设置分享面板的显示和隐藏的代理回调
    [UMSocialUIManager setShareMenuViewDelegate:self];
}

- (void)shareMenu{
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_UserDefine_Begin+1
                                     withPlatformIcon:[UIImage imageNamed:@"fu-zhi-lian-jie-1"]
                                     withPlatformName:@"复制"];
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    __weak typeof(self)weakSelf = self;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        //在回调里面获得点击的
        if (platformType == UMSocialPlatformType_UserDefine_Begin+1){
            [MBProgressHUD showSuccess:@"复制成功!"];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
            pasteboard.string = [NSString stringWithFormat:@"%@share.html?mobile=%@",MMJF_H5Url,user.mobile];
        }else{
            [weakSelf shareWebPageToPlatformType:platformType];
        }
    }];
    
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UIImage *img = [UIImage imageNamed:@"icon"];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"推荐有奖" descr:@"邀请有奖" thumImage:img];
    ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
    MMJF_Log(@"%@",user.mobile);
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@share.html?mobile=%@",MMJF_H5Url,user.mobile];
    MMJF_Log(@"%@",[NSString stringWithFormat:@"%@share.html?mobile=%@",MMJF_H5Url,user.mobile]);
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}

- (SharePodStyleViewModel *)podStyleViewModel{
    if (!_podStyleViewModel) {
        _podStyleViewModel = [[SharePodStyleViewModel alloc]init];
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
