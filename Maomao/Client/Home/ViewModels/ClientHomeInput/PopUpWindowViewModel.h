//
//  PopUpWindowViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/11/29.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopUpWindowView.h"

@interface PopUpWindowViewModel : NSObject
@property (nonatomic ,strong) UIView *BGView; //遮罩
@property (nonatomic, strong)PopUpWindowView *popUpWindowView;
/**
 选中的值
 */
@property (nonatomic, copy)NSDictionary *selectedDic;
/**
 加载弹窗
 */
- (void)appearClick:(CGFloat)coefficient control:(NSInteger)control number:(NSInteger)number dataArray:(NSArray *)dataArray titleStr:(NSString *)titleStr;

/**
 移除弹窗
 */
- (void)exitClick;

/**
 返回日期 年龄

 @return 字典
 */
- (NSDictionary *)ageWithDateOfBirth;
@end
