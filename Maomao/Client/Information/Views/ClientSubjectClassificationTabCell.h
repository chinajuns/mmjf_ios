//
//  ClientSubjectClassificationTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientSubjectClassificationTabCell : UITableViewCell
/**
 金融政策
 */
@property (weak, nonatomic) IBOutlet UIButton *financialBtu;

/**
 贷款利率
 */
@property (weak, nonatomic) IBOutlet UIButton *interestBut;
/**
 资料简介
 */
@property (weak, nonatomic) IBOutlet UIButton *dataBut;
@end
