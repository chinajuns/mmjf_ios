//
//  LoanerStoreDetailHeadTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanerOrderDetailModel.h"

@interface LoanerStoreDetailHeadTabCell : UITableViewCell

- (void)setUpData:(LoanerOrderDetailModel *)model isRefer:(BOOL)isRefer;
@end
