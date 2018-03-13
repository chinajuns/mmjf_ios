//
//  ClientMineTextTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineTextTabCell.h"

@implementation ClientMineTextTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSString *string = @"1、请上传本人手持身份证正面头部和上半身照片。\n2、必须看清证件信息，且证件信息不能被遮罩，持证人五官清晰可见。\n3、仅支持.jpg.bmp.png.gif的图片格式，建议图片大小不超过3M。\n4、您提供的照片信息毛毛金服将予以保护，不会用于其他用途。";
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#4d4d4d"]};
    [attrString setAttributes:attributes range:[string rangeOfString:string]];
    
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#33abff"]};
    [attrString setAttributes:attributes1 range:[string rangeOfString:@".jpg.bmp.png.gif"]];
    
    NSDictionary *attributes2 = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#ffd105"]};
    [attrString setAttributes:attributes2 range:[string rangeOfString:@"毛毛金服"]];
    self.textLan.attributedText = attrString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
