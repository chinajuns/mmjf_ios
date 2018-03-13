//
//  ClientHomeDiscloseTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeDiscloseTabCell.h"

@implementation ClientHomeDiscloseTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)setUpdata:(NSString *)str{
    NSString *string = [NSString stringWithFormat:@"已经收到您的贷款申请稍后将电话联系您\n请注意接听来自%@电话",str];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:MMJF_COLOR_Gray};
    [attrString setAttributes:attributes range:[string rangeOfString:string]];
    
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#33abff"]};
    [attrString setAttributes:attributes1 range:[string rangeOfString:str]];
    self.cotentLab.attributedText = attrString;
}

@end
