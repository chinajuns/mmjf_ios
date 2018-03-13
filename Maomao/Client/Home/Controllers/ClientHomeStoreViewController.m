//
//  ClientHomeStoreViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeStoreViewController.h"
#import "ZWPullMenuView.h"
#import "ClientHomeMenuDetailsViewModel.h"
#import <UShareUI/UShareUI.h>
#import "ClientHomeViewModel.h"
#import "ClientHomeProductViewController.h"
#import "ClientHomeLoanInputViewController.h"

#import <WebKit/WebKit.h>
#import "ClientHomeEvaluationViewController.h"

@interface ClientHomeStoreViewController ()<UMSocialShareMenuViewDelegate,WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate,CQPlaceholderViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lien;
@property (nonatomic, strong)ClientHomeMenuDetailsViewModel *menuDetailsViewModel;

@property (strong, nonatomic) WKWebView *webView;

/**
 判断滑块
 */
@property (nonatomic, assign)BOOL isOK;

@property (nonatomic, strong)ClientHomeViewModel *homeViewModel;
/**
 信贷经理id
 */
@property (nonatomic, copy)NSString *managerId;

/**
 分享图片
 */
@property (nonatomic, copy)NSString *imagUrl;

/**
 标题
 */
@property (nonatomic, copy)NSString *titleStr;

/**
 内容
 */
@property (nonatomic, copy)NSString *cotentStr;
@end

@implementation ClientHomeStoreViewController

- (void)dealloc{
    MMJF_Log(@"%s",__FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
    self.navigationController.navigationBarHidden = NO;
    //这里需要注意，前面增加过的方法一定要remove掉。
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"Show"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"showeva"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    // 因此这里要记得移除handlers
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"Show"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"showeva"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isMy == YES) {
        self.managerId = self.model.object_id;
        self.imagUrl = [NSString judgeHttp:self.model.header_img];
        self.titleStr = self.model.name;
        self.cotentStr = self.model.tag;
    }else{
        self.managerId = self.managerModel.Id;
        self.imagUrl = [NSString judgeHttp:self.managerModel.header_img];
        self.titleStr = self.managerModel.name;
        self.cotentStr = self.managerModel.tags;
    }
    MMJF_Log(@"%@",self.managerId);
    [self setUpNavigation];
    [self setUpUMShare];
    [self setUpData];
    [self initWKWebView];
   
}

- (void)initWKWebView
{
    //创建并配置WKWebView的相关参数
    //1.WKWebViewConfiguration:是WKWebView初始化时的配置类，里面存放着初始化WK的一系列属性；
    //2.WKUserContentController:为JS提供了一个发送消息的通道并且可以向页面注入JS的类，WKUserContentController对象可以添加多个scriptMessageHandler；
    //3.addScriptMessageHandler:name:有两个参数，第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。添加一个脚本消息的处理器,同时需要在JS中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
   
    if (MMJF_HEIGHT > 800) {
        self.lien.constant = 24;
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, MMJF_HEIGHT - 50 - 88) configuration:configuration];
    }else{
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MMJF_WIDTH, MMJF_HEIGHT - 50 - 64) configuration:configuration];
    }
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    
    NSURL *url = [NSURL URLWithString:MMJF_H5Url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    [self.view addSubview:self.webView];
    
}

#pragma mark -- WKScriptMessageHandler
/**
 *  JS 调用 OC 时 webview 会调用此方法
 *
 *  @param userContentController  webview中配置的userContentController 信息
 *  @param message                JS执行传递的消息
 */

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //JS调用OC方法
    //message.boby就是JS里传过来的参数
    MMJF_Log(@"body:%@",message.body);
    
    if ([message.name isEqualToString:@"Show"]) {
        //跳转产品详情
        ClientHomeProductViewController *vc = [[ClientHomeProductViewController alloc]init];
        
        vc.loaner_id = [NSString stringWithFormat:@"%@",self.managerId];
        vc.Id = message.body;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([message.name isEqualToString:@"showeva"]) {
        //跳转评论
        ClientHomeEvaluationViewController *vc = [[ClientHomeEvaluationViewController alloc]init];
        vc.Id = self.managerId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
    //OC反馈给JS分享结果
    NSString *JSResult = [NSString stringWithFormat:@"tokenResult('%@','%@','%@')",MMJF_ShareV.token,MMJF_ShareV.phoneId,self.managerId];
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
    if (MMJF_HEIGHT > 800) {
        self.lien.constant = 24;
    }
    self.title = @"店铺";
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
    if (_isOK == YES) {//不能右滑返回
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else{//能右滑返回
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    _isOK = !_isOK;
    
    
    NSArray *titleArray = @[@"收藏",@"分享"];
    NSArray *imageArray = [NSArray array];
    if (self.menuDetailsViewModel.isCollection == YES) {
        imageArray = @[@"huang-xing-1",
                        @"fen-xiang-hui"];
    }else{
        imageArray = @[@"hui-xing-1",
                        @"fen-xiang-hui"];
    }
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender
                                                       titleArray:titleArray
                                                       imageArray:imageArray];


    [self setUpMenuViewModel:menuView];
}

- (void)setUpMenuViewModel:(ZWPullMenuView *)view{
    [self.menuDetailsViewModel bindViewToViewModel:view];
    
    __weak typeof(self)weakSelf = self;
    [self.menuDetailsViewModel.shareSubject subscribeNext:^(id  _Nullable x) {
        [weakSelf shareMenu];
    }];
    [self.menuDetailsViewModel.favoriteSubject subscribeNext:^(id  _Nullable x) {
        if ([x isEqualToString:@"1"]) {
            NSDictionary *dic = @{@"id":weakSelf.managerId,@"type":@"1",@"action":@"cancel"};
            [weakSelf.homeViewModel.setFavoriteCommand execute:dic];
        }else{
            NSDictionary *dic = @{@"id":weakSelf.managerId,@"type":@"1",@"action":@"add"};
            [weakSelf.homeViewModel.setFavoriteCommand execute:dic];
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
            pasteboard.string = [NSString stringWithFormat:@"%@indexShare.html?art_id=%@",MMJF_H5Url,weakSelf.managerId];
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
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:self.cotentStr thumImage:[self getImageFromURL:[NSString judgeHttp:self.imagUrl]]];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"%@indexShare.html?art_id=%@",MMJF_H5Url,self.managerId];
    
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
    MMJF_Log(@"%@",MMJF_ShareV.uid);
    if (MMJF_ShareV.uid.length != 0) {
        //检查收藏
        [self.homeViewModel.checkFavoriteCommand.executionSignals.
         switchToLatest subscribeNext:^(id  _Nullable x) {
             MMJF_Log(@"%@",x);
             NSString *str = [NSString stringWithFormat:@"%@",x[@"is_favorite"]];
             if ([str isEqualToString:@"0"]) {
                 weakSelf.menuDetailsViewModel.isCollection = NO;
             }else{
                 weakSelf.menuDetailsViewModel.isCollection = YES;
             }
         }];
        
        NSDictionary *dic = @{@"type":@"1",@"id":self.managerId};
        [self.homeViewModel.checkFavoriteCommand execute:dic];
    }
    //收藏
    [self.homeViewModel.setFavoriteCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        if (weakSelf.menuDetailsViewModel.isCollection == NO) {
            [MBProgressHUD showSuccess:@"收藏成功"];
        }else{
            [MBProgressHUD showSuccess:@"取消收藏成功"];
        }
        weakSelf.menuDetailsViewModel.isCollection = !weakSelf.menuDetailsViewModel.isCollection;
    }];
}

//我要贷款
- (IBAction)loanBut:(UIButton *)sender {
    ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
    if (!user) {//未登录
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LogonFailure" object:nil userInfo:@{}];
    }else{
        ClientHomeLoanInputViewController *vc = [[ClientHomeLoanInputViewController alloc]init];
        vc.loaner_id = self.managerId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/** 占位图的重新加载按钮点击时回调 */
- (void)placeholderView:(CQPlaceholderView *)placeholderView{
    switch (placeholderView.type) {
        case MMJFPlaceholderViewTypeLoan:  // 没数据
        {
//            [self refreshView];
        }
            break;
            
        default:
            break;
    }
}
//重新加载
- (void)refreshView{
    [MBProgressHUD showGifToView:self.view];
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    
}

#pragma mark--getter
- (ClientHomeMenuDetailsViewModel *)menuDetailsViewModel{
    if (!_menuDetailsViewModel) {
        _menuDetailsViewModel = [[ClientHomeMenuDetailsViewModel alloc]init];
    }
    return _menuDetailsViewModel;
}

- (ClientHomeViewModel *)homeViewModel{
    if (!_homeViewModel) {
        _homeViewModel = [[ClientHomeViewModel alloc]init];
    }
    return _homeViewModel;
}
@end
