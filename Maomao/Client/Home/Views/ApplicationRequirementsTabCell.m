//
//  ApplicationRequirementsTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ApplicationRequirementsTabCell.h"
@interface ApplicationRequirementsTabCell()
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *value1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1;

@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *value2;

@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *value3;

@property (weak, nonatomic) IBOutlet UILabel *title4;
@property (weak, nonatomic) IBOutlet UILabel *value4;

@property (weak, nonatomic) IBOutlet UILabel *title5;
@property (weak, nonatomic) IBOutlet UILabel *value5;
@end
@implementation ApplicationRequirementsTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUpdata:(NSArray *)array{
    CGFloat with = 0.0;
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dic = array[i];
        //计算文本宽度
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont fontWithName:@"PingFang SC" size:12]};
        CGSize size=[[NSString stringWithFormat:@"%@:",dic[self.key1]] sizeWithAttributes:attrs];
        if (size.width > with) {
            with = size.width + 3;
        }
        self.line1.constant = with;
        switch (i) {
            case 0:
                self.title1.text = [NSString stringWithFormat:@"%@:",dic[self.key1]];
                self.value1.text = [NSString stringWithFormat:@" %@",dic[self.key2]];
                break;
            case 1:
                self.title2.text = [NSString stringWithFormat:@"%@:",dic[self.key1]];
                self.value2.text = [NSString stringWithFormat:@" %@",dic[self.key2]];
                break;
            case 2:
                self.title3.text = [NSString stringWithFormat:@"%@:",dic[self.key1]];
                self.value3.text = [NSString stringWithFormat:@" %@",dic[self.key2]];
                break;
            case 3:
                self.title4.text = [NSString stringWithFormat:@"%@:",dic[self.key1]];
                self.value4.text = [NSString stringWithFormat:@" %@",dic[self.key2]];
                break;
            case 4:
                self.title5.text = [NSString stringWithFormat:@"%@:",dic[self.key1]];
                self.value5.text = [NSString stringWithFormat:@" %@",dic[self.key2]];
                break;
            default:
                break;
        }
    }
}

- (void)setUpdataMore:(NSArray *)array{
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *dic = array[i];
        NSMutableString *mut = [NSMutableString string];
        switch (i) {
            case 0:
            {
                self.title1.text = [NSString stringWithFormat:@"%@:",dic[self.key1]];
                NSArray * array = dic[self.key2];
                if (![array isKindOfClass:[NSArray class]]) {
                    self.value4.text = @"无";
                    break;
                }
                for (NSString *str in array) {
                    [mut appendString:[NSString stringWithFormat:@"%@\n",str]];
                }
                self.value1.text = mut.copy;
            }
                break;
            case 1:
            {
                self.title2.text = [NSString stringWithFormat:@"%@:",dic[self.key1]];
                NSArray * array = dic[self.key2];
                if (![array isKindOfClass:[NSArray class]]) {
                    self.value4.text = @"无";
                    break;
                }
                for (NSString *str in array) {
                    [mut appendString:[NSString stringWithFormat:@"%@\n",str]];
                }
                self.value2.text = mut.copy;
            }
                break;
            case 2:
            {
                self.title3.text = [NSString stringWithFormat:@"%@:",dic[self.key1]];
                NSArray * array = dic[self.key2];
                if (![array isKindOfClass:[NSArray class]]) {
                    self.value4.text = @"无";
                    break;
                }
                for (NSString *str in array) {
                    [mut appendString:[NSString stringWithFormat:@"%@\n",str]];
                }
                self.value3.text = mut.copy;
            }
                break;
            case 3:
            {
                self.title4.text = [NSString stringWithFormat:@"%@:",dic[self.key1]];
                NSArray * array = dic[self.key2];
                if (![array isKindOfClass:[NSArray class]]) {
                    self.value4.text = @"无";
                    break;
                }
                for (NSString *str in array) {
                    [mut appendString:[NSString stringWithFormat:@"%@\n",str]];
                }
                self.value4.text = mut.copy;
            }
                break;
            case 4:
            {
                self.title5.text = [NSString stringWithFormat:@"%@:",dic[self.key1]];
                NSArray * array = dic[self.key2];
                if (![array isKindOfClass:[NSArray class]]) {
                    self.value4.text = @"无";
                    break;
                }
                for (NSString *str in array) {
                    [mut appendString:[NSString stringWithFormat:@"%@\n",str]];
                }
                self.value5.text = mut.copy;
            }
                break;
            default:
                break;
        }
    }
}

@end
