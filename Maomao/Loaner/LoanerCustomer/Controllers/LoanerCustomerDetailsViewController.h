//
//  LoanerCustomerDetailsViewController.h
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanerCustomerDetailsViewController : UIViewController

/**
 抢单id
 */
@property (nonatomic, copy)NSString *ID;

/**
 已抢单YES
 */
@property (nonatomic, assign)BOOL isSingle;
@end
