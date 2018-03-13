//
//  ClientMineWebPageViewController.m
//  Maomao
//
//  Created by 御顺 on 2018/1/15.
//  Copyright © 2018年 御顺. All rights reserved.
//

#import "ClientMineWebPageViewController.h"
#import <WebKit/WebKit.h>

@interface ClientMineWebPageViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@end

@implementation ClientMineWebPageViewController

- (void)dealloc{
    MMJF_Log(@"%s",__FUNCTION__);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.number == 2 || self.number == 5) {
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (self.number == 2) {
        self.navigationController.navigationBarHidden = YES;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: MMJF_COLOR_Yellow} forState:UIControlStateNormal];
    if (self.number == 1) {
        self.title = @"我能贷多少";
    }else if (self.number == 2){
        self.title = @"注册服务协议";
    }else if (self.number == 3){
        self.title = @"关于我们";
    }else if (self.number == 4){
        self.title = @"积分规则";
    }else if (self.number == 5){
        self.title = @"邀请奖励规则";
    }else if (self.number == 6){
        self.title = @"房贷计算器";
    }else if (self.number == 7){
        self.title = @"实名认证协议";
    }
    
    self.navigationController.navigationBar.barTintColor = MMJF_COLOR_Yellow;
    [self initWKWebView];
}

- (void)initWKWebView
{
    //创建并配置WKWebView的相关参数
    //1.WKWebViewConfiguration:是WKWebView初始化时的配置类，里面存放着初始化WK的一系列属性；
    //2.WKUserContentController:为JS提供了一个发送消息的通道并且可以向页面注入JS的类，WKUserContentController对象可以添加多个scriptMessageHandler；
    //3.addScriptMessageHandler:name:有两个参数，第一个参数是userContentController的代理对象，第二个参数是JS里发送postMessage的对象。添加一个脚本消息的处理器,同时需要在JS中添加，window.webkit.messageHandlers.<name>.postMessage(<messageBody>)才能起作用。
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    ////标记为C端
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
    NSURL *url;
    if (self.number == 1) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MMJF_H5Url,v1How]];
    }else if (self.number == 2){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MMJF_H5Url,v1logupArg]];
    }else if (self.number == 3){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MMJF_H5Url,v1aboutus]];
    }else if (self.number == 4){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MMJF_H5Url,v1interHelp]];
    }else if (self.number == 5){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MMJF_H5Url,v1recom]];
    }else if (self.number == 6){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MMJF_H5Url,v1calculator]];
    }else if (self.number == 7){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MMJF_H5Url,v1authen]];
    }
    
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
    //OC反馈给JS分享结果
    NSString *JSResult;
    if (self.number == 1) {
        JSResult = [NSString stringWithFormat:@"atokenResult('%@','%@')",MMJF_ShareV.token,MMJF_ShareV.phoneId];
    }
        
    //OC调用JS
    [self.webView evaluateJavaScript:JSResult completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        MMJF_Log(@"     asasda%@ error%@", result,error);
    }];
}
// 页面完成加载;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (self.number == 1) {
         [self shareWithInformation];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
