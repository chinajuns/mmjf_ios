//
//  ClientLogCardViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/11/24.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientLogCardViewModel.h"

@interface ClientLogCardViewModel ()
@end
@implementation ClientLogCardViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initialize];
        [self login];
    }
    return self;
}

- (void)initialize{
}

//登录
- (void)login{
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block调用：执行命令的时候就会调用
        MMJF_Log(@"%@", input);
        
        [MBProgressHUD showMessage:@"正在加载" toView:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:nil];
        });
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [MMJF_NetworkShare v1login:input successBlock:^(MMJFBaseModel *baseModel) {
                [MBProgressHUD hideHUDForView:nil];
                [MBProgressHUD showSuccess:baseModel.msg];
                // 发送数据
                [subscriber sendNext:baseModel.data];
                // *** 发送完成 **
                [subscriber sendCompleted];
            } failureBlock:^(MMJFBaseModel *baseModel) {
                [MBProgressHUD hideHUDForView:nil];
                if (![baseModel.msg isEqualToString:@"已取消"]) {
                    [MBProgressHUD showError:baseModel.msg];
                }
                // *** 发送完成 **
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
}

@end
