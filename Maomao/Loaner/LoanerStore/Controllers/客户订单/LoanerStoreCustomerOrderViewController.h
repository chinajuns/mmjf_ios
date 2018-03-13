//
//  LoanerStoreCustomerOrderViewController.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanerStoreCustomerOrderViewController : UIViewController

/**
 订单来源,customer=>店铺客户申请的订单 YES,junk=>个人中心抢的订单NO
 */
@property (nonatomic, assign)BOOL isRefer;
@end
