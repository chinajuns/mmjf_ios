//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "TQStarRatingView.h"

@interface TQStarRatingView ()

@property (nonatomic, readwrite) int numberOfStar;
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@property (nonatomic, assign) CGPoint sizeOf;
@end

@implementation TQStarRatingView

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStar:kNUMBER_OF_STAR spacing:5];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numberOfStar = kNUMBER_OF_STAR;
    [self commonInit:5];
}

/**
 *  初始化TQStarRatingView
 *
 *  @param frame  Rectangles
 *  @param number 星星个数
 *
 *  @return TQStarRatingViewObject
 */
- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number spacing:(NSInteger)spacing{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        [self commonInit:spacing];
    }
    return self;
}

- (void)commonInit:(NSInteger)spacing {
    self.starBackgroundView = [self buidlStarViewWithImageName:kBACKGROUND_STAR spacing:spacing];
    self.starForegroundView = [self buidlStarViewWithImageName:kFOREGROUND_STAR spacing:spacing];
    [self addSubview:self.starBackgroundView];
    [self addSubview:self.starForegroundView];
}

#pragma mark - Set Score

/**
 *  设置控件分数
 *
 *  @param score     分数，必须在 0 － 1 之间
 *  @param isAnimate 是否启用动画
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate {
    [self setScore:score withAnimation:isAnimate completion:^(BOOL finished){}];
}

/**
 *  设置控件分数
 *
 *  @param score      分数，必须在 0 － 1 之间
 *  @param isAnimate  是否启用动画
 *  @param completion 动画完成block
 */
- (void)setScore:(float)score withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion {
    NSAssert((score >= 0.0)&&(score <= 1.0), @"score must be between 0 and 1");
    
    if (score < 0) {
        score = 0;
    }
    if (score > 1) {
        score = 1;
    }
    CGPoint point = CGPointMake(score * self.frame.size.width, 0);
    
    if(isAnimate){
        [UIView animateWithDuration:0.2 animations:^{
             [self changeStarForegroundViewWithPoint:point];
        } completion:^(BOOL finished) {
            if (completion){
                completion(finished);
            }
        }];
    } else {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark - Touche Event

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point)) {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _sizeOf = point;
    [UIView animateWithDuration:0.2 animations:^{
        [self changeStarForegroundViewWithPoint:point];
    }];
}

#pragma mark - Buidl Star View

/**
 *  通过图片构建星星视图
 *
 *  @param imageName 图片名称
 *
 *  @return 星星视图
 */
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName spacing:(NSInteger)spacing{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar + spacing, 0, frame.size.width / self.numberOfStar - spacing, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark - Change Star Foreground With Point

/**
 *  通过坐标改变前景视图
 *
 *  @param point 坐标
 */
- (void)changeStarForegroundViewWithPoint:(CGPoint)point{
    CGPoint p = point;
    
    if (p.x < 0) {
        p.x = 0;
    }
    if (p.x > self.frame.size.width) {
        p.x = self.frame.size.width;
    }
    
    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    float score = [str floatValue];
    
    p.x = roundf(score * 10) * 0.1 * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    __weak typeof (self)weakSelf = self;
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)]) {
        [weakSelf.delegate starRatingView:weakSelf score:roundf(score * 10) * 0.1];
    }
    
}

@end
