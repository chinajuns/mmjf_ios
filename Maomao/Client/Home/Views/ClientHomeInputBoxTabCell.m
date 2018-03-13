//
//  ClientHomeInputBoxTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/11/29.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeInputBoxTabCell.h"

@implementation ClientHomeInputBoxTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setUpData:(NSString *)title content:(NSString *)content index:(NSIndexPath *)index{
    self.titleLabel.text = title;
    self.contentText.tag = index.row + index.section * 10;
    self.contentText.text = content;
}

@end
