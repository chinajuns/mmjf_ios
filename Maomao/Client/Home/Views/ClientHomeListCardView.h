//
//  CardView.h
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientManagerModel.h"

@interface ClientHomeListCardView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cardClick;

@property (weak, nonatomic) IBOutlet UIButton *selectIdBut;

@property (nonatomic, strong)ClientManagerModel *clientManagerModel;

- (void)setUpdata:(NSDictionary *)dic;
@end
