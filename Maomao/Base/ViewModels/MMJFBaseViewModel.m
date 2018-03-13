//
//  MMJFBaseViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/11/28.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"

@implementation MMJFBaseViewModel

- (void)bindViewToViewModel:(UIView *)view{}

- (NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        MMJF_Log(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
//    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    return jsonString;
    
}
@end
