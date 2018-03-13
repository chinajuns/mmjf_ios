//
//  ClientMineTextVeiwTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMInputView.h"

@interface ClientMineTextVeiwTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *textView;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *numberWordsLab;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (weak, nonatomic) IBOutlet UIView *dividerView;
@property (weak, nonatomic) IBOutlet UILabel *mandatoryLab;
@property (nonatomic, strong)CMInputView *input;


- (void)setUpText:(NSString *)placeholder maxNumber:(NSInteger)maxNumber color:(UIColor *)backColor fontSize:(CGFloat)fontSize inputText:(NSString *)inputText;
@end
