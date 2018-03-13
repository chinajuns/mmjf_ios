//
//  ButtonCell.m
//  Maomao
//
//  Created by 御顺 on 2017/9/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell

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
    self.operationBut.layer.cornerRadius = 5;
    self.operationBut.layer.masksToBounds = YES;
    self.operationBut.tag = number;
    [self.operationBut addTarget:self action:@selector(handleEventBut:) forControlEvents:UIControlEventTouchUpInside];
    [self.operationBut setTitle:title forState:UIControlStateNormal];
    if (keyArray.count == 0 || keyArray.count < count) {
        self.operationBut.userInteractionEnabled = NO;
        self.operationBut.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        [self.operationBut setTitleColor:[UIColor colorWithHexString:@"#b3b3b3"] forState:UIControlStateNormal];
        return;
    }
    for (NSDictionary *dic in keyArray) {
        NSString *str = dic[@"name"];
        if (str.length == 0) {
            self.operationBut.userInteractionEnabled = NO;
            self.operationBut.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
            [self.operationBut setTitleColor:[UIColor colorWithHexString:@"#b3b3b3"] forState:UIControlStateNormal];
            return;
        }else{
            self.operationBut.userInteractionEnabled = YES;
            self.operationBut.backgroundColor = [UIColor colorWithHexString:@"#ffd105"];
            [self.operationBut setTitleColor:[UIColor colorWithHexString:@"#1a1a1a"] forState:UIControlStateNormal];
        }
    }
    
}
//回调代理
- (void)handleEventBut:(UIButton *)sender{
    [_delegate handleEvent:sender];
}

@end
