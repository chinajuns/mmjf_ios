//
//  UITabBar+badge.h
//  Maomao
//
//  Created by 御顺 on 2017/11/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)
- (void)showBadgeOnItmIndex:(int)index;
- (void)hideBadgeOnItemIndex:(int)index;
@end
