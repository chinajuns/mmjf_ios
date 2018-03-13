//
//  ClientMineImpressionTabCell.h
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientMineImpressionTabCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *tagView;

@property (nonatomic, strong)RACSubject *arraySubject;

@property (nonatomic, strong)RACSubject *removeSubject;

- (void)setUptagListView:(NSArray *)tags selecteds:(NSArray *)selecteds;
@end
