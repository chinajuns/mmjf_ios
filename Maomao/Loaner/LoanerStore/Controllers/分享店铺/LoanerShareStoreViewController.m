//
//  LoanerShareStoreViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerShareStoreViewController.h"
#import "LoanerShareStoreViewModel.h"
#import <UShareUI/UShareUI.h>
#import "LoanerShareEditorViewController.h"

@interface LoanerShareStoreViewController ()<UMSocialShareMenuViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic, strong)LoanerShareStoreViewModel *shareStoreViewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (weak, nonatomic) IBOutlet UIView *backView;
@end

@implementation LoanerShareStoreViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (MMJF_HEIGHT > 800) {
        self.line.constant = 88;
    }
    
    //如果iOS的系统是11.0，会有这样一个宏定义“#define __IPHONE_11_0  110000”；如果系统版本低于11.0则没有这个宏定义
#ifdef __IPHONE_11_0
    if ([self.listTab respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            self.listTab.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
#endif
    [self setUpShareStoreViewModel];
    [self setUpUMShare];
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
//            pasteboard.string = [NSString stringWithFormat:@"%@indexShare.html?art_id=%@",MMJF_H5Url,weakSelf.managerId];
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
    
    //创建网页内容对象
    UIImage* thumbURL =  [UIImage imageNamed:@"banner-3"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"https://www.baidu.com";
    
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
//返回
- (IBAction)backBut:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)operationBut:(UIButton *)sender {
    if (sender.tag == 0) {//编辑
        LoanerShareEditorViewController *vc = [[LoanerShareEditorViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{//分享
        [self shareMenu];
    }
}
- (void)setUpShareStoreViewModel{
    [self.shareStoreViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    [self.shareStoreViewModel.slidingSubject subscribeNext:^(id  _Nullable x) {
        // 1. 开始动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        if ([x floatValue] > 20) {
            // 2.动画代码
            weakSelf.backView.backgroundColor = MMJF_COLOR_Yellow;
        }else{
            // 2.动画代码
            weakSelf.backView.backgroundColor = [UIColor clearColor];
        }
        // 3.提交动画
        [UIView commitAnimations];
    }];
}

- (LoanerShareStoreViewModel *)shareStoreViewModel{
    if (!_shareStoreViewModel) {
        _shareStoreViewModel = [[LoanerShareStoreViewModel alloc]init];
    }
    return _shareStoreViewModel;
}

@end
