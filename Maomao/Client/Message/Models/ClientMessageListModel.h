//
//  ClientMessageListModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/19.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientMessageListModel : NSObject
/**
 
 */
@property(nonatomic, copy)NSString * to_uid;
/**
 信息内容
 */
@property(nonatomic, copy)NSString *content;
/**
 是否成功：1成功2失败
 */
@property(nonatomic, copy)NSString *is_success;
/**
 1未读2已读
 */
@property(nonatomic, copy)NSString *status;
/**
 信息类型
 */
@property(nonatomic, copy)NSString *title;
/**
 时间
 */
@property(nonatomic, copy)NSString *create_time;
/**
 
 */
@property(nonatomic, copy)NSString *type;
/**
 
 */
@property(nonatomic, copy)NSString *from_uid;
@end
