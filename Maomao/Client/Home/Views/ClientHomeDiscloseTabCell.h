//
//  ClientHomeDiscloseTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientHomeDiscloseTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cotentLab;
- (void)setUpdata:(NSString *)str;
@end
