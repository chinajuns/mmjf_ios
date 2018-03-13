//
//  CardView.m
//  CardAnimation
//
//  Created by leicunjie on 16/5/27.
//  Copyright © 2016年 leicunjie. All rights reserved.
//

#import "ClientHomeListCardView.h"
#import "YZTagList.h"
#import "TQStarRatingView.h"

@interface ClientHomeListCardView ()<StarRatingViewDelegate>
/**
 背景视图
 */
@property (weak, nonatomic) IBOutlet UIView *backView;
/**
 打分
 */
@property (weak, nonatomic) IBOutlet UIView *scoreView;

/**
 标签
 */
@property (weak, nonatomic) IBOutlet UIView *tagListLab;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *authImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *scoreLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *tagLab;

@end

@implementation ClientHomeListCardView

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setUpdata:(NSDictionary *)dic{
    self.clientManagerModel = [ClientManagerModel yy_modelWithJSON:dic];
    self.name.text = self.clientManagerModel.name;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString judgeHttp:self.clientManagerModel.header_img]] placeholderImage:[UIImage imageNamed:@"denglu-mei-you-tou-xiang"]];
    if ([_clientManagerModel.is_auth isEqualToString:@"1"]) {
        self.authImage.image = [UIImage imageNamed:@"wei-ren-zheng"];
    }else{
        self.authImage.image = [UIImage imageNamed:@"yi-ren-zheng"];
    }
    self.contentLab.text = [NSString stringWithFormat:@"最高可为您贷款:%@\n已成功放款:%@\n最近30天成功放款:%@\n平均放款天数:%@",_clientManagerModel.max_loan,_clientManagerModel.loan_number,_clientManagerModel.all_number,_clientManagerModel.loan_day];
    self.scoreLab.text = _clientManagerModel.score;
    self.tagLab.text = _clientManagerModel.tag;
    [self setUptagListView];
    [self setUpScoreView];
}

//设置标签
- (void)setUptagListView{
    NSArray *array = [_clientManagerModel.tags componentsSeparatedByString:@","];
    // 创建标签列表
    YZTagList *tagList = [[YZTagList alloc] init]; // 高度可以设置为0，会自动跟随标题计算
    tagList.frame = self.tagListLab.bounds;
    // 需要排序
    tagList.isSort = NO;
    tagList.tagMargin  = 5;
    tagList.tagLabelH = 10;
    tagList.biggestH = 45;
    // 设置标签背景色
    tagList.tagBackgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    // 设置标签颜色
    tagList.tagColor = [UIColor colorWithHexString:@"#b3b3b3"];
    tagList.tagFont = [UIFont fontWithName:@"PingFang SC" size:10];
    NSMutableArray *mut = [NSMutableArray array];
    if (array.count > 2) {
        for (int i = 0; i < 2; i ++) {
            [mut addObject:array[i]];
        }
    }
    /**
     *  这里一定先设置标签列表属性，然后最后去添加标签
     */
    [tagList addTags:mut selectedStrs:nil];
    [self.tagListLab addSubview:tagList];
}
//设置打分控件
- (void)setUpScoreView{
    TQStarRatingView * serviceStar = [[TQStarRatingView alloc] initWithFrame:self.scoreView.bounds numberOfStar:kNUMBER_OF_STAR spacing:0];
    serviceStar.delegate = self;
    CGFloat score = [_clientManagerModel.score floatValue] * 2 / 10;
    [serviceStar setScore:score withAnimation:YES];
    [self.scoreView addSubview:serviceStar];
}

- (void)starRatingView:(TQStarRatingView *)view score:(float)score{
//    NSLog(@"ssss%f",score);
//    if (view.tag == 1) {
//        _serviceFloat = [NSString stringWithFormat:@"%.1f",score * 5];
//    }else if (view.tag == 2){
//        _authorityFloat = [NSString stringWithFormat:@"%.1f",score * 5];
//    }else{
//        _companyFloat = [NSString stringWithFormat:@"%.1f",score * 5];
//    }
}
@end
