//
//  AppDelegate.h
//  Maomao
//
//  Created by 御顺 on 2017/11/15.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
static NSString *appKey = @"cf0106bb3ab4b1de406e9fb5";
static NSString *channel = @"App Store";
static BOOL isProduction = FALSE;//FALSE开发状态 true发布状态

@interface MMJFAppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

