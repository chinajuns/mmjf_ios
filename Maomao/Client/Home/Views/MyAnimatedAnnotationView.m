//
//  MyAnimatedAnnotationView.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 14-11-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "MyAnimatedAnnotationView.h"

@implementation MyAnimatedAnnotationView

@synthesize annotationImageView = _annotationImageView;
//@synthesize annotationImages = _annotationImages;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        [self setBounds:CGRectMake(0.f, 0.f, 64.f, 64.f)];

        [self setBackgroundColor:[UIColor clearColor]];
        
//        _annotationImageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        _annotationImageView.contentMode = UIViewContentModeCenter;
        UILabel *lae = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, self.bounds.size.width, self.bounds.size.height)];
        MMJF_Log(@"%@",NSStringFromCGRect(self.bounds));
        lae.numberOfLines = 0;
        lae.font = [UIFont fontWithName:@"PingFang SC" size:12];
        lae.textColor = [UIColor colorWithHexString:@"#ffffff"];
        NSArray *array = [annotation.subtitle componentsSeparatedByString:@","];
        lae.text = [NSString stringWithFormat:@"%@\n%@位",annotation.title,array[0]];
        lae.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lae];
//        [_annotationImageView addSubview:lae];
//        [self addSubview:_annotationImageView];
        self.canShowCallout = NO;
    }
    return self;
}

//- (void)setAnnotationImages:(NSMutableArray *)images {
//    _annotationImages = images;
//    _annotationImageView.image = images[0];
////    [self updateImageView];
//}

//- (void)updateImageView {
//    if ([_annotationImageView isAnimating]) {
//        [_annotationImageView stopAnimating];
//    }
//
//    _annotationImageView.animationImages = _annotationImages;
//    _annotationImageView.animationDuration = 0.5 * [_annotationImages count];
//    _annotationImageView.animationRepeatCount = 0;
//    [_annotationImageView startAnimating];
//}

@end
