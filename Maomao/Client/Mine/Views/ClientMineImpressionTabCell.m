//
//  ClientMineImpressionTabCell.m
//  Maomao
//
//  Created by 御顺 on 2017/12/5.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineImpressionTabCell.h"
#import "YZTagList.h"

@implementation ClientMineImpressionTabCell

- (void)dealloc{
    [self.arraySubject sendCompleted];
    [self.removeSubject sendCompleted];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arraySubject = [RACSubject subject];
    self.removeSubject = [RACSubject subject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//设置标签
- (void)setUptagListView:(NSArray *)tags selecteds:(NSArray *)selecteds{
    // 创建标签列表
    YZTagList *tagList = [[YZTagList alloc] init]; // 高度可以设置为0，会自动跟随标题计算
    tagList.frame = self.tagView.bounds;
    // 需要排序
    tagList.isSort = NO;
    tagList.tagMargin  = 15;
    tagList.tagListCols = 3;
    tagList.tagSize = CGSizeMake((MMJF_WIDTH - 60) / 3, 25);
    // 不需要自适应标签列表高度
    tagList.isFitTagListH = NO;
    tagList.borderWidth = 1;
    tagList.borderColor = [UIColor colorWithHexString:@"#e6e6e6"];
    // 设置标签背景色
    tagList.tagBackgroundColor = [UIColor whiteColor];
    // 设置标签颜色
    tagList.tagColor = [UIColor colorWithHexString:@"#4d4d4d"];
    tagList.tagSelectedBackgroundColor = [UIColor colorWithHexString:@"#fff6cc"];
    tagList.tagSelectedColor = [UIColor colorWithHexString:@"#ffba00"];
    tagList.tagFont = [UIFont fontWithName:@"PingFang SC" size:11];
    
    /**
     *  这里一定先设置标签列表属性，然后最后去添加标签
     */
    [tagList addTags:tags selectedStrs:selecteds];
    __weak typeof(self)weakSelf = self;
    
    tagList.clickTagBlock = ^(UIButton *tag){
        MMJF_Log(@"%ld",tag.titleLabel.tag);
        if (tag.selected) {
            tag.backgroundColor = [UIColor whiteColor];
            [tag setTitleColor:[UIColor colorWithHexString:@"#4d4d4d"] forState:UIControlStateNormal];
            [weakSelf.removeSubject sendNext:tag.titleLabel.text];
        }else{
            [weakSelf.arraySubject sendNext:tag.titleLabel.text];
            tag.backgroundColor = [UIColor colorWithHexString:@"#fff6cc"];
            [tag setTitleColor:[UIColor colorWithHexString:@"#ffba00"] forState:UIControlStateNormal];
        }
        tag.selected = !tag.selected;
    };
    [self.tagView addSubview:tagList];
}

@end
