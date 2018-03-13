//
//  SharePodStyleViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharePodStyleViewModel : MMJFBaseViewModel

@property (nonatomic, strong)RACSubject *clickSubject;

//设置双按钮提示
- (TYAlertController *)setUpShareTwo:(NSString *)title determineStr:(NSString *)determineStr cancelStr:(NSString *)cancelStr;

/**
 图片提示

 @param imgStr 图片url
 */
- (TYAlertController *)setUpShareImgView:(NSString *)imgStr;
/**
 带标题的双按钮提示

 @param title 提示
 @return 控件
 */
- (TYAlertController *)setUpShareTitleTwoView:(NSString *)title soce:(NSString *)soceStr unit:(NSString *)unitStr;

/**
 带x和图片的提示

 @param title 按钮文字
 @return 控件
 */
- (TYAlertController *)setUpShareResetView:(NSString *)title;

/**
 带x取消的提示

 @param title 标题
 */
- (TYAlertController *)setUpShareCancelView:(NSString *)title isC:(BOOL)isC;

/**
 带带图片单按钮的提示

 @param title 内容标题
 @param imgStr 图片
 @param butTitle 按钮标题
 */
- (TYAlertController *)setUpSharePictureSingleView:(NSString *)title img:(NSString *)imgStr butTitle:(NSString *)butTitle;

/**
 设置双按钮text提示

 @param title 标题
 @param determineStr 提交
 @param cancelStr 取消
 @param unitStr 单位
 */
- (TYAlertController *)setUpShareTextTwo:(NSString *)title determineStr:(NSString *)determineStr cancelStr:(NSString *)cancelStr unit:(NSString *)unitStr;

/**
 设置双按钮tab提示

 @param title 标题
 @param determineStr 提交
 @param cancelStr 取消
 @param whyArray 原因数据
 */
- (TYAlertController *)setUpShareTabTwo:(NSString *)title determineStr:(NSString *)determineStr cancelStr:(NSString *)cancelStr whyArray:(NSArray *)whyArray;

/**
 带图片双按钮的提示

 @param title 标题
 @param imgStr 图片
 @param butTitle 按钮标题
 @param promptStr1 提示左
 @param promptStr2 提示右
 */
- (TYAlertController *)setUpSharePictureTwoView:(NSString *)title img:(NSString *)imgStr butTitle:(NSString *)butTitle prompt1:(NSString *)promptStr1 prompt2:(NSString *)promptStr2;
@end
