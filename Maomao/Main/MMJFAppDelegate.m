//
//  AppDelegate.m
//  Maomao
//
//  Created by 御顺 on 2017/11/15.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFAppDelegate.h"
#import "DefineKeyChain.h"
#import "CYTabBarController.h"

#import "MMJFTabBarViewController.h"
#import "ClientRightDrawerViewController.h"

#import "MMJFBaseNavigationViewController.h"
#import "LogHomeViewController.h"
#import "ClientUserModel.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <UMSocialCore/UMSocialCore.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

NSString * const KEY_USERNAME_PASSWORD = @"com.company.app.usernamepassword";
NSString * const KEY_UUID = @"com.company.app.UUID";

BMKMapManager* _mapManager;
@interface MMJFAppDelegate ()<IIViewDeckControllerDelegate,JPUSHRegisterDelegate>
@property (strong,nonatomic) NSMutableDictionary *saveInfomation;
@end

@implementation MMJFAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor blackColor];
    [self.window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //设置百度地图
    [self setUpBaiduMap];
//    __weak typeof(self)weakSelf = self;
//    //设置友盟分享
    [self configUSharePlatforms];
    //设置键盘
    [self setUpkeyboard];
//    //获取唯一id
    [self getObtainUUID];
    //极光推送
    [self jPush:launchOptions];
    //重新获取token
    [MMJF_NetworkShare v1getToken];
    
    ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
    MMJF_Log(@"%@",user.mobile);
    if (user) {
        if ([user.type isEqualToString:@"1"]) {
            //C端
            [self setClientRootView];
        }else{
            //B端
            [self setLoanerRootView];
        }
    }else{
        //C端
        [self setClientRootView];
    }
    //C端
//    [self setClientRootView];
    
    //B端
//    [self setLoanerRootView];
    
    
    
    return YES;
}
//设置键盘
- (void)setUpkeyboard{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    
    keyboardManager.keyboardDistanceFromTextField = 30.0f; // 输入框距离键盘的距离
}

//设置登录模块根视图
- (void)setLogRootView{
    LogHomeViewController *log = [[LogHomeViewController alloc]init];
    MMJFBaseNavigationViewController *nav = [[MMJFBaseNavigationViewController alloc]initWithRootViewController:log];
    self.window.rootViewController = nav;
}
//设置B端根视图
- (void)setLoanerRootView{
    MMJF_ShareV.isCustomer = NO;
    CYTabBarController * tabbar = [[CYTabBarController alloc]init];
    
    self.window.rootViewController = tabbar;
}
//设置C端根视图
- (void)setClientRootView{
    MMJFTabBarViewController *tab = [[MMJFTabBarViewController alloc]init];
    ClientRightDrawerViewController *rightVC = [[ClientRightDrawerViewController alloc]init];
    IIViewDeckController *viewDeckController =[[IIViewDeckController alloc]initWithCenterViewController:tab leftViewController:nil rightViewController:rightVC];
    MMJF_ShareV.isCustomer = YES;
    viewDeckController.delegate = self;
    viewDeckController.panningEnabled = NO;
    self.window.rootViewController=viewDeckController;
}
//设置百度地图
- (void)setUpBaiduMap{
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        MMJF_Log(@"经纬度类型设置成功");
    } else {
        MMJF_Log(@"经纬度类型设置失败");
    }
    BOOL ret = [_mapManager start:MAP_APPKEY generalDelegate:self];
    if (!ret) {
        MMJF_Log(@"manager start failed!");
    }
}
- (BOOL)viewDeckController:(IIViewDeckController *)viewDeckController willOpenSide:(IIViewDeckSide)side{
    return YES;
}

//配置三方分享
- (void)configUSharePlatforms
{
    [UMSocialGlobal shareInstance].isClearCacheWhenGetUserInfo = NO;
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WX_APPID appSecret:WX_appSecret redirectURL:nil];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_APPKET/*设置QQ平台的appID*/  appSecret:nil redirectURL:nil];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:WB_APPKEY  appSecret:WB_appSecret redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
}

// 分享回调支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //极光
    [JPUSHService registerDeviceToken:deviceToken];
}


//初始化推送
- (void)jPush:(NSDictionary *)launchOptions{
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];

    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            MMJF_Log(@"registrationID获取成功：%@",registrationID);
            if (registrationID.length == 0) {
                registrationID = @"";
            }
            [MMJF_DEFAULTS setObject:registrationID forKey:@"registrationID"];
        }else{
            MMJF_Log(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}
//极光推送
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    MMJF_Log(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
        //        [rootViewController addNotificationCount];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonPress" object:nil userInfo:nil];
    }

    completionHandler(UIBackgroundFetchResultNewData);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;

    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容

    NSNumber *badge = content.badge;  // 推送消息的角标
    MMJF_ShareV.badge = [badge integerValue];
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        MMJF_Log(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"buttonPress" object:nil userInfo:nil];
        //        [rootViewController addNotificationCount];
        //进入APP调用
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushLogUnreadCount" object:nil userInfo:nil];
    }
    else {
        // 判断为本地通知
        MMJF_Log(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}


- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {

    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容

    NSNumber *badge = content.badge;  // 推送消息的角标
    MMJF_ShareV.badge = [badge integerValue];
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        MMJF_Log(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        //        [rootViewController addNotificationCount];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PushNotificationDidChangeNotification" object:nil userInfo:nil];
    }
    else {
        // 判断为本地通知
        MMJF_Log(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }

    completionHandler();  // 系统要求执行这个方法
}
#endif

//当应用程序将要入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了
- (void)applicationWillResignActive:(UIApplication *)application {
    MMJF_Log(@"%ld",MMJF_ShareV.badge);
    [JPUSHService setBadge:MMJF_ShareV.badge];
    [application setApplicationIconBadgeNumber:MMJF_ShareV.badge];
}

//  当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
- (void)applicationDidEnterBackground:(UIApplication *)application {
    MMJF_Log(@"%ld",MMJF_ShareV.badge);
    [JPUSHService setBadge:MMJF_ShareV.badge];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:MMJF_ShareV.badge];
}

//当程序从后台将要重新回到前台时候调用，这个刚好跟上面的那个方法相反。
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

}

//程序复原时,应用程序在启动时，在调用了 applicationDidFinishLaunching 方法之后也会调用 applicationDidBecomeActive 方法，所以你要确保你的代码能够分清复原与启动，避免出现逻辑上的bug。
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//当用户按下按钮，或者关机，程序都会被终止。
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//获取唯一id
- (void)getObtainUUID{
    //一般在写程序过程中，应该尽量避免直接访问KeyChain，一般会创建一个NSDictionary来同步对应的数据，所以两者需要做转换。
    NSMutableDictionary *readUserInfoamtion = (NSMutableDictionary *)[DefineKeyChain load:KEY_USERNAME_PASSWORD];
    NSString *ud = [readUserInfoamtion objectForKey:KEY_UUID];
    MMJF_Log(@"deviceid%@",ud);
    MMJF_ShareV.phoneId = ud;
    if (ud.length == 0) {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        MMJF_ShareV.phoneId = uuid;
        self.saveInfomation = [NSMutableDictionary dictionary];
        [self.saveInfomation setObject:uuid forKey:KEY_UUID];
        [DefineKeyChain save:KEY_USERNAME_PASSWORD data:self.saveInfomation];
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        MMJF_Log(@"联网成功");
    }
    else{
        MMJF_Log(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        MMJF_Log(@"授权成功");
    }
    else {
        MMJF_Log(@"onGetPermissionState %d",iError);
    }
}

@end
