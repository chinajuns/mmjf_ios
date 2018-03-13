//
//  ClientManagerModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/16.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientManagerModel.h"

@implementation ClientManagerModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"Id":@"id",@"name":@[@"loanername",@"name"]};
}
@end
