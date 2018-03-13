//
//  ClientMessageNetWorkViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/19.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPublicBaseViewModel.h"

@interface ClientMessageNetWorkViewModel : ClientPublicBaseViewModel

/**
 C端：消息提醒
 */
@property (nonatomic, strong)RACCommand *messageCommand;

/**
 消息:已读设置
 */
@property (nonatomic, strong)RACCommand *messageSetReadCommand;
@end
