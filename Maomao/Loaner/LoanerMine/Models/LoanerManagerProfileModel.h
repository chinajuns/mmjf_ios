//
//  LoanerManagerProfileModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/27.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanerManagerProfileModel : NSObject
@property (nonatomic, copy)NSString * header_img;//头像
@property (nonatomic, copy)NSString *true_name;//姓名
@property (nonatomic, copy)NSString *identity_number;//身份证号码
@property (nonatomic, copy)NSString *mechanism_type;//机构类型
@property (nonatomic, copy)NSString *mechanism;//机构名称
@property (nonatomic, copy)NSString *department;//所属部门
@property (nonatomic, copy)NSString *address;//地区
@property (nonatomic, copy)NSString *front_identity;//手持身份证正面
@property (nonatomic, copy)NSString *back_identity;//手持身份证背面
@property (nonatomic, copy)NSString *work_card;//工作证
@property (nonatomic, copy)NSString *card;//名片
@property (nonatomic, copy)NSString *contract_page;//合同页
@property (nonatomic, copy)NSString *logo_personal;//与公司合影
@property (nonatomic, copy)NSString *is_pass;//认证状态,2=>认证中,3=>审核通过,4=>审核拒绝

@end
