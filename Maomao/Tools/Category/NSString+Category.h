//
//  PK-ios
//
//  Created by peikua on 15/9/15.
//  Copyright (c) 2015年 peikua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSString (Category)


//电话号码中间4位****显示
+ (NSString*) getSecrectStringWithPhoneNumber:(NSString*)phoneNum;

//银行卡号中间8位显示
+ (NSString*) getSecrectStringWithAccountNo:(NSString*)accountNo;

//计算文字高度
- (CGFloat) heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width;
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

//去掉前后空格
- (NSString *) trimmedString;
//图片URl处理
+ (NSString *)judgeHttp:(NSString *)imgStr;
//数组中文格式（几万）可自行添加
+ (NSString*) stringChineseFormat:(double)value;
//金额数字转大写
+ (NSString *)digitUppercase:(NSString *)numstr;
//获取data数据图片的格式
+ (NSString *)typeForImageData:(NSData *)data;

/**
 秒/毫秒转日期

 @param timeStr 毫秒/秒
 @return 日期
 */
+ (NSString *)ConvertStrToTime:(NSString *)timeStr;

/**
 <#Description#>

 @param timeStr <#timeStr description#>
 @return <#return value description#>
 */
+ (NSString *)ConvertStrToTime1:(NSString *)timeStr;

// 过滤所有表情  https://gist.github.com/cihancimen/4146056
+ (BOOL)stringContainsEmoji:(NSString *)string;
/**
 *  判断字符串中是否存在emoji
 * @param string 字符串
 * @return YES(含有表情)
 */
+ (BOOL)hasEmoji:(NSString*)string;
//-----过滤字符串中的emoji
+ (NSString *)disable_emoji:(NSString *)text;
@end
