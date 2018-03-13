//
//  LoanerCustomerNetWorkViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/26.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerCustomerNetWorkViewModel.h"

@implementation LoanerCustomerNetWorkViewModel

///B端：首页-抢单-列表
- (RACCommand *)orderIndexCommand{
    if (!_orderIndexCommand) {
        _orderIndexCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            MMJF_Log(@"%@",input);
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessOrderIndex:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    //                NSLog(@"%@",baseModel.data);
                    ////                [MBProgressHUD showSuccess:baseModel.msg];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _orderIndexCommand;
}
//B端：首页-抢单-检查抢单资格
- (RACCommand *)checkPurchaseCommand{
    if (!_checkPurchaseCommand) {
        _checkPurchaseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            MMJF_Log(@"%@",input);
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessOrderCheckPurchase:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    //                NSLog(@"%@",baseModel.data);
                    ////                [MBProgressHUD showSuccess:baseModel.msg];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _checkPurchaseCommand;
}
//B端：首页-抢单-立即支付
- (RACCommand *)purchaseCommand{
    if (!_purchaseCommand) {
        _purchaseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            MMJF_Log(@"%@",input);
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessOrderPurchase:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    //                NSLog(@"%@",baseModel.data);
                    ////                [MBProgressHUD showSuccess:baseModel.msg];
                    // 发送数据
                    [subscriber sendNext:baseModel.status];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
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
    return _purchaseCommand;
}
//B端：首页-抢单-详情
- (RACCommand *)orderDetailCommand{
    if (!_orderDetailCommand) {
        _orderDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            MMJF_Log(@"%@",input);
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessOrderDetail:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    //                NSLog(@"%@",baseModel.data);
                    ////                [MBProgressHUD showSuccess:baseModel.msg];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
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
    return _orderDetailCommand;
}
//B！抢单:配置
- (RACCommand *)grabConfigCommand{
    if (!_grabConfigCommand) {
        _grabConfigCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            MMJF_Log(@"%@",input);
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessOrderGrabConfig:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
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
    return _grabConfigCommand;
}
@end
