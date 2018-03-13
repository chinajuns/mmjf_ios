//
//  CQPlaceholderView.m
//  CommonPlaceholderView
//
//  Created by 蔡强 on 2017/5/15.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "CQPlaceholderView.h"

@implementation CQPlaceholderView

#pragma mark - 构造方法
/**
 构造方法
 
 @param frame 占位图的frame
 @param type 占位图的类型
 @param delegate 占位图的代理方
 @return 指定frame、类型和代理方的占位图
 */
- (instancetype)initWithFrame:(CGRect)frame type:(CQPlaceholderViewType)type delegate:(id)delegate{
    if (self = [super initWithFrame:frame]) {
        // 存值
        _type = type;
        _delegate = delegate;
        // UI搭建
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI搭建
/** UI搭建 */
- (void)setUpUI{
    self.backgroundColor = [UIColor colorWithRed:246.f/255.f green:246.f/255.f blue:246.f/255.f alpha:1];
    
    //------- 图片在正中间 -------//
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MMJF_WIDTH / 2 - 50, MMJF_HEIGHT / 2 - 150, 100, 100)];
    imageView.userInteractionEnabled = YES;
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    //为图片添加手势
    [imageView addGestureRecognizer:singleTap];
    
    [self addSubview:imageView];
    
    //------- 说明label在图片下方 -------//
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, MMJF_WIDTH, 20)];
    descLabel.font = [UIFont fontWithName:@"PingFang SC" size:13];
    descLabel.textColor = [UIColor colorWithHexString:@"#1a1a1a"];
    [self addSubview:descLabel];
    descLabel.textAlignment = NSTextAlignmentCenter;
    
    //------- 按钮在说明label下方 -------//
    UIButton *reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(MMJF_WIDTH / 2 - 60, CGRectGetMaxY(descLabel.frame) + 5, 120, 25)];
    [self addSubview:reloadButton];
    [reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    reloadButton.layer.borderColor = MMJF_COLOR_Yellow.CGColor;
//    reloadButton.layer.borderWidth = 0.5;
    [reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //------- 根据type创建不同样式的UI -------//
    switch (_type) {
        case MMJFPlaceholderViewTypeNoNetwork: // 没网
        {
            imageView.image = [UIImage imageNamed:@"mei-you-wang-luo"];
            descLabel.text = @"网络链接已断开";
            [reloadButton setTitle:@"点击重试" forState:UIControlStateNormal];
        }
            break;
            
        case MMJFPlaceholderViewTypeLoan: // 没订单
        {
            imageView.image = [UIImage imageNamed:@"mei-you-shai-xuan-jie-guo"];
            descLabel.text = @"暂无数据";
            [reloadButton setTitle:@"" forState:UIControlStateNormal];
        }
            break;
            
        case CQPlaceholderViewTypeNoGoods: // 没商品
        {
            imageView.image = [UIImage imageNamed:@"没商品"];
            descLabel.text = @"红旗连锁你的好邻居";
            [reloadButton setTitle:@"buybuybuy" forState:UIControlStateNormal];
        }
            break;
            
        case CQPlaceholderViewTypeBeautifulGirl: // 妹纸
        {
            imageView.image = [UIImage imageNamed:@"妹纸"];
            descLabel.text = @"你会至少在此停留3秒钟";
            [reloadButton setTitle:@"不爱妹纸" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 重新加载按钮点击
/** 重新加载按钮点击 */
- (void)reloadButtonClicked:(UIButton *)sender{
    // 代理方执行方法
    if ([_delegate respondsToSelector:@selector(placeholderView:)]) {
        [_delegate placeholderView:self];
    }
}

///移除
- (void)remove{
    // 从父视图上移除
    [self removeFromSuperview];
}

//点击事件
- (void)clickImage:(UITapGestureRecognizer *)sender
{
    //具体的实现
    // 代理方执行方法
    if ([_delegate respondsToSelector:@selector(placeholderView:)]) {
        [_delegate placeholderView:self];
    }
}

@end
