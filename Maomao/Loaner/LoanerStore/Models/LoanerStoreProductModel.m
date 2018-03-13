//
//  LoanerStoreProductModel.m
//  Maomao
//
//  Created by 御顺 on 2017/12/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerStoreProductModel.h"

@implementation LoanerStoreProductModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    
    return @{@"Id":@"id",@"cate_name":@[@"cate_name",@"title"],@"apply_people":@[@"apply_people",@"apply_peoples"]};
}
@end
