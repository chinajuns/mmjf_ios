//
//  LoanerStoreEvaluationTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanerStoreEvaluationTabCell : UITableViewCell

@property (nonatomic, strong)RACSubject *starSubject;
@property (weak, nonatomic) IBOutlet UIView *starView;

- (void)setUpStar:(NSString *)score;
@end
