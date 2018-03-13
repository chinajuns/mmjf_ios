//
//  RequiredMaterialTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "RequiredMaterialTabCell.h"

@implementation RequiredMaterialTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpData:(NSString *)content{
    NSArray  *array = [content componentsSeparatedByString:@","];
    NSMutableString *mutStr = [NSMutableString string];
    for (int i = 0; i < array.count; i ++) {
        if (array.count == i + 1) {
           [mutStr appendFormat:@"%d.%@;",i + 1,array[i]];
        }else{
           [mutStr appendFormat:@"%d.%@;\n",i + 1,array[i]];
        }
        
    }
    self.contentLab.text = mutStr.copy;
}

- (void)setUpDataArray:(NSArray *)contents{
     NSMutableString *mutStr = [NSMutableString string];
    for (int i = 0; i < contents.count; i ++) {
        if (contents.count == i + 1) {
            [mutStr appendFormat:@"%d.%@;",i + 1,contents[i]];
        }else{
            [mutStr appendFormat:@"%d.%@;\n",i + 1,contents[i]];
        }
        
    }
    self.contentLab.text = mutStr.copy;
}

@end
