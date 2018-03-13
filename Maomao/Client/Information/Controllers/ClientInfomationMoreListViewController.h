//
//  ClientInfomationMoreListViewController.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientInfomationMoreListViewController : UIViewController

@property (nonatomic, copy)NSString *Id;
@property (nonatomic, copy)NSString *titleStr;
/**
 B端YES C端NO
 */
@property (nonatomic, assign)BOOL isB;
@end
