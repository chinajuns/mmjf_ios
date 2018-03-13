//
//  FailureTakePhotoView.h
//  Maomao
//
//  Created by 御顺 on 2017/9/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^NetBlock)(id object);

@interface FailureTakePhotoView : UIView
/**
 标题
 */
//@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic)UIImageView *titlImage;
/**
 内容
 */
@property (strong, nonatomic) UILabel *cotentLabel;

/**
 加载按钮
 */
@property (strong, nonatomic) UILabel *reloadLabel;

@property (copy, nonatomic)NetBlock click;

- (instancetype)initWithFrame:(CGRect)frame click:(NetBlock)click;


@end
