//
//  ClientMineCertificationTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineCertificationTabCell.h"

@implementation ClientMineCertificationTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpimg:(NSString *)url number:(NSInteger)number img:(UIImage *)img{
    if (number == 0) {//正面
        self.titleLab.text = @"手持身份正面证照";
        if (url.length == 0) {
            if ([img isKindOfClass:[UIImage class]]) {
                self.img.image = img;
            }
        }else{
           [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:url]] placeholderImage:[UIImage imageNamed:@"shen-fen-zheng-zheng-mian"]];
        }
        
    }else{
        self.titleLab.text = @"手持身份背面证照";
        if (url.length == 0) {
            if ([img isKindOfClass:[UIImage class]]) {
                self.img.image = img;
            }
        }else{
            [self.img sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:url]] placeholderImage:[UIImage imageNamed:@"shen-fen-zheng-fan-mian"]];
        }
        
    }
    
}

@end
