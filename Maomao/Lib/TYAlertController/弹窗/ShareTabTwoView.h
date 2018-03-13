//
//  ShareView.h
//  TYAlertControllerDemo
//
//  Created by tanyang on 15/10/26.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareTabTwoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *cancelBut;
@property (weak, nonatomic) IBOutlet UIButton *determineBut;

@property (weak, nonatomic) IBOutlet UITableView *listTab;
/**
 选择文本
 */
@property (nonatomic, copy)NSString *chooseStr;
//刷新
- (void)refresh:(NSArray *)array;
- (void)setUpUI;
@end
