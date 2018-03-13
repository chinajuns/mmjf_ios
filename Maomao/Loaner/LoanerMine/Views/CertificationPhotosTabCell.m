//
//  CertificationPhotosTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "CertificationPhotosTabCell.h"

@implementation CertificationPhotosTabCell

- (void)dealloc{
    [self.clickBut sendCompleted];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.clickBut = [RACSubject subject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)click:(UIButton *)sender {
    [self.clickBut sendNext:[NSString stringWithFormat:@"%ld",sender.tag]];
}

- (void)setUpdata:(NSArray *)array{
    if (array.count == 0) {
        self.image1.hidden = self.image2.hidden = self.image3.hidden = self.image4.hidden = YES;
    }else if (array.count == 1){
        self.image2.hidden = self.image3.hidden = self.image4.hidden = YES;
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:array[0]]] placeholderImage:[UIImage imageNamed:@"gong-pai"]];
    }else if (array.count == 2){
        self.image3.hidden = self.image4.hidden = YES;
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:array[0]]] placeholderImage:[UIImage imageNamed:@"gong-pai"]];
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:array[1]]] placeholderImage:[UIImage imageNamed:@"ming-pian"]];
    }else if(array.count == 3){
        self.image4.hidden = YES;
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:array[0]]] placeholderImage:[UIImage imageNamed:@"gong-pai"]];
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:array[1]]] placeholderImage:[UIImage imageNamed:@"ming-pian"]];
        [self.image3 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:array[2]]] placeholderImage:[UIImage imageNamed:@"he-tong"]];
    }else{
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:array[0]]] placeholderImage:[UIImage imageNamed:@"gong-pai"]];
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:array[1]]] placeholderImage:[UIImage imageNamed:@"ming-pian"]];
        [self.image3 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:array[2]]] placeholderImage:[UIImage imageNamed:@"he-tong"]];
        [self.image4 sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:array[3]]] placeholderImage:[UIImage imageNamed:@"he-ying"]];
    }
}

@end
