//
//  ClientMineHeadTablCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineHeadTablCell.h"
#import "ClientUserModel.h"

@implementation ClientMineHeadTablCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:user.header_img]] placeholderImage:[UIImage imageNamed:@"denglu-mei-you-tou-xiang"]];
    self.headImage.layer.cornerRadius = 40;
    self.headImage.layer.masksToBounds = YES;
    
    if (user) {
        self.name.text = user.username;
    }else{
        self.name.text = @"请登录";
    }
    if (user.mobile.length != 0) {
        self.phoneLab.text = [NSString getSecrectStringWithPhoneNumber:user.mobile];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
