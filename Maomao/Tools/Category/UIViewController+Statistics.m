//
//  UIViewController+Statistics.m
//  Maomao
//
//  Created by 御顺 on 2017/10/19.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "UIViewController+Statistics.h"
//#import <objc/runtime.h>

@implementation UIViewController (Statistics)

+ (void)load {
    //原本的viewWillApper方法
//    Method viewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
//
//    //需要替换成能够输入日志的viewWillAppear
//    Method logViewWillAppear = class_getInstanceMethod(self, @selector(logViewWillAppear:));
//
//
//    //原本的viewWillDisappear方法
//    Method viewWillDisappear = class_getInstanceMethod(self, @selector(viewWillDisappear:));
//    //需要替换成能够输入日志的viewWillDisappear
//    Method logviewWillDisappear = class_getInstanceMethod(self, @selector(logviewWillDisappear:));
//
//    //两方法进行交换
//    method_exchangeImplementations(viewWillAppear, logViewWillAppear);
//    method_exchangeImplementations(viewWillDisappear, logviewWillDisappear);
//
}

-(void)logViewWillAppear:(BOOL)animated
{
    [self logViewWillAppear:animated];
//    [MobClick beginLogPageView:self.title];
    
}

-(void)logviewWillDisappear:(BOOL)animated
{
    [self logviewWillDisappear:animated];
//    [MobClick endLogPageView:self.title];
}
@end
