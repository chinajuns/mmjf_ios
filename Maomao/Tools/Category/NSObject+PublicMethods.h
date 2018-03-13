//
//  NSObject+PublicMethods.h
//  Maomao
//
//  Created by 御顺 on 2017/11/25.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PublicMethods)

///获取本机信息
- (NSDictionary *)getSystemInformation;
//字典转json
- (NSString*)dictionaryToJson:(NSDictionary *)dic;
@end
