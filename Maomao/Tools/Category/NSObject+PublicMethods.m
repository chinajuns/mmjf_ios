//
//  NSObject+PublicMethods.m
//  Maomao
//
//  Created by 御顺 on 2017/11/25.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "NSObject+PublicMethods.h"

@implementation NSObject (PublicMethods)

///获取本机信息
- (NSDictionary *)getSystemInformation{
    NSString *sys_version = [[UIDevice currentDevice] systemVersion];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *dic = @{@"platform":@"ios",@"sys_version":sys_version,@"app_version":app_version,@"deviceid":MMJF_ShareV.phoneId};
    return dic;
}
//字典转json
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
@end
