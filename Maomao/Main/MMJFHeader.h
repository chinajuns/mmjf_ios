//
//  MMJFHeader.h
//  Maomao
//
//  Created by 御顺 on 2017/11/16.
//  Copyright © 2017年 御顺. All rights reserved.
//

//#ifdef __OBJC__

#import <YYModel/YYModel.h>
#import <ReactiveObjC.h>
#import <MJRefresh.h>
#import <ViewDeck/ViewDeck.h>

#import "UIViewController+Navigation.h"
#import "NSData+AES.h"
#import "NSString+AES.h"
#import "UIView+Frame.h"
#import "NSString+Category.h"
#import "MBProgressHUD+MJ.h"
#import <UIImageView+WebCache.h>
#import "UIColor+BGHexColor.h"
#import "UIButton+NYImageLocation.h"
#import "UIButton+Badge.h"
#import "UIBarButtonItem+Badge.h"
#import "CALayer+shadow.h"
#import "NSObject+PublicMethods.h"
#import "UIView+TYAlertView.h"

#import "PPNetworkHelper.h"
#import "CQPlaceholderView.h"
#import "ShareSingle.h"
#import "CManager.h"
#import "MMJFNetworkModel.h"
#import "MMJFBaseViewController.h"
#import "MMJFBaseViewModel.h"
#import "XNViewController.h"
#import "SolidRoundView.h"
#import "ClientPublicBaseViewModel.h"
#import "ClientUserModel.h"
#import "SharePodStyleViewModel.h"
#import "MMJFInterfacedConst.h"

#define MMJF_FRAME ([UIScreen mainScreen].applicationFrame)
#define MMJF_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define MMJF_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MMJF_DEFAULTS [NSUserDefaults standardUserDefaults]

#define MMJF_DocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]

#define MMJF_UserInfoPath [MMJF_DocumentPath stringByAppendingPathComponent:@"userInfo.archiver"]

#define MMJF_NetworkShare [MMJFNetworkModel shareInstance]//单例接口
#define MMJF_ShareV [ShareSingle shareInstance]//单例值
#define MMJF_COLOR_Yellow ([UIColor colorWithRed:255.0f/255.0f green:209.0f/255.0f blue:5.0f/255.0f alpha:1.0f])//主题黄
#define MMJF_COLOR_RED_MINT ([UIColor colorWithRed:255.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f])//红色
#define MMJF_COLOR_Gray ([UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:224.0f/255.0f alpha:1.0f])//灰色
#define MMJF_COLOR_GREEN_MINT ([UIColor colorWithRed:0.345 green:0.659 blue:0.373 alpha:1.000])
#define MMJF_COLOR_Blue_MINT ([UIColor colorWithRed:0.482 green:0.686 blue:0.863 alpha:1.000])
#define MMJF_COLOR_Black ([UIColor colorWithRed:26.0f/255.0f green:26.0f/255.0f blue:26.0f/255.0f alpha:1.0f])
#define MMJF_COLOR_MINT_Donot ([UIColor colorWithRed:0.870 green:0.870 blue:0.870 alpha:1]) 

#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS11Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.f)

#define USHARE_APPKEY @"59b8fc8c8630f52d320000bd"
#define MAP_APPKEY @"qXYsIfGeqsIaVdiuWmNkIEWut4yMolly"
#define QQ_APPKET @"1106413424"
#define PUSH_APPKEY @"59b8fc8c8630f52d320000bd"
#define WB_APPKEY @"1025369079"
#define WB_appSecret @"564180e943875b96f8a173f55e92a0e1"
#define WX_APPID @"wx03ba1b2dd8eab537"
#define WX_appSecret @"02fe73753d1e1d8ee3cd2f33e5022270"

//#endif

#ifdef DEBUG // 调试
//内网
//#define MMJF_tokenUrl @"http://api.com/"
//#define MMJF_H5Url @"http://h5.cn/index.html"

//外网
#define MMJF_tokenUrl @"http://api.kuanjiedai.com/"
#define MMJF_H5Url @"http://h5.kuanjiedai.com/"

#define MMJF_Log(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String])

#else // 发布
//外网
#define MMJF_tokenUrl @"http://api.kuanjiedai.com/"
#define MMJF_H5Url @"http://h5.kuanjiedai.com/"
#define MMJF_Log(...)

#endif
