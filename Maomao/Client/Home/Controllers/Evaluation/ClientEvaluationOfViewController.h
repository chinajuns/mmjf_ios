//
//  ClientEvaluationOfViewController.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientEvaluationOfViewController : UIViewController

/**
 选择的那个评价0全部 1好评 2中评 3差评
 */
@property (nonatomic, assign)NSUInteger number;

@property (nonatomic, copy)NSString *Id;
@end
