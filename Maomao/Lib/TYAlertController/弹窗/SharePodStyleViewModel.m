//
//  SharePodStyleViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/12.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "SharePodStyleViewModel.h"
#import "ShareTitleTwoView.h"
#import "ShareView.h"
#import "ShareTwoView.h"
#import "ShareResetView.h"
#import "SharePictureTwoView.h"
#import "SharePictureSingleView.h"
#import "ShareTextTwoView.h"
#import "ShareTabTwoView.h"
#import "SharetQrcodeView.h"
#import "ShareelsewhereView.h"

@interface SharePodStyleViewModel()
@property (nonatomic, strong)UIViewController *popView;

@end
@implementation SharePodStyleViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clickSubject = [RACSubject subject];
    }
    return self;
}

//设置双按钮提示
- (TYAlertController *)setUpShareTwo:(NSString *)title determineStr:(NSString *)determineStr cancelStr:(NSString *)cancelStr{
    ShareTwoView *shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareTwoView" owner:self options:nil] lastObject];
    shareView.frame = CGRectMake(0, 0, MMJF_WIDTH - 40, 170);
    shareView.layer.cornerRadius = 5;
    shareView.layer.masksToBounds = YES;
    __weak typeof(self)weakSelf = self;
    [shareView.determineBut setTitle:determineStr forState:UIControlStateNormal];
    [shareView.cancelBut setTitle:cancelStr forState:UIControlStateNormal];
    [[shareView.determineBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.clickSubject sendNext:title];
    }];
    shareView.title.text = title;
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    return alertController;
}
//带标题的双选择按钮
- (TYAlertController *)setUpShareTitleTwoView:(NSString *)title soce:(NSString *)soceStr unit:(NSString *)unitStr{
    ShareTitleTwoView *shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareTitleTwoView" owner:self options:nil] lastObject];
    shareView.frame = CGRectMake(0, 0, MMJF_WIDTH - 40, 188);
    shareView.layer.cornerRadius = 5;
    shareView.layer.masksToBounds = YES;
    __weak typeof(self)weakSelf = self;
    [[shareView.determineBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.clickSubject sendNext:title];
    }];
    shareView.title.text = title;
    shareView.soceLab.text = soceStr;
    shareView.unitLab.text = unitStr;
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    return alertController;
}

//图片
- (TYAlertController *)setUpShareImgView:(NSString *)imgStr{
    SharetQrcodeView *shareView = [[[NSBundle mainBundle]loadNibNamed:@"SharetQrcodeView" owner:self options:nil] lastObject];
    shareView.frame = CGRectMake(0, 0, MMJF_WIDTH - 96, MMJF_WIDTH - 96);
    shareView.layer.cornerRadius = 5;
    shareView.layer.masksToBounds = YES;
    [shareView.qrcodeimg sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@""]];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    return alertController;
}

//带x取消带图片的提示
- (TYAlertController *)setUpShareResetView:(NSString *)title{
    ShareResetView *shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareResetView" owner:self options:nil] lastObject];
    shareView.frame = CGRectMake(0, 0, MMJF_WIDTH - 40, 221);
    shareView.layer.cornerRadius = 5;
    shareView.layer.masksToBounds = YES;
    shareView.resetBut.layer.cornerRadius = 5;
    shareView.resetBut.layer.masksToBounds = YES;
    shareView.title.text = title;
    __weak typeof(self)weakSelf = self;
    [[shareView.resetBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.clickSubject sendNext:title];
    }];
    [[shareView.cancelBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.clickSubject sendNext:@"取消"];
    }];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    return alertController;
}

//带x取消的提示
- (TYAlertController *)setUpShareCancelView:(NSString *)title isC:(BOOL)isC{
    ShareelsewhereView *shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareelsewhereView" owner:self options:nil] lastObject];
    shareView.frame = CGRectMake(0, 0, MMJF_WIDTH - 40, 150);
    shareView.layer.cornerRadius = 5;
    shareView.layer.masksToBounds = YES;
    shareView.resetBut.layer.cornerRadius = 5;
    shareView.resetBut.layer.masksToBounds = YES;
    shareView.title.text = title;
    __weak typeof(self)weakSelf = self;
    [[shareView.resetBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.clickSubject sendNext:title];
    }];
    [[shareView.cancelBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.clickSubject sendNext:@"取消"];
    }];
    if (isC == YES) {
        shareView.cancelBut.hidden = NO;
    }else{
        shareView.cancelBut.hidden = YES;
    }
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
//    alertController.backgoundTapDismissEnable = YES;
    return alertController;
}

//带图片单按钮的提示
- (TYAlertController *)setUpSharePictureSingleView:(NSString *)title img:(NSString *)imgStr butTitle:(NSString *)butTitle{
    SharePictureSingleView *shareView = [[[NSBundle mainBundle]loadNibNamed:@"SharePictureSingleView" owner:self options:nil] lastObject];
    if ([imgStr isEqualToString:@"cheng-gong"]) {
        shareView.frame = CGRectMake(0, 0, MMJF_WIDTH - 40, 190);
    }else{
        shareView.frame = CGRectMake(0, 0, MMJF_WIDTH - 40, 210);
    }
    
    shareView.layer.cornerRadius = 5;
    shareView.layer.masksToBounds = YES;
    shareView.title.text = title;
    shareView.img.image = [UIImage imageNamed:imgStr];
    [shareView.resetBut setTitle:butTitle forState:UIControlStateNormal];
    __weak typeof(self)weakSelf = self;
    [[shareView.resetBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.clickSubject sendNext:title];
    }];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    return alertController;
}

//带图片双按钮的提示
- (TYAlertController *)setUpSharePictureTwoView:(NSString *)title img:(NSString *)imgStr butTitle:(NSString *)butTitle prompt1:(NSString *)promptStr1 prompt2:(NSString *)promptStr2{
    SharePictureTwoView* shareView = [[[NSBundle mainBundle]loadNibNamed:@"SharePictureTwoView" owner:self options:nil] lastObject];
    shareView.frame = CGRectMake(0, 0, MMJF_WIDTH - 40, 201);
    shareView.layer.cornerRadius = 5;
    shareView.layer.masksToBounds = YES;
    shareView.title.text = title;
    shareView.img.image = [UIImage imageNamed:imgStr];
    [shareView.resetBut setTitle:butTitle forState:UIControlStateNormal];
    shareView.promptLab.text = promptStr1;
    shareView.promptLab2.text = promptStr2;
    __weak typeof(self)weakSelf = self;
    [[shareView.resetBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf.clickSubject sendNext:title];
    }];
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    return alertController;
}

//设置双按钮text提示
- (TYAlertController *)setUpShareTextTwo:(NSString *)title determineStr:(NSString *)determineStr cancelStr:(NSString *)cancelStr unit:(NSString *)unitStr{
    ShareTextTwoView *shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareTextTwoView" owner:self options:nil] lastObject];
    shareView.frame = CGRectMake(0, 0, MMJF_WIDTH - 40, 123);
    shareView.layer.cornerRadius = 5;
    shareView.layer.masksToBounds = YES;
    __weak typeof(self)weakSelf = self;
    [shareView input];
    [shareView.determineBut setTitle:determineStr forState:UIControlStateNormal];
    [shareView.cancelBut setTitle:cancelStr forState:UIControlStateNormal];
    __weak typeof(shareView)weakShareView = shareView;
    [[shareView.determineBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSDictionary *dic = @{@"title":title,@"value":weakShareView.textF.text};
        [weakSelf.clickSubject sendNext:dic];
    }];
    shareView.unitLab.text = unitStr;
    shareView.title.text = title;
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    return alertController;
}

//设置双按钮tab提示
- (TYAlertController *)setUpShareTabTwo:(NSString *)title determineStr:(NSString *)determineStr cancelStr:(NSString *)cancelStr whyArray:(NSArray *)whyArray{
    ShareTabTwoView *shareView = [[[NSBundle mainBundle]loadNibNamed:@"ShareTabTwoView" owner:self options:nil] lastObject];
    shareView.frame = CGRectMake(0, 0, MMJF_WIDTH - 40, 260);
    shareView.layer.cornerRadius = 5;
    shareView.layer.masksToBounds = YES;
    [shareView setUpUI];
    __weak typeof(self)weakSelf = self;
    [shareView.determineBut setTitle:determineStr forState:UIControlStateNormal];
    [shareView.cancelBut setTitle:cancelStr forState:UIControlStateNormal];
    __weak typeof(shareView)weakShareView = shareView;
    [[shareView.determineBut rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSDictionary *dic = @{@"title":title,@"value":weakShareView.chooseStr};
        [weakSelf.clickSubject sendNext:dic];
    }];
    [shareView refresh:whyArray];
    shareView.title.text = title;
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:shareView preferredStyle:TYAlertControllerStyleAlert];
    alertController.backgoundTapDismissEnable = YES;
    return alertController;
}
@end
