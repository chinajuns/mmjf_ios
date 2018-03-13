//
//  ClientInfomationListTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientMessageListModel.h"

@interface ClientInfomationListTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
- (void)setUpdata:(ClientMessageListModel *)managerModel;
@end
