//
//  XNViewController.m
//  AroundTeacherTwo
//
//  Created by waycubeios02 on 16/11/16.
//  Copyright © 2016年 waycubeios02. All rights reserved.
//

#import "XNViewController.h"
#define AlertWIDTH 257
#define XN_WIDTH ([UIScreen mainScreen].bounds.size.width)
@interface XNViewController ()

@end

@implementation XNViewController
/** 初始化方法->双类方法 */
+(instancetype)XNdoubleAlertDefaultMessage:(NSString *)title
                                   message:(NSString *)message
                               actionTitle:(NSString *)actionTitle
                               actionStyle:(UIAlertActionStyle)actionStyle
                               alertAction:(AlertAction)alertAction
                          otherActionTitle:(NSString *)otherActionTitle
                          otherActionStyle:(UIAlertActionStyle)otherActionStyle
                          otherAlertAction:(AlertAction)otherAlertAction
                            preferredStyle:(UIAlertControllerStyle)preferredStyle{
    XNViewController *xnAlertController = [XNViewController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    //默认UIAlertAction
    UIAlertAction *defaultAlertAction = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
        alertAction(action);
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:otherActionTitle style:otherActionStyle handler:^(UIAlertAction * _Nonnull action) {
        otherAlertAction(action);
    }];
    
    [xnAlertController addAction:defaultAlertAction];
    [xnAlertController addAction:action1];
    return xnAlertController;
}

/** 初始化方法->单类方法 */
+(instancetype)XNsingleAlertDefaultMessage:(NSString *)title
                                   message:(NSString *)message
                               actionTitle:(NSString *)actionTitle
                               actionStyle:(UIAlertActionStyle)actionStyle
                               alertAction:(AlertAction)alertAction
                            preferredStyle:(UIAlertControllerStyle)preferredStyle{
    XNViewController *xnAlertController = [XNViewController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    //默认UIAlertAction
    UIAlertAction *defaultAlertAction = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
        alertAction(action);
    }];
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1a1a1a"] range:NSMakeRange(0, title.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang SC" size:18] range:NSMakeRange(0, title.length)];
    [xnAlertController setValue:alertControllerStr forKey:@"attributedTitle"];
    
    [defaultAlertAction setValue:MMJF_COLOR_Yellow forKey:@"titleTextColor"];
    
    [xnAlertController addAction:defaultAlertAction];
    return xnAlertController;
}

//只有提示框--中间
- (void)XNshowSingleAlertWithTitle:(NSString *)title
                          message:(NSString *)message
                dismissAfterDelay:(CGFloat)afterDelay
                   preferredStyle:(UIAlertControllerStyle)preferredStyle{
    XNViewController *xnAlertController = [XNViewController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    [[xnAlertController getCurrentVC] presentViewController:xnAlertController animated:YES completion:^{
        [self performSelector:@selector(dismiss:) withObject:xnAlertController afterDelay:afterDelay];
    }];
}

/** 初始化方法->时间选择类方法 */
+(instancetype)XNtimeAlertDefaultMessage:(NSString *)actionTitle
                            actionStyle:(UIAlertActionStyle)actionStyle
                            alertAction:(AlertAction)alertAction
                        otherActionTitle:(NSString *)otherActionTitle
                        otherActionStyle:(UIAlertActionStyle)otherActionStyle
                        otherAlertAction:(AlertAction)otherAlertAction
                              datePicker:(UIDatePicker *)datePicker
                          preferredStyle:(UIAlertControllerStyle)preferredStyle{
    XNViewController *xnAlertController = [XNViewController alertControllerWithTitle:@"\n\n\n\n\n\n\n" message:nil preferredStyle:preferredStyle];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    datePicker.locale = locale;
    datePicker.frame = CGRectMake(0, 0, AlertWIDTH + 18, 200);
    [xnAlertController.view addSubview:datePicker];
    //默认UIAlertAction
    UIAlertAction *defaultAlertAction = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
        alertAction(action);
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:otherActionTitle style:otherActionStyle handler:^(UIAlertAction * _Nonnull action) {
        otherAlertAction(action);
    }];
    
    [xnAlertController addAction:defaultAlertAction];
    [xnAlertController addAction:action1];
    return xnAlertController;
}


/** 初始化方法->单按钮文本选择类方法 */
+(instancetype)XNOneTextAlertDefaultMessage:(NSString *)title
                                actionTitle:(NSString *)actionTitle
                             actionStyle:(UIAlertActionStyle)actionStyle
                             alertAction:(AlertAction)alertAction
                                textView:(UITextView *)textView
                          preferredStyle:(UIAlertControllerStyle)preferredStyle{
    XNViewController *xnAlertController = [XNViewController alertControllerWithTitle:title message:@"\n\n\n\n\n\n" preferredStyle:preferredStyle];
    textView.frame = CGRectMake(8, 35, XN_WIDTH - 38, 110);
    textView.font = [UIFont systemFontOfSize:14];
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    textView.layer.borderWidth = 0.5;
    textView.editable = NO;
    textView.layer.borderColor = [UIColor lightTextColor].CGColor;
    [xnAlertController.view addSubview:textView];
    //默认UIAlertAction
    UIAlertAction *defaultAlertAction = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
        alertAction(action);
    }];
    [xnAlertController addAction:defaultAlertAction];
    return xnAlertController;
}


/** 初始化方法->table选择类方法 */
+(instancetype)XNtableAlertDefaultMessage:(NSString *)title
                              actionTitle:(NSString *)actionTitle
                             actionStyle:(UIAlertActionStyle)actionStyle
                             alertAction:(AlertAction)alertAction
                              tableView:(UITableView *)tableView
                          preferredStyle:(UIAlertControllerStyle)preferredStyle{
    XNViewController *xnAlertController = [XNViewController alertControllerWithTitle:title message:@"\n\n\n\n\n\n\n" preferredStyle:preferredStyle];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.layer.cornerRadius = 5;
    tableView.layer.masksToBounds = YES;
    tableView.tag = 100;
    [xnAlertController.view addSubview:tableView];
    //默认UIAlertAction
    UIAlertAction *defaultAlertAction = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
        alertAction(action);
    }];
    [xnAlertController addAction:defaultAlertAction];
    return xnAlertController;
}

+(instancetype)XNtableAlertDefaultMessage2:(NSString *)title
                              actionTitle:(NSString *)actionTitle
                              actionStyle:(UIAlertActionStyle)actionStyle
                              alertAction:(AlertAction)alertAction
                                tableView:(UITableView *)tableView
                           preferredStyle:(UIAlertControllerStyle)preferredStyle{
    XNViewController *xnAlertController = [XNViewController alertControllerWithTitle:title message:@"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:preferredStyle];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.layer.cornerRadius = 5;
    tableView.layer.masksToBounds = YES;
    tableView.tag = 100;
    [xnAlertController.view addSubview:tableView];
    //默认UIAlertAction
    UIAlertAction *defaultAlertAction = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
        alertAction(action);
    }];
    [xnAlertController addAction:defaultAlertAction];
    return xnAlertController;
}
/** 初始化方法->table选择类方法 */
+(instancetype)XNTwotableAlertShowMessage:(NSString *)title
                                 actionTitle:(NSString *)actionTitle
                                 actionStyle:(UIAlertActionStyle)actionStyle
                                 alertAction:(AlertAction)alertAction
                            otherActionTitle:(NSString *)otherActionTitle
                            otherActionStyle:(UIAlertActionStyle)otherActionStyle
                            otherAlertAction:(AlertAction)otherAlertAction1
                         otherActionTitle1:(NSString *)otherActionTitle1
                         otherActionStyle1:(UIAlertActionStyle)otherActionStyle1
                         otherAlertAction1:(AlertAction)otherAlertAction
                                   tableView:(UITableView *)tableView
                              preferredStyle:(UIAlertControllerStyle)preferredStyle{
    XNViewController *xnAlertController = [XNViewController alertControllerWithTitle:title message:@"\n\n\n\n\n\n\n" preferredStyle:preferredStyle];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.layer.cornerRadius = 5;
    tableView.layer.masksToBounds = YES;
    tableView.tag = 100;
    tableView.frame = CGRectMake(5, 38, AlertWIDTH, 140);
    [xnAlertController.view addSubview:tableView];
    //默认UIAlertAction
    UIAlertAction *defaultAlertAction = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
        alertAction(action);
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:otherActionTitle style:otherActionStyle handler:^(UIAlertAction * _Nonnull action) {
        otherAlertAction1(action);
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:otherActionTitle1 style:otherActionStyle1 handler:^(UIAlertAction * _Nonnull action) {
        otherAlertAction(action);
    }];
    [xnAlertController addAction:defaultAlertAction];
    [xnAlertController addAction:action1];
    [xnAlertController addAction:action2];
    return xnAlertController;
}

/** 初始化方法->table选择类方法 */
+(instancetype)XNThreetableAlertShowMessage:(NSString *)title
                              actionTitle:(NSString *)actionTitle
                              actionStyle:(UIAlertActionStyle)actionStyle
                              alertAction:(AlertAction)alertAction
                         otherActionTitle:(NSString *)otherActionTitle
                         otherActionStyle:(UIAlertActionStyle)otherActionStyle
                         otherAlertAction:(AlertAction)otherAlertAction1
                        otherActionTitle1:(NSString *)otherActionTitle1
                        otherActionStyle1:(UIAlertActionStyle)otherActionStyle1
                        otherAlertAction1:(AlertAction)otherAlertAction
                          otherActionTitle2:(NSString *)otherActionTitle2
                          otherActionStyle2:(UIAlertActionStyle)otherActionStyle2
                          otherAlertAction2:(AlertAction)otherAlertAction2
                                tableView:(UITableView *)tableView
                           preferredStyle:(UIAlertControllerStyle)preferredStyle{
    XNViewController *xnAlertController = [XNViewController alertControllerWithTitle:title message:@"\n\n\n\n\n\n\n" preferredStyle:preferredStyle];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.layer.cornerRadius = 5;
    tableView.layer.masksToBounds = YES;
    tableView.tag = 100;
    tableView.frame = CGRectMake(5, 38, AlertWIDTH, 140);
    [xnAlertController.view addSubview:tableView];
    //默认UIAlertAction
    UIAlertAction *defaultAlertAction = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
        alertAction(action);
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:otherActionTitle style:otherActionStyle handler:^(UIAlertAction * _Nonnull action) {
        otherAlertAction1(action);
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:otherActionTitle1 style:otherActionStyle1 handler:^(UIAlertAction * _Nonnull action) {
        otherAlertAction(action);
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:otherActionTitle2 style:otherActionStyle2 handler:^(UIAlertAction * _Nonnull action) {
        otherAlertAction2(action);
    }];
    [xnAlertController addAction:defaultAlertAction];
    [xnAlertController addAction:action1];
    [xnAlertController addAction:action2];
    [xnAlertController addAction:action3];
    return xnAlertController;
}

/** 初始化方法->table选择类方法 */
+(instancetype)XNTwotableAlertDefaultMessage:(NSString *)title
                              actionTitle:(NSString *)actionTitle
                              actionStyle:(UIAlertActionStyle)actionStyle
                              alertAction:(AlertAction)alertAction
                            otherActionTitle:(NSString *)otherActionTitle
                            otherActionStyle:(UIAlertActionStyle)otherActionStyle
                            otherAlertAction:(AlertAction)otherAlertAction
                                tableView:(UITableView *)tableView
                           preferredStyle:(UIAlertControllerStyle)preferredStyle{
    XNViewController *xnAlertController = [XNViewController alertControllerWithTitle:title message:@"\n\n\n\n\n\n\n" preferredStyle:preferredStyle];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.layer.cornerRadius = 5;
    tableView.layer.masksToBounds = YES;
    tableView.tag = 100;
    tableView.frame = CGRectMake(5, 38, AlertWIDTH, 140);
    [xnAlertController.view addSubview:tableView];
    //默认UIAlertAction
    UIAlertAction *defaultAlertAction = [UIAlertAction actionWithTitle:actionTitle style:actionStyle handler:^(UIAlertAction * _Nonnull action) {
        alertAction(action);
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:otherActionTitle style:otherActionStyle handler:^(UIAlertAction * _Nonnull action) {
        otherAlertAction(action);
    }];
    [xnAlertController addAction:defaultAlertAction];
    [xnAlertController addAction:action1];
    return xnAlertController;
}

//简单弹窗
+ (instancetype)XNsimple:(NSString *)title
                     alb:(NSString *)alb
                     cam:(NSString *)cam
                  cancel:(NSString *)can
             alertAction:(AlertAction)alertAction
        otherAlertAction:(AlertAction)otherAlertAction
          preferredStyle:(UIAlertControllerStyle)preferredStyle{
    XNViewController * alert = [XNViewController alertControllerWithTitle:title message:nil preferredStyle:preferredStyle];
    UIAlertAction * album = [UIAlertAction actionWithTitle:alb style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        alertAction(action);
    }];
    UIAlertAction * camera = [UIAlertAction actionWithTitle:cam style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        otherAlertAction(action);
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:can style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:album];
    [alert addAction:camera];
    [alert addAction:cancel];
    return alert;
}

/** 展示提醒框 */
-(void)show{
    [[self getCurrentVC] presentViewController:self animated:YES completion:nil];
}

- (void)dismiss:(UIAlertController *)aler {
    [aler dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 私有方法->
//获取当前屏幕显示的ViewController
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tempWindow in windows)
        {
            if (tempWindow.windowLevel == UIWindowLevelNormal)
            {
                window = tempWindow;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    return result;
}

@end
