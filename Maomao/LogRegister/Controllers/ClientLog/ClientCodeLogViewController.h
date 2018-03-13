//
//  ClientCodeLogViewController.h
//  Maomao
//
//  Created by 御顺 on 2017/11/23.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogRegisterBaseViewController.h"

@interface ClientCodeLogViewController : LogRegisterBaseViewController

/**
 判断是B端NO  C端YES
 */
@property (nonatomic, assign)BOOL isC;
@end
