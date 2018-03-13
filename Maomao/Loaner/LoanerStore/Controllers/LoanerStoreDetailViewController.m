//
//  LoanerStoreDetailViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreDetailViewController.h"
#import "LoanerStoreDetailViewModel.h"
#import "LoanerStoreCustomerOrderViewController.h"
#import "LoanerAgentProductsViewController.h"
#import "LoanerTheAgentListViewController.h"
#import "LoanerHomeMicroBCViewController.h"
#import "LoanerShareStoreViewController.h"
#import "LoanerStoreNetWorkViewModel.h"
#import "UIViewController+BackButtonHandler.h"
#import <UShareUI/UShareUI.h>
#import "LoanerStoreOrderDetaillViewController.h"

@interface LoanerStoreDetailViewController ()<UMSocialShareMenuViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;
@property (weak, nonatomic) IBOutlet UITableView *listTab;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong)LoanerShopInfoModel *model;

@property (nonatomic, strong)LoanerStoreNetWorkViewModel *netWorkViewModel;

@property (nonatomic, strong)LoanerStoreDetailViewModel *detailViewModel;
@end

@implementation LoanerStoreDetailViewController

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

- (BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToRootViewControllerAnimated:YES];
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (MMJF_HEIGHT > 800) {
        self.line.constant = 88;
    }
    [self setUpDetailViewModel];
    [self setUpUMShare];
    [self setUpNetWork];
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
}
//设置网络请求
- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.shopIndexCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        weakSelf.model = [LoanerShopInfoModel yy_modelWithJSON:x[@"shop_info"]];
        weakSelf.detailViewModel.model= weakSelf.model;
        NSArray *array = x[@"order"];
        [weakSelf.detailViewModel refresh:array];
    }];
    [self.netWorkViewModel.shopIndexCommand execute:nil];
}

- (void)setUpDetailViewModel{
    [self.detailViewModel bindViewToViewModel:self.listTab];
    __weak typeof(self)weakSelf = self;
    [self.detailViewModel.slidingSubject subscribeNext:^(id  _Nullable x) {
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
    
    [self.detailViewModel.clickSubject subscribeNext:^(id  _Nullable x) {
        [weakSelf stateBut:[x integerValue]];
    }];
    
    [self.detailViewModel.storeDetailSubject subscribeNext:^(id  _Nullable x) {
        LoanerStoreOrderDetaillViewController *vc = [[LoanerStoreOrderDetaillViewController alloc]init];
        vc.Id = x[@"id"];
        vc.isRefer = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)stateBut:(NSInteger)number{
    switch (number) {
        case 0:
        {//客户订单
            LoanerStoreCustomerOrderViewController *vc = [[LoanerStoreCustomerOrderViewController alloc]init];
            vc.isRefer = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {//代理产品
            LoanerAgentProductsViewController *vc = [[LoanerAgentProductsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {//已代理产品
            LoanerTheAgentListViewController *VC = [[LoanerTheAgentListViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 3:
        {//分享名片
            LoanerHomeMicroBCViewController *vc  = [[LoanerHomeMicroBCViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {//分享店铺
//            LoanerShareStoreViewController *VC = [[LoanerShareStoreViewController alloc]init];
//            [self.navigationController pushViewController:VC animated:YES];
            [self shareMenu];
        }
            break;
            
        default:
            break;
    }
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
            pasteboard.string = [NSString stringWithFormat:@"%@indexShare.html?art_id=%@",MMJF_H5Url,weakSelf.model.loaner_id];
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.username descr:self.model.introduce thumImage:[self getImageFromURL:[NSString judgeHttp:self.model.header_img]]];
//    MMJF_Log(@"%@,%@,%@",self.model.title,self.model.introduce,[self getImageFromURL:[NSString judgeHttp:self.model.picture]]);
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@indexShare.html?art_id=%@",MMJF_H5Url,self.model.loaner_id];
    
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

- (IBAction)backView:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (LoanerStoreDetailViewModel *)detailViewModel{
    if (!_detailViewModel) {
        _detailViewModel = [[LoanerStoreDetailViewModel alloc]init];
    }
    return _detailViewModel;
}

- (LoanerStoreNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerStoreNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
}
@end
