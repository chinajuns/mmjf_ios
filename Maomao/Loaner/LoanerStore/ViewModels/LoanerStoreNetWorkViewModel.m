//
//  LoanerStoreNetWorkViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/27.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreNetWorkViewModel.h"

@implementation LoanerStoreNetWorkViewModel

//B端：店铺-创建店铺界面展示用户基本信息
- (RACCommand *)showCreateCommand{
    if (!_showCreateCommand) {
        _showCreateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessShopShowCreate:nil successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
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
    return _showCreateCommand;
}
//B端：店铺-创建店铺
- (RACCommand *)shopShowCreateCommand{
    if (!_shopShowCreateCommand) {
        _shopShowCreateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            MMJF_Log(@"%@",input);
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessShopShowCreateWI:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
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
    return _shopShowCreateCommand;
}
//B端：店铺-主页
- (RACCommand *)shopIndexCommand{
    if (!_shopIndexCommand) {
        _shopIndexCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessShopIndex:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
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
    return _shopIndexCommand;
}

//B端：店铺-客户订单列表-个人中心抢的订单列表(共用该接口)
- (RACCommand *)shopOrderCommand{
    if (!_shopOrderCommand) {
        _shopOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessShopOrder:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
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
    return _shopOrderCommand;
}
//B端：店铺-尚未代理的产品列表
- (RACCommand *)otherTypeCommand{
    if (!_otherTypeCommand) {
        _otherTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessOtherType:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
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
    return _otherTypeCommand;
}

//B端：店铺-已代理的产品列表
- (RACCommand *)myProductCommand{
    if (!_myProductCommand) {
        _myProductCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessProductMyProduct:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _myProductCommand;
}

//B端：店铺-代理产品详情(未代理和已代理产品详情共用该接口)
- (RACCommand *)detailCommand{
    if (!_detailCommand) {
        _detailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessProductDetail:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
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
    return _detailCommand;
}
//B端：店铺-客户订单详情-个人中心订单详情(共用该接口)
- (RACCommand *)orderDetailCommand{
    if (!_orderDetailCommand) {
        _orderDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessShopOrderDetail:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
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
    return _orderDetailCommand;
}
//B端：店铺-客户订单-详情执行流程审批
- (RACCommand *)orderProcessCommand{
    if (!_orderProcessCommand) {
        _orderProcessCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessShopOrderProcess:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
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
    return _orderProcessCommand;
}
//B端：店铺-客户订单-拒绝申请
- (RACCommand *)customerOrderRefuseCommand{
    if (!_customerOrderRefuseCommand) {
        _customerOrderRefuseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessShopCustomerOrderRefuse:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    [MBProgressHUD showError:baseModel.msg];
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
    return _customerOrderRefuseCommand;
}

//B端：店铺-客户订单-甩单(用户申请的订单甩出去)
- (RACCommand *)orderJunkCommand{
    if (!_orderJunkCommand) {
        _orderJunkCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessShopOrderJunk:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
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
    return _orderJunkCommand;
}
//B端：店铺-客户订单-评价界面用户印象
- (RACCommand *)orderCommentLabelCommand{
    if (!_orderCommentLabelCommand) {
        _orderCommentLabelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessShopOrderCommentLabel:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    [MBProgressHUD showError:baseModel.msg];
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
    return _orderCommentLabelCommand;
}
//B端：店铺-客户订单-评价提交
- (RACCommand *)orderCommentCommand{
    if (!_orderCommentCommand) {
        _orderCommentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            MMJF_Log(@"%@",input);
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [MMJF_NetworkShare v1businessShopOrderComment:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    [MBProgressHUD showError:baseModel.msg];
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
    return _orderCommentCommand;
}
//B端：店铺-个人中心-订单举报(共用该接口)
- (RACCommand *)shopReportCommand{
    if (!_shopReportCommand) {
        _shopReportCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            MMJF_Log(@"%@",input);
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessShopReport:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    [MBProgressHUD showError:baseModel.msg];
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
    return _shopReportCommand;
}
//B端：店铺-产品-代理|取消代理
- (RACCommand *)setAgentCommand{
    if (!_setAgentCommand) {
        _setAgentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            MMJF_Log(@"%@",input);
            // block调用：执行命令的时候就会调用
            [MBProgressHUD showMessage:@"正在加载" toView:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:nil];
            });
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessProductSetAgent:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD hideHUDForView:nil];
                    [MBProgressHUD showError:baseModel.msg];
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
    return _setAgentCommand;
}
@end
