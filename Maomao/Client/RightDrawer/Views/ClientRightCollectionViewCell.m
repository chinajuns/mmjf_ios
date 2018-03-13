//
//  ClientRightCollectionViewCell.m
//  Maomao
//
//  Created by 御顺 on 2017/11/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientRightCollectionViewCell.h"

@implementation ClientRightCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.rightBut.layer.cornerRadius = 5;
    
    self.rightBut.layer.borderWidth = 0.5;
    self.rightBut.layer.backgroundColor = [[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f] CGColor];
}

@end
