//
//  CardView.h
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpWindowView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;

/**
 选择
 */
@property (weak, nonatomic) IBOutlet UIButton *determineBut;
/**
 取消
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBut;
@end
