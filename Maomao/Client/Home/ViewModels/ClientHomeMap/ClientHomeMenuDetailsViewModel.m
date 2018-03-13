//
//  ClientHomeMenuDetailsViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/11/29.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeMenuDetailsViewModel.h"
#import "LPActionSheet.h"

@interface ClientHomeMenuDetailsViewModel ()

@end
@implementation ClientHomeMenuDetailsViewModel

- (void)dealloc{
    [self.shareSubject sendCompleted];
    [self.favoriteSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shareSubject = [RACSubject subject];
        self.favoriteSubject = [RACSubject subject];
    }
    return self;
}

- (void)bindViewToViewModel:(UIView *)view {
    self.pullMenuView = (ZWPullMenuView *)view;
    
    self.pullMenuView.zwPullMenuStyle = PullMenuLightStyle;
    __weak typeof(self)weakSelf = self;
    self.pullMenuView.blockSelectedMenu = ^(NSInteger menuRow) {
        ClientUserModel *user =[NSKeyedUnarchiver unarchiveObjectWithFile:MMJF_UserInfoPath];
        if (!user) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LogonFailure" object:nil userInfo:@{}];
            return;
        }
        if (weakSelf.isB == YES) {
            [weakSelf.shareSubject sendNext:@""];
        }else{
            if (menuRow == 1) {//分享
                [weakSelf.shareSubject sendNext:@""];
            }
            else{//收藏
                if (weakSelf.isCollection == YES) {
                    [weakSelf.favoriteSubject sendNext:@"1"];
                }else{
                    [weakSelf.favoriteSubject sendNext:@"0"];
                }
            }
        }
        
    };
}



@end
