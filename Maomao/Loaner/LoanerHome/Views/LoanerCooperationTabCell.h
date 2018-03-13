//
//  LoanerCooperationTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMInputView.h"


@interface LoanerCooperationTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIView *textView;
@property (weak, nonatomic) IBOutlet UILabel *countLab;

@property (nonatomic, strong)CMInputView *input;
- (void)setUpText:(NSString *)str placeholderStr:(NSString *)placeholderStr;
@end
