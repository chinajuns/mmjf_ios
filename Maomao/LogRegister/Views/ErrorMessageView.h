//
//  CardView.h
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorMessageView : UIView
@property (strong, nonatomic) UILabel *lineLabel;
@property (strong, nonatomic) UILabel *contentLabel;

- (instancetype)initWithFrame:(CGRect)frame;
@end
