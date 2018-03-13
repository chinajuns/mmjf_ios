//
//  ClientMineAuthDocumentModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/20.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientMineAuthDocumentModel : NSObject

/**
 身份证正面
 */
@property (nonatomic, copy)NSString *front_identity;
/**
 身份证背面
 */
@property (nonatomic, copy)NSString *back_identity;
/**
 姓名
 */
@property (nonatomic, copy)NSString *true_name;
/**
 身份验证;1:未认证,2:审核中,3:审核通过,4:审核拒绝
 */
@property (nonatomic, copy)NSString *is_pass;
/**
 身份证号码
 */
@property (nonatomic, copy)NSString *identity_number;
/**
 地址
 */
@property (nonatomic, copy)NSString *address;
@end

