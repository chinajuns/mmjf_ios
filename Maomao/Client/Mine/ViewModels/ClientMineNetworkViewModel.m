//
//  ClientMineNetworkViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/19.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineNetworkViewModel.h"

@implementation ClientMineNetworkViewModel
/// C端：个人中心:积分
- (RACCommand *)memberPointCommand{
    if (!_memberPointCommand) {
        _memberPointCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientMemberPoint:^(MMJFBaseModel *baseModel) {
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
    return _memberPointCommand;
}
///C端：个人中心:积分流水
- (RACCommand *)pointListCommand{
    if (!_pointListCommand) {
        _pointListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientMemberPointList:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _pointListCommand;
}

- (RACCommand *)feedbackCommand{
    if (!_feedbackCommand) {
        _feedbackCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [MMJF_NetworkShare v1clientMemberFeedback:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _feedbackCommand;
}


- (RACCommand *)documentCommand{
    if (!_documentCommand) {
        _documentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientMemberDocument:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _documentCommand;
}
//我的：实名认证：认证情况
- (RACCommand *)authDocumentCommand{
    if (!_authDocumentCommand) {
        _authDocumentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientMemberAuthDocument:^(MMJFBaseModel *baseModel) {
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
    return _authDocumentCommand;
}
//我的：订单
- (RACCommand *)historyCommand{
    if (!_historyCommand) {
        _historyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientMemberHistory:input successBlock:^(MMJFBaseModel *baseModel) {
//                    [MBProgressHUD showSuccess:baseModel.msg];
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
    return _historyCommand;
}
//首页:信贷经理:详情:举报
- (RACCommand *)reportCommand{
    if (!_reportCommand) {
        _reportCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1clientReport:input successBlock:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD showSuccess:@"举报成功"];
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
    return _reportCommand;
}
//我的：订单：基础类型
- (RACCommand *)scoreTypeCommand{
    if (!_scoreTypeCommand) {
        _scoreTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1userScoreType:^(MMJFBaseModel *baseModel) {
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
    return _scoreTypeCommand;
}
//我的：订单：添加点评
- (RACCommand *)userAddScoreCommand{
    if (!_userAddScoreCommand) {
        _userAddScoreCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1userAddScore:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _userAddScoreCommand;
}
//退出登录
- (RACCommand *)logoutCommand{
    if (!_logoutCommand) {
        _logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1logout:^(MMJFBaseModel *baseModel) {
                    [MBProgressHUD showSuccess:baseModel.msg];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    MMJF_Log(@"%@",baseModel);
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
    return _logoutCommand;
}
//个人中心：第三方绑定
- (RACCommand *)memberSetOauthBind{
    if (!_memberSetOauthBind) {
        _memberSetOauthBind = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1memberSetOauthBind:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _memberSetOauthBind;
}
//个人中心：个人：绑定记录
- (RACCommand *)memberOauthBind{
    if (!_memberOauthBind) {
        _memberOauthBind = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1memberOauthBind:input successBlock:^(MMJFBaseModel *baseModel) {
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
                    // 发送数据
                    [subscriber sendNext:baseModel.status];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    return _memberOauthBind;
}
//个人中心：分享：二维码
- (RACCommand *)webGetQrcode{
    if (!_webGetQrcode) {
        _webGetQrcode = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1webGetQrcode:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _webGetQrcode;
}
//推送状态读取
- (RACCommand *)getPushStatus{
    if (!_getPushStatus) {
        _getPushStatus = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1getPushStatus:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _getPushStatus;
}

//个人中心：推送状态设置
- (RACCommand *)setPushStatus{
    if (!_setPushStatus) {
        _setPushStatus = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1setPushStatus:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _setPushStatus;
}
//个人中心：分享：邀请信息统计
- (RACCommand *)memberInviteInfo{
    if (!_memberInviteInfo) {
        _memberInviteInfo = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            // block调用：执行命令的时候就会调用
            MMJF_Log(@"%@", input);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1memberInviteInfo:input successBlock:^(MMJFBaseModel *baseModel) {
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
    return _memberInviteInfo;
}
@end
