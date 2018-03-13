//
//  ClientLoanNetWorkViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/19.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientLoanNetWorkViewModel.h"

@implementation ClientLoanNetWorkViewModel

- (RACCommand *)configCommand{
    if (!_configCommand) {
        _configCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientLoanConfig:^(MMJFBaseModel *baseModel) {
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
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
    return _configCommand;
}


- (RACCommand *)loanSearchCommand{
    if (!_loanSearchCommand) {
        _loanSearchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientLoanSearch:input[1] page:input[0] successBlock:^(MMJFBaseModel *baseModel) {
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _loanSearchCommand;
}

//- (RACCommand *)loanCommand{
//    if (!_loanCommand) {
//        _loanCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            // block调用：执行命令的时候就会调用
//            NSLog(@"%@", input);
//            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                [MMJF_NetworkShare v1clientLoan:input successBlock:^(MMJFBaseModel *baseModel) {
//                    // 发送数据
//                    [subscriber sendNext:baseModel.data];
//                    // *** 发送完成 **
//                    [subscriber sendCompleted];
//                } failureBlock:^(MMJFBaseModel *baseModel) {
//                    if (![baseModel.msg isEqualToString:@"已取消"]) {
//                        [MBProgressHUD showError:baseModel.msg];
//                    }
//                    // 发送数据
//                    [subscriber sendNext:baseModel.data];
//                    // *** 发送完成 **
//                    [subscriber sendCompleted];
//                }];
//                return nil;
//            }];
//        }];
//    }
//    return _loanCommand;
//}
@end
