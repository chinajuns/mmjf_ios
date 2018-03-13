//
//  MMJFBaseViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/11/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMJFBaseViewModel : NSObject

/**
 绑定
 
 @param view 绑定view
 */
- (void)bindViewToViewModel:(UIView *)view;

- (NSString *)convertToJsonData:(NSDictionary *)dict;
@end
