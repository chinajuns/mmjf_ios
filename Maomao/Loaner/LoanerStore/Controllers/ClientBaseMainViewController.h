//
//  ClientBaseMainViewController.h
//  Maomao
//
//  Created by 御顺 on 2017/11/20.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMJFBaseViewController.h"

@interface ClientBaseMainViewController : MMJFBaseViewController
@property (nonatomic, strong)NSString *is_auth;
/**
 底部跳转

 @param number 页面id
 */
- (void)jump:(NSInteger)number;
@end
