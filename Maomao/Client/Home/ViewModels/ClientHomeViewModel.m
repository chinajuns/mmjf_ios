//
//  ClientHomeViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/16.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeViewModel.h"

@implementation ClientHomeViewModel


- (RACCommand *)clientManagerCommand{
    if (!_clientManagerCommand) {
        _clientManagerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientManager:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    //                NSLog(@"%@",baseModel.data);
                    ////                [MBProgressHUD showSuccess:baseModel.msg];
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
    return _clientManagerCommand;
}

//- (RACCommand *)clientSearchCommand{
//    if (!_clientSearchCommand) {
//        _clientSearchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            NSString *str = [input componentsJoinedByString:@","];
//            NSDictionary *dic = @{@"ids":str};
//            // block调用：执行命令的时候就会调用
//            [MBProgressHUD showMessage:@"正在加载" toView:nil];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:nil];
//            });
//            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                [MMJF_NetworkShare v1clientSearch:dic successBlock:^(MMJFBaseModel *baseModel) {
//                    [MBProgressHUD hideHUDForView:nil];
//                    // 发送数据
//                    [subscriber sendNext:baseModel.data];
//                    // *** 发送完成 **
//                    [subscriber sendCompleted];
//                } failureBlock:^(MMJFBaseModel *baseModel) {
//                    [MBProgressHUD hideHUDForView:nil];
//                    // 发送数据
//                    [subscriber sendNext:baseModel.msg];
//                    // *** 发送完成 **
//                    [subscriber sendCompleted];
//                }];
//                return nil;
//            }];
//        }];
//    }
//    return _clientSearchCommand;
//}

//我的：收藏：添加|取消
- (RACCommand *)setFavoriteCommand{
    if (!_setFavoriteCommand) {
        _setFavoriteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientMemberSetFavorite:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _setFavoriteCommand;
}
//我的：检查：收藏
- (RACCommand *)checkFavoriteCommand{
    if (!_checkFavoriteCommand) {
        _checkFavoriteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientCheckFavorite:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _checkFavoriteCommand;
}
//我的：收藏列表
- (RACCommand *)favoriteListCommand{
    if (!_favoriteListCommand) {
        _favoriteListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            NSDictionary *dic = input[@"dict"];
            NSString *page = input[@"page"];
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientMemberFavoriteList:dic page:page successBlock:^(MMJFBaseModel *baseModel) {
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
    return _favoriteListCommand;
}
//首页:贷款申请:申请成功：快速申请
- (RACCommand *)quickApplyCommand{
    if (!_quickApplyCommand) {
        _quickApplyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientQuickApply:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD showSuccess:baseModel.msg];
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
    return _quickApplyCommand;
}
//首页:店铺：评价：综合信息
- (RACCommand *)averageCommand{
    if (!_averageCommand) {
        _averageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientAverageId:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _averageCommand;
}
//首页:店铺：评价：列表
- (RACCommand *)evaluateCommand{
    if (!_evaluateCommand) {
        _evaluateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientEvaluate:input successBlock:^(MMJFBaseModel *baseModel) {
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    if (![baseModel.msg isEqualToString:@"已取消"]) {
                        [MBProgressHUD showError:baseModel.msg];
                    }
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _evaluateCommand;
}
//首页:地图：顶部条件
- (RACCommand *)topConfigCommand{
    if (!_topConfigCommand) {
        _topConfigCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientTopConfig:^(MMJFBaseModel *baseModel) {
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    if (![baseModel.msg isEqualToString:@"已取消"]) {
                        [MBProgressHUD showError:baseModel.msg];
                    }
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _topConfigCommand;
}
//首页:地图搜索
- (RACCommand *)clientMapCommand{
    if (!_clientMapCommand) {
        _clientMapCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientMap:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _clientMapCommand;
}
@end
