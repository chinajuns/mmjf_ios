//
//  XNViewController.h
//  AroundTeacherTwo
//
//  Created by waycubeios02 on 16/11/16.
//  Copyright © 2016年 waycubeios02. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertAction)(UIAlertAction *action);

@interface XNViewController : UIAlertController

@property (nonatomic, copy)NSString *dateString;

/** 初始化方法->双类方法 */
+(instancetype)XNdoubleAlertDefaultMessage:(NSString *)title
                             message:(NSString *)message
                         actionTitle:(NSString *)actionTitle
                         actionStyle:(UIAlertActionStyle)actionStyle
                         alertAction:(AlertAction)alertAction
                    otherActionTitle:(NSString *)otherActionTitle
                    otherActionStyle:(UIAlertActionStyle)otherActionStyle
                    otherAlertAction:(AlertAction)otherAlertAction
                      preferredStyle:(UIAlertControllerStyle)preferredStyle;

/** 初始化方法->单类方法 */
+(instancetype)XNsingleAlertDefaultMessage:(NSString *)title
                             message:(NSString *)message
                         actionTitle:(NSString *)actionTitle
                         actionStyle:(UIAlertActionStyle)actionStyle
                         alertAction:(AlertAction)alertAction
                      preferredStyle:(UIAlertControllerStyle)preferredStyle;

/** 初始化方法->时间选择类方法 */
+(instancetype)XNtimeAlertDefaultMessage:(NSString *)actionTitle
                             actionStyle:(UIAlertActionStyle)actionStyle
                             alertAction:(AlertAction)alertAction
                        otherActionTitle:(NSString *)otherActionTitle
                        otherActionStyle:(UIAlertActionStyle)otherActionStyle
                        otherAlertAction:(AlertAction)otherAlertAction
                              datePicker:(UIDatePicker *)datePicker
                          preferredStyle:(UIAlertControllerStyle)preferredStyle;

/** 初始化方法->table选择类方法 */
+(instancetype)XNtableAlertDefaultMessage:(NSString *)title
                              actionTitle:(NSString *)actionTitle
                              actionStyle:(UIAlertActionStyle)actionStyle
                              alertAction:(AlertAction)alertAction
                                tableView:(UITableView *)tableView
                           preferredStyle:(UIAlertControllerStyle)preferredStyle;
/** 初始化方法->tableTwo选择类方法 */
+(instancetype)XNTwotableAlertDefaultMessage:(NSString *)title
                                 actionTitle:(NSString *)actionTitle
                                 actionStyle:(UIAlertActionStyle)actionStyle
                                 alertAction:(AlertAction)alertAction
                            otherActionTitle:(NSString *)otherActionTitle
                            otherActionStyle:(UIAlertActionStyle)otherActionStyle
                            otherAlertAction:(AlertAction)otherAlertAction
                                   tableView:(UITableView *)tableView
                              preferredStyle:(UIAlertControllerStyle)preferredStyle;
/** 初始化方法->Text输入类方法 */
+(instancetype)XNTextAlertDefaultMessage:(NSString *)actionTitle
                             actionStyle:(UIAlertActionStyle)actionStyle
                             alertAction:(AlertAction)alertAction
                        otherActionTitle:(NSString *)otherActionTitle
                        otherActionStyle:(UIAlertActionStyle)otherActionStyle
                        otherAlertAction:(AlertAction)otherAlertAction
                                textView:(UITextView *)textView
                          preferredStyle:(UIAlertControllerStyle)preferredStyle;


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
                           preferredStyle:(UIAlertControllerStyle)preferredStyle;

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
                             preferredStyle:(UIAlertControllerStyle)preferredStyle;

/** 初始化方法->单按钮Text输入类方法 */
+(instancetype)XNOneTextAlertDefaultMessage:(NSString *)title
                                actionTitle:(NSString *)actionTitle
                                actionStyle:(UIAlertActionStyle)actionStyle
                                alertAction:(AlertAction)alertAction
                                   textView:(UITextView *)textView
                             preferredStyle:(UIAlertControllerStyle)preferredStyle;

-(void)XNshowSingleAlertWithTitle:(NSString *)title
                          message:(NSString *)message
                dismissAfterDelay:(CGFloat)afterDelay
                   preferredStyle:(UIAlertControllerStyle)preferredStyle;

+(instancetype)XNtableAlertDefaultMessage2:(NSString *)title
                               actionTitle:(NSString *)actionTitle
                               actionStyle:(UIAlertActionStyle)actionStyle
                               alertAction:(AlertAction)alertAction
                                 tableView:(UITableView *)tableView
                            preferredStyle:(UIAlertControllerStyle)preferredStyle;

//简单弹窗
+ (instancetype)XNsimple:(NSString *)title
                     alb:(NSString *)alb
                     cam:(NSString *)cam
                  cancel:(NSString *)can
             alertAction:(AlertAction)alertAction
        otherAlertAction:(AlertAction)otherAlertAction
          preferredStyle:(UIAlertControllerStyle)preferredStyle;

/** 展示提醒框 */
-(void)show;
//有时间
//-(void)show:(CGFloat)afterDelay;
@end
