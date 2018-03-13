//
//  ClientInformationDetailsViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientInformationDetailsViewController.h"
#import <UShareUI/UShareUI.h>
#import "ZWPullMenuView.h"
#import "ClientHomeMenuDetailsViewModel.h"
#import "ClientHomeViewModel.h"
#import <WebKit/WebKit.h>
@interface ClientInformationDetailsViewController ()<UMSocialShareMenuViewDelegate,WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong)ClientHomeMenuDetailsViewModel *menuDetailsViewModel;

@property (nonatomic, strong)ClientHomeViewModel *netWorkViewModel;
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation ClientInformationDetailsViewController

- (void)dealloc{
   MMJF_Log(@"%s",__FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigation];
    [self setUpUMShare];
    if (self.isB == NO) {
        [self setUpData];
    }
    [self initWKWebView];
}


- (void)initWKWebView
{
    //创建并配置WKWebView的相关参数
    //1.WKWebViewConfiguration:是WKWebView初始化时的配置类，里面存放着初始化WK的一系列属性；
    //2.WKUserContentController:为JS提供了一个发送消息的通道并且可以向页面注入JS的类，WKUserContentController对象可以添加多个scriptMessageHandler；
    //3.addScriptMessageHandler:name:有两个参数，第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。添加一个脚本消息的处理器,同时需要在JS中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    if (MMJF_ShareV.isCustomer == YES) {
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, MMJF_HEIGHT) configuration:configuration];
    }else{
        if (MMJF_HEIGHT > 800) {
            self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, MMJF_HEIGHT - 88) configuration:configuration];
        }else{
            self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, MMJF_HEIGHT - 64) configuration:configuration];
        }
    }
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MMJF_H5Url,v1ArticleDetails]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    [self.view addSubview:self.webView];
    
}

#pragma mark - WKUIDelegate

//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
//{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
//    MMJF_Log(@"%@",message);
//    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        completionHandler();
//    }]];
//
//    [self presentViewController:alert animated:YES completion:nil];
//
//}

#pragma mark - Method
- (void)shareWithInformation
{
    NSString *str;
    if (self.isMy == YES) {
        str = self.model.object_id;
    }else{
        str = self.model.Id;
    }
    //OC反馈给JS分享结果
    NSString *JSResult = [NSString stringWithFormat:@"atokenResult('%@','%@','%@')",MMJF_ShareV.token,MMJF_ShareV.phoneId,str];
    MMJF_Log(@"%@",JSResult);
    //OC调用JS
    [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        MMJF_Log(@"     asasda%@ error%@", result,error);
    }];
}
// 页面完成加载;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self shareWithInformation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
    });
}
//开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [MBProgressHUD showGifToView:self.view];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    CQPlaceholderView *placeholderView = [[CQPlaceholderView alloc]initWithFrame:CGRectMake(0, 0, MMJF_WIDTH,MMJF_HEIGHT) type:MMJFPlaceholderViewTypeLoan delegate:self];
    [self.view addSubview:placeholderView];
}

//设置导航条
- (void)setUpNavigation{
    self.title = @"详情";
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

- (void)setUpMenuView:(UIButton *)sender{
    
    NSArray *titleArray;
    NSArray *imageArray = [NSArray array];
    if (self.isB == YES) {
        titleArray = @[@"分享"];
        imageArray = @[@"fen-xiang-hui"];
    }else{
        titleArray = @[@"收藏",@"分享"];
        if (self.menuDetailsViewModel.isCollection == YES) {
            imageArray = @[@"huang-xing-1",
                           @"fen-xiang-hui"];
        }else{
            imageArray = @[@"hui-xing-1",
                           @"fen-xiang-hui"];
        }
    }
    
    
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender
                                                       titleArray:titleArray
                                                       imageArray:imageArray];
    
    
    [self setUpMenuViewModel:menuView];
}

- (void)setUpMenuViewModel:(ZWPullMenuView *)view{
    self.menuDetailsViewModel.isB = self.isB;
    [self.menuDetailsViewModel bindViewToViewModel:view];
    
    __weak typeof(self)weakSelf = self;
    [self.menuDetailsViewModel.shareSubject subscribeNext:^(id  _Nullable x) {
        [weakSelf shareMenu];
    }];
    [self.menuDetailsViewModel.favoriteSubject subscribeNext:^(id  _Nullable x) {
        NSString *str;
        if (weakSelf.isMy == YES) {
            str = weakSelf.model.object_id;
        }else{
            str = weakSelf.model.Id;
        }
        if ([x isEqualToString:@"1"]) {
            NSDictionary *dic = @{@"id":str,@"type":@"2",@"action":@"cancel"};
            [weakSelf.netWorkViewModel.setFavoriteCommand execute:dic];
        }else{
            NSDictionary *dic = @{@"id":str,@"type":@"2",@"action":@"add"};
            [weakSelf.netWorkViewModel.setFavoriteCommand execute:dic];
        }
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
            pasteboard.string = [NSString stringWithFormat:@"%@Article-details-shar.html?art_id=%@",MMJF_H5Url,weakSelf.model.Id];
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.title descr:self.model.introduce thumImage:[self getImageFromURL:[NSString judgeHttp:self.model.picture]]];
    MMJF_Log(@"%@,%@,%@",self.model.title,self.model.introduce,[self getImageFromURL:[NSString judgeHttp:self.model.picture]]);
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@Article-details-shar.html?art_id=%@",MMJF_H5Url,self.model.Id];
    
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



- (void)setUpData{
    __weak typeof(self)weakSelf = self;
    if (MMJF_ShareV.uid.length != 0) {
        //检查收藏
        [self.netWorkViewModel.checkFavoriteCommand.executionSignals.
         switchToLatest subscribeNext:^(id  _Nullable x) {
             MMJF_Log(@"%@",x);
             NSString *str = [NSString stringWithFormat:@"%@",x[@"is_favorite"]];
             if ([str isEqualToString:@"0"]) {
                 weakSelf.menuDetailsViewModel.isCollection = NO;
             }else{
                 weakSelf.menuDetailsViewModel.isCollection = YES;
             }
         }];
        NSString *str;
        if (weakSelf.isMy == YES) {
            str = weakSelf.model.object_id;
        }else{
            str = weakSelf.model.Id;
        }
        NSDictionary *dic = @{@"type":@"2",@"id":str};
        [self.netWorkViewModel.checkFavoriteCommand execute:dic];
    }
    //收藏
    [self.netWorkViewModel.setFavoriteCommand.executionSignals.
     switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
         if (weakSelf.menuDetailsViewModel.isCollection == NO) {
             [MBProgressHUD showSuccess:@"收藏成功"];
         }else{
             [MBProgressHUD showSuccess:@"取消收藏成功"];
         }
        weakSelf.menuDetailsViewModel.isCollection = !weakSelf.menuDetailsViewModel.isCollection;
    }];
}

#pragma mark--getter
- (ClientHomeMenuDetailsViewModel *)menuDetailsViewModel{
    if (!_menuDetailsViewModel) {
        _menuDetailsViewModel = [[ClientHomeMenuDetailsViewModel alloc]init];
    }
    return _menuDetailsViewModel;
}

- (ClientHomeViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[ClientHomeViewModel alloc]init];
    }
    return _netWorkViewModel;
}

@end
