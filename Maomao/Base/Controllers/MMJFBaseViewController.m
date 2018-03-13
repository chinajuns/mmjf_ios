//
//  BaseViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/16.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewController.h"


@interface MMJFBaseViewController ()

@end

@implementation MMJFBaseViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //页面消失移除还在加载的网络请求
//    [PPNetworkHelper cancelAllRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
}

- (UIImage *) getImageFromURL:(NSString *)fileURL
{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

@end
