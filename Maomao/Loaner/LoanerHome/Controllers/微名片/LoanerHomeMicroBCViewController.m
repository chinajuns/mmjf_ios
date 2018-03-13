//
//  LoanerHomeMicroBCViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerHomeMicroBCViewController.h"
#import <UShareUI/UShareUI.h>
#import "LoanerHomeEditCardViewController.h"
#import <WebKit/WebKit.h>

static NSUInteger const kSnapshotImageDataLengthMax = 1 * 1024 * 1024; // 最大 1 M

@interface LoanerHomeMicroBCViewController ()<UMSocialShareMenuViewDelegate,WKUIDelegate,WKNavigationDelegate>
@property (strong, nonatomic) WKWebView *webView;
@end

@implementation LoanerHomeMicroBCViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微名片";
    [self setUpNavigation];
    [self setUpUMShare];
    [self initWKWebView];
}

- (void)setUpNavigation{
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setImage:[UIImage imageNamed:@"fen-xiang-chu-qu"] forState:UIControlStateNormal];
    [right setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    right.frame = CGRectMake(0, 0, 50, 44);
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem= rightItem;
    __weak typeof(self)weakSelf = self;
    //打开右
    [[right rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf cutPic];
    }];
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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MMJF_H5Url,v1sharecard]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    [self.view addSubview:self.webView];
    
}

#pragma mark - Method
- (void)shareWithInformation
{
    //OC反馈给JS分享结果
    NSString *JSResult = [NSString stringWithFormat:@"getCard('%@','%@','%@')",MMJF_ShareV.phoneId,MMJF_ShareV.token,MMJF_ShareV.loaner_id];
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


//编辑、分享
- (IBAction)clickBut:(UIButton *)sender {
    if (sender.tag == 1) {
//        [self shareMenu];
    }else{
        LoanerHomeEditCardViewController *vc = [[LoanerHomeEditCardViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
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

- (void)shareMenu:(UIImage *)imga{
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
            pasteboard.image = imga;
        }else{
            [weakSelf shareWebPageToPlatformType:platformType shareImag:imga];
        }
        
    }];
    
}

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType shareImag:(UIImage *)shareImag
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
    shareObject.thumbImage = [UIImage imageNamed:@"mao-mao-jin-fu-t"];
    
    [shareObject setShareImage:shareImag];
    
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

- (void)cutPic{
    CGRect snapshotFrame = CGRectMake(0, 0, _webView.scrollView.contentSize.width, _webView.scrollView.contentSize.height);
    UIEdgeInsets snapshotEdgeInsets = UIEdgeInsetsZero;
    UIImage *shareImage = [self snapshotViewFromRect:snapshotFrame withCapInsets:snapshotEdgeInsets];
    if (shareImage) {
        [self shareMenu:shareImage];
    }
    MMJF_Log(@"%@",shareImage);
}

- (UIImage *)snapshotViewFromRect:(CGRect)rect withCapInsets:(UIEdgeInsets)capInsets {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize boundsSize = self.webView.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize contentSize = self.webView.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
//    CGFloat contentWidth = contentSize.width;
    
    CGPoint offset = self.webView.scrollView.contentOffset;
    
    [self.webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0) {
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, [UIScreen mainScreen].scale);
        [self.webView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:image];
        
        CGFloat offsetY = self.webView.scrollView.contentOffset.y;
        [self.webView.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    
    
    [self.webView.scrollView setContentOffset:offset];
    
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,
                                     scale * boundsHeight * idx,
                                     scale * boundsWidth,
                                     scale * boundsHeight)];
    }];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * snapshotView = [[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    
    snapshotView.image = [fullImage resizableImageWithCapInsets:capInsets];
    return [self p_compressImage:snapshotView.image maxDataLength:kSnapshotImageDataLengthMax];
}

/// 体积限制
- (UIImage *)p_compressImage:(UIImage *)image maxDataLength:(NSUInteger)length {
    
    NSData *jpegData = UIImageJPEGRepresentation(image, 0.8);
    UIImage *newImage = image;
    
    
    if (jpegData.length > length) {
#if DEBUG
        MMJF_Log(@"图片大小：%li, 图片尺寸：w-%g,h-%g", jpegData.length, image.size.width, image.size.height);
#endif
        jpegData = UIImageJPEGRepresentation(newImage, 0.5); // 压缩
        newImage = [UIImage imageWithData:jpegData];
        
    }
    
    
    return newImage;
}
@end
