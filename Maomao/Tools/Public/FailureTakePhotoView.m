//
//  FailureTakePhotoView.m
//  Maomao
//
//  Created by 御顺 on 2017/9/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "FailureTakePhotoView.h"

@implementation FailureTakePhotoView

- (instancetype)initWithFrame:(CGRect)frame click:(NetBlock)click;{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titlImage];
        [self addSubview:self.cotentLabel];
        [self addSubview:self.reloadLabel];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        _click = ^(NSString* str){
            click(str);
        };
    }
    return self;
}

//- (UILabel *)titleLabel{
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc]init];
//        NSString *text = @"温馨提示";
//        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
//                                     NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//        _titleLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _titleLabel;
//}

- (UIImageView *)titlImage{
    if (!_titlImage) {
        _titlImage = [[UIImageView alloc]init];
        _titlImage.image = [UIImage imageNamed:@"mei-you-shai-xuan-jie-guo"];
    }
    return _titlImage;
}


- (UILabel *)cotentLabel{
    if (!_cotentLabel) {
        _cotentLabel = [[UILabel alloc]init];
        NSString *text = @"";
        text = MMJF_ShareV.errorStatus;
        
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSParagraphStyleAttributeName: paragraph};
        _cotentLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
    return _cotentLabel;
}

- (UILabel *)reloadLabel{
    if (!_reloadLabel) {
        _reloadLabel = [[UILabel alloc]init];
        NSString *text = @"重新加载";
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],NSForegroundColorAttributeName: [UIColor colorWithRed:0.992 green:0.835 blue:0.160 alpha:1]};
        _reloadLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        _reloadLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _reloadLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _titleLabel.frame = CGRectMake(0, 0, MMJF_WIDTH, 30);
//    _titleLabel.center = CGPointMake(MMJF_WIDTH / 2, MMJF_HEIGHT / 2 - 90);
    
    _titlImage.layer.cornerRadius = 30;
    _titlImage.layer.masksToBounds = YES;
    _titlImage.frame = CGRectMake(0, 0, 120, 120);
//    _titlImage.center = CGPointMake(MMJF_WIDTH / 2, MMJF_HEIGHT / 2 - 100);
//
//    _cotentLabel.frame = CGRectMake(0, MMJF_HEIGHT/ 2 - 40, MMJF_WIDTH, 30);
//
//    _reloadLabel.frame = CGRectMake(0, 0, MMJF_WIDTH, 30);
//    _reloadLabel.center = CGPointMake(MMJF_WIDTH / 2, MMJF_HEIGHT / 2);
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture{
    self.click(@"1");
}

@end
