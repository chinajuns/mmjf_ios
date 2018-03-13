//
//  LoanerHomeNetWorkViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/25.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerHomeNetWorkViewModel.h"

@implementation LoanerHomeNetWorkViewModel
//B端：首页
- (RACCommand *)indexCommand{
    if (!_indexCommand) {
        _indexCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            MMJF_Log(@"%@",input);
            // block调用：执行命令的时候就会调用
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [MMJF_NetworkShare v1businessIndex:input successBlock:^(MMJFBaseModel *baseModel) {
                    //                NSLog(@"%@",baseModel.data);
                    ////                [MBProgressHUD showSuccess:baseModel.msg];
                    // 发送数据
                    [subscriber sendNext:baseModel.data];
                    // *** 发送完成 **
                    [subscriber sendCompleted];
                } failureBlock:^(MMJFBaseModel *baseModel) {
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
    return _indexCommand;
}
@end
