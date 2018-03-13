//
//  ApplicationRequirementsTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationRequirementsTabCell : UITableViewCell

@property (nonatomic, copy)NSString *key1;
@property (nonatomic, copy)NSString *key2;

- (void)setUpdata:(NSArray *)array;

- (void)setUpdataMore:(NSArray *)array;
@end
