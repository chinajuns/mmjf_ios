//
//  UserRegisteredViewController.h
//  Maomao
//
//  Created by 御顺 on 2017/11/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogRegisterBaseViewController.h"

@interface ClientRegisteredViewController : LogRegisterBaseViewController

/**
 是c端注册yes B端no
 */
@property (nonatomic, assign)BOOL isC;
@end
