//
//  CardView.m
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import "ErrorMessageView.h"

@interface ErrorMessageView ()
@end

@implementation ErrorMessageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(frame.origin.x, frame.origin.y + 30, frame.size.width, frame.size.height);
        [self addSubview:self.lineLabel];
        [self addSubview:self.contentLabel];
    }
    return self;
}

- (UILabel *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.backgroundColor = MMJF_COLOR_Gray;
    }
    return _lineLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = MMJF_COLOR_RED_MINT;
        _contentLabel.text = @"";
        _contentLabel.font = [UIFont fontWithName:@"PingFang SC" size:11.0f];
    }
    return _contentLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _lineLabel.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    
    _contentLabel.frame = CGRectMake(_lineLabel.x, _lineLabel.y + 1, _lineLabel.width, 20);
}
@end
