//
//  UIViewController+Navigation.m
//  Maomao
//
//  Created by 御顺 on 2017/10/31.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)
//标题
- (void)titleView:(NSString *)title{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    titleLabel.textColor = [UIColor colorWithHexString:@"#282828"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    self.navigationItem.titleView = titleLabel;
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    
}

- (void)itemWithImage:(NSString *)image highImage:(NSString *)highImage rightButton:(UIButton *)rightButton
{
    [rightButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
//    [rightButton sizeToFit];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 44)];
    [view1 addSubview:rightButton];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:view1];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setRightCount:(NSString *)count rightButton:(UIButton *)rightButton{
//    rightButton.badgeValue = [NSString stringWithFormat:@"%@",count];
//    rightButton.badgeBGColor = MMJF_COLOR_RED_MINT;
}



@end
