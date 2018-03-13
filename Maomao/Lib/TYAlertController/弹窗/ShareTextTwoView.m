//
//  ShareView.m
//  TYAlertControllerDemo
//
//  Created by tanyang on 15/10/26.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "ShareTextTwoView.h"
#import "UIView+TYAlertView.h"

@interface ShareTextTwoView()

@end
@implementation ShareTextTwoView

- (void)input{
    self.textF.keyboardType = UIKeyboardTypeDecimalPad;
    RACSignal *signal = [self.textF.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return @(value.length);
    }];
    __weak typeof(self)weakSelf = self;
    [signal subscribeNext:^(id  _Nullable x) {
        if ([x boolValue]) {
            weakSelf.determineBut.userInteractionEnabled = YES;
            [weakSelf.determineBut setBackgroundColor:MMJF_COLOR_Yellow];
        }else {
            weakSelf.determineBut.userInteractionEnabled = NO;
            [weakSelf.determineBut setBackgroundColor:[UIColor colorWithHexString:@"#e6e6e6"]];
        }
    }];
}

- (IBAction)cancelBut:(UIButton *)sender {
    [self hideView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
