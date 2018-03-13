//
//  ThereHintsButTabCell.m
//  Maomao
//
//  Created by 御顺 on 2018/1/31.
//  Copyright © 2018年 御顺. All rights reserved.
//

#import "ThereHintsButTabCell.h"

@implementation ThereHintsButTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //隐藏单行cell分割线
    [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置数据
- (void)setUpData:(NSString *)title number:(NSInteger)number dict:(NSDictionary *)dict count:(NSInteger)count{
    NSArray *keyArray = [dict allValues];
    self.cilckBut.layer.cornerRadius = 5;
    self.cilckBut.layer.masksToBounds = YES;
    self.cilckBut.tag = number;
    [self.cilckBut addTarget:self action:@selector(handleEventBut:) forControlEvents:UIControlEventTouchUpInside];
    [self.cilckBut setTitle:title forState:UIControlStateNormal];
    if (keyArray.count == 0 || keyArray.count < count) {
        self.cilckBut.userInteractionEnabled = NO;
        self.cilckBut.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [self.cilckBut setTitleColor:[UIColor colorWithHexString:@"#b3b3b3"] forState:UIControlStateNormal];
        return;
    }
    for (NSDictionary *dic in keyArray) {
        NSString *str = dic[@"name"];
        if (str.length == 0) {
            self.cilckBut.userInteractionEnabled = NO;
            self.cilckBut.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
            [self.cilckBut setTitleColor:[UIColor colorWithHexString:@"#b3b3b3"] forState:UIControlStateNormal];
            return;
        }else{
            self.cilckBut.userInteractionEnabled = YES;
            self.cilckBut.backgroundColor = [UIColor colorWithHexString:@"#ffd105"];
            [self.cilckBut setTitleColor:[UIColor colorWithHexString:@"#1a1a1a"] forState:UIControlStateNormal];
        }
    }
    
}
//回调代理
- (void)handleEventBut:(UIButton *)sender{
    [_delegate handleEvent:sender];
}

@end
