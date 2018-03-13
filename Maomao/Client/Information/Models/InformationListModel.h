//
//  InformationListModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/22.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationListModel : NSObject
/**
 简介
 */
@property(nonatomic, copy)NSString * introduce;
/**
 文章id
 */
@property(nonatomic, copy)NSString *Id;
/**
 标题
 */
@property(nonatomic, copy)NSString *title;
/**
 图片
 */
@property(nonatomic, copy)NSString *picture;
/**
 发布时间
 */
@property(nonatomic, copy)NSString *create_time;
/**
 浏览数
 */
@property(nonatomic, copy)NSString *views;

@property (nonatomic,copy)NSString *object_id;
@end
