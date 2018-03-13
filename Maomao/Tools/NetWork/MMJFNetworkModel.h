//
//  MMJFNetworkModel.h
//  Maomao
//
//  Created by 御顺 on 2017/11/16.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMJFBaseModel.h"

typedef void(^successBlock)(MMJFBaseModel *baseModel);
typedef void(^failureBlock)(MMJFBaseModel *baseModel);


@interface MMJFNetworkModel : NSObject

+ (MMJFNetworkModel *)shareInstance;

/**
 获取token
 */
- (void)v1getToken;
/**
 图片上传(用户注册头像上传请调用2.2)
 
 @param images 图片数组
 */
- (void)v1imgupload:(successBlock)successBlock failureBlock:(failureBlock)failureBlock images:(NSArray *)images;

/**
 注册：手机验证码：获取

 @param dict mobile 手机号
             type 注册：type=register|重置：type=reset|待定？
 */
- (void)v1getCode:(NSDictionary *)dict successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock;

/**
 注册：手机验证码：验证

 @param dict mobile 手机号
             code 验证码
 */
- (void)v1checkCode:(NSDictionary *)dict successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock;

/**
 注册：用户注册

 @param dict mobile 手机号
 password 密码
 platform  Win:1|android:2|ios:3
 type 信贷经理：type=1|普通用户：type=2
 */
- (void)v1register:(NSDictionary *)dict successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock;

/**
 登录：用户登录

 @param dict mobile 手机号
 password
 platform Win:1|android:2|ios:3
 type 信贷经理：type=1|普通用户：type=2
 */
- (void)v1login:(NSDictionary *)dict successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock;

/**
 忘记密码

 @param dict password 新密码
             password_confirmation 确认密码
 */
- (void)v1forgot:(NSDictionary *)dict successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock;

/**
 修改密码

 @param dict old_password 旧密码
 password 新密码
 password_confirmation 确认密码
 
 */
- (void)v1reset:(NSDictionary *)dict successBlock:(successBlock)successBlock failureBlock:(failureBlock)failureBlock;
///地区信息
- (void)v1region;

/**
 C端：首页:顾问推荐
 */
- (void)v1clientManager:(successBlock)successBlock
           failureBlock:(failureBlock)failureBlock;

/**
 C端：首页:搜索配置
 */
- (void)v1clientAttrConfig:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock;

/**
 C端：首页:搜索

 @param dict 搜索条件：ids=1,2.3
 */
- (void)v1clientSearch:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock;

/**
 C端：首页:信贷经理：详情

 @param Id 信贷经理详情id
 */
- (void)v1clientInfoId:(NSString *)Id
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock;

/**
 C端：首页:信贷经理：详情：列表

 @param Id 信贷经理详情id
 */
- (void)v1clientProListId:(NSString *)Id
             successBlock:(successBlock)successBlock
             failureBlock:(failureBlock)failureBlock;

/**
 C端：首页:信贷经理:详情:举报

 @param dict to_uid 被举报人uid
             loan_id 订单id
             comment 举报内容
 */
- (void)v1clientReport:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock;

/**
 C端：首页:产品详情

 @param dict loaner_id   信贷经理id
             id          产品id
             platform    产品平台
 */
- (void)v1clientSingle:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock;

/**
 C首页:贷款申请:基本配置
 */
- (void)v1clientConfigId:(successBlock)successBlock
            failureBlock:(failureBlock)failureBlock;

/**
 C端：首页:产品详情

 @param dict name 申请人姓名
             apply_number 申请金额
             region_id 申请地区
             apply_information 申请信息
             age 出生年月
             loaner_id 经理人id
 */
- (void)v1clientApply:(NSDictionary *)dict
         successBlock:(successBlock)successBlock
         failureBlock:(failureBlock)failureBlock;

/**
 C端：首页:申请成功：推荐信贷经理
 */
- (void)v1clientRecommend:(NSDictionary *)dict
             successBlock:(successBlock)successBlock
             failureBlock:(failureBlock)failureBlock;

/**
 C端：首页: 店铺：评价：综合信息

 @param Id 信贷经理id
 */
- (void)v1clientAverageId:(NSString *)Id
             successBlock:(successBlock)successBlock
             failureBlock:(failureBlock)failureBlock;

/**
 C端：首页: 店铺：评价：列表

 @param dict id 信贷经理id
             type 差评type=5中评type=4好评：type=3,全部type=0
 
 */
- (void)v1clientEvaluate:(NSDictionary *)dict
            successBlock:(successBlock)successBlock
            failureBlock:(failureBlock)failureBlock;

/**
 C端：首页:店铺：添加收藏

 @param dict id id
             type 类型：type=1信贷经理|type=2文章
 
 */
- (void)v1mobileClient:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock;

/**
 C端：贷款：首页
 */
- (void)v1clientLoan:(NSString *)page successBlock:(successBlock)successBlock
        failureBlock:(failureBlock)failureBlock;

/**
 C端：贷款：搜索 配置
 */
- (void)v1clientLoanConfig:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock;

/**
 C端：贷款：搜索：地区数据

 @param dict name 城市名称
 */
- (void)v1clientLoanRegion:(NSDictionary *)dict
              successBlock:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock;

/**
 C端：贷款：搜索

 @param dict city 定位城市
             type 贷款类型
             focus_id 印象id
             region_id 地区id
 
 */
- (void)v1clientLoanSearch:(NSDictionary *)dict
                      page:(NSString *)page
              successBlock:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock;

/**
 C端：消息提醒

 @param type type 消息类型：1订单信息2系统信息
 */
- (void)v1clientMessageType:(NSString *)type
                       page:(NSString *)page
               successBlock:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock;

/**
 C端：个人中心:积分
 */
- (void)v1clientMemberPoint:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock;

/**
 C端：个人中心:积分流水
 */
- (void)v1clientMemberPointList:(NSString *)page
                   successBlock:(successBlock)successBlock
                   failureBlock:(failureBlock)failureBlock;

/**
 我的：设置 ：意见反馈

 @param dict comment 反馈内容|最少6字
 */
- (void)v1clientMemberFeedback:(NSDictionary *)dict
                  successBlock:(successBlock)successBlock
                  failureBlock:(failureBlock)failureBlock;

/**
 我的：实名认证：填写资料

 @param dict name 真实名称
             Province_id 省id
             City_id 市id
             District_id 区id
             front_cert 身份证正面
             back_cert 身份证背面
             number 身份证号码
 */
- (void)v1clientMemberDocument:(NSDictionary *)dict
                  successBlock:(successBlock)successBlock
                  failureBlock:(failureBlock)failureBlock;

/**
 我的：实名认证：认证情况
 */
- (void)v1clientMemberAuthDocument:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock;

/**
 我的：收藏列表

 @param dict Type 信贷经理：type=1文章type=2
 */
- (void)v1clientMemberFavoriteList:(NSDictionary *)dict
                              page:(NSString *)page
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock;

/**
 我的：收藏：添加|取消

 @param dict id 订单id
             type 类型：type=1信贷经理|type=2文章
             action 添加：add | 取消：cancel
 
 */
- (void)v1clientMemberSetFavorite:(NSDictionary *)dict
                     successBlock:(successBlock)successBlock
                     failureBlock:(failureBlock)failureBlock;

/**
 我的：订单

 @param dict type 全部:0办理中1,；待评价2；贷款记录3
 */
- (void)v1clientMemberHistory:(NSDictionary *)dict
                 successBlock:(successBlock)successBlock
                 failureBlock:(failureBlock)failureBlock;

/**
 我的：订单：基础类型
 */
- (void)v1userScoreType:(successBlock)successBlock
           failureBlock:(failureBlock)failureBlock;

/**
 我的：订单 ：添加点评

 @param dict id 订单id
             comment 评价内容
             focus 标签
             score {"14":5,"15":5,"16":5}|备注:attr_id :评分
 */
- (void)v1userAddScore:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock;

/**
 个人中心：个人：头像修改

 @param dict url 图片url
 */
- (void)v1userAvatar:(NSDictionary *)dict
        successBlock:(successBlock)successBlock
        failureBlock:(failureBlock)failureBlock;

///我的：检查：收藏
- (void)v1clientCheckFavorite:(NSDictionary *)dict
                 successBlock:(successBlock)successBlock
                 failureBlock:(failureBlock)failureBlock;

///首页:未读消息：检查
- (void)v1clientCheckNotice:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock;
/**
 消息:已读设置

 @param dict type Type=1订单2系统消息
 */
- (void)v1messageSetRead:(NSDictionary *)dict
            successBlock:(successBlock)successBlock
            failureBlock:(failureBlock)failureBlock;

///咨询：咨询首页
- (void)v1clientArticle:(successBlock)successBlock
           failureBlock:(failureBlock)failureBlock;
///咨询：咨询：列表
- (void)v1clientArticleList:(NSString *)Id
                       page:(NSString *)page
               successBlock:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock;

///首页:贷款申请:申请成功：快速申请
- (void)v1clientQuickApply:(NSDictionary *)dict
              successBlock:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock;
///退出登录
- (void)v1logout:(successBlock)successBlock
    failureBlock:(failureBlock)failureBlock;

///首页:地图：顶部条件
- (void)v1clientTopConfig:(successBlock)successBlock
             failureBlock:(failureBlock)failureBlock;
/**
 首页:地图搜索

 @param dict City 城市名称:city=’成都市’
             Type 产品类型：type=‘房产抵押贷款’
 */
- (void)v1clientMap:(NSDictionary *)dict
       successBlock:(successBlock)successBlock
       failureBlock:(failureBlock)failureBlock;

///第三方绑定检查：如果已经绑定：直接返回用户信息
- (void)v1setAuth:(NSDictionary *)dict
     successBlock:(successBlock)successBlock
     failureBlock:(failureBlock)failureBlock;

///第三方绑定：成功直接返回用户信息
- (void)v1setOauthBind:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock;

///个人中心：第三方绑定
- (void)v1memberSetOauthBind:(NSDictionary *)dict
                successBlock:(successBlock)successBlock
                failureBlock:(failureBlock)failureBlock;

///个人中心：个人：绑定记录
- (void)v1memberOauthBind:(NSDictionary *)dict
             successBlock:(successBlock)successBlock
             failureBlock:(failureBlock)failureBlock;

///个人中心：分享：二维码
- (void)v1webGetQrcode:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock;

///个人中心：推送状态：读取
- (void)v1getPushStatus:(NSDictionary *)dict
           successBlock:(successBlock)successBlock
           failureBlock:(failureBlock)failureBlock;

///个人中心：推送状态设置
- (void)v1setPushStatus:(NSDictionary *)dict
           successBlock:(successBlock)successBlock
           failureBlock:(failureBlock)failureBlock;

///个人中心：分享：邀请信息统计
- (void)v1memberInviteInfo:(NSDictionary *)dict
              successBlock:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock;
#pragma mark--B端
/**
 B端：首页

 @param dict  city_id 城市id
 ad_position_id Banner图位置id
 
 */
- (void)v1businessIndex:(NSDictionary *)dict
           successBlock:(successBlock)successBlock
           failureBlock:(failureBlock)failureBlock;

/**
 B端：首页-抢单-列表

 @param dict  is_vip 1=>会员订单,0=>普通订单
 region_id  区县id
 has_house 是否有房,1=>有房,0=>无房
 has_car 是否有车,1=>有车,0=>无车
 create_time 创建时间(注:初次加载时无需传此参数,在滑至底部加载更多时,传入最底部一条订单的创建时间,时间戳形式)
 
 */
- (void)v1businessOrderIndex:(NSDictionary *)dict
                successBlock:(successBlock)successBlock
                failureBlock:(failureBlock)failureBlock;

/**
 B端：首页-抢单-详情

 @param dict  id 抢单id
 */
- (void)v1businessOrderDetail:(NSDictionary *)dict
                 successBlock:(successBlock)successBlock
                 failureBlock:(failureBlock)failureBlock;

///B端：首页-抢单-检查抢单资格
- (void)v1businessOrderCheckPurchase:(NSDictionary *)dict
                        successBlock:(successBlock)successBlock
                        failureBlock:(failureBlock)failureBlock;

/**
 B端：首页-抢单-立即支付

 @param dict id 抢单id
 
 */
- (void)v1businessOrderPurchase:(NSDictionary *)dict
                   successBlock:(successBlock)successBlock
                   failureBlock:(failureBlock)failureBlock;

/**
 B端：首页-甩单-展示发布甩单界面相关属性
 */
- (void)v1businessOrderJunkAttr:(NSDictionary *)dict
                   successBlock:(successBlock)successBlock
                   failureBlock:(failureBlock)failureBlock;

/**
 B端：首页-甩单发布(经理填写发布)

 @param dict apply_number 贷款金额
 period 贷款周期id
 loan_type 贷款类型id
 customer 顾客姓名
 customer_mobile 顾客手机号
 age 年龄
 province_id 省份id
 city_id 城市id
 region_id  区县id
 is_marry 是否结婚,0=>否,1=>是
 job_information 工作信息values里的所选id的合集,逗号间隔
 assets_information 资产信息values里的所选id的合集,逗号间隔
 score 价值积分金额
 description  备注信息
 
 */
- (void)v1businessOrderJunkPublish:(NSDictionary *)dict
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock;

/**
 B端：首页-我的甩单列表(个人中心甩单列表共用该接口)
 
 @param dict status 甩单状态,0=>全部,1=>审核(审核中,审核失败),2=>进行中,3=>已成交,4=>已过期
 create_time 甩单时间,加载更多时传入最底部一条甩单的时间
 */
- (void)v1businessOrderJunkList:(NSDictionary *)dict
                   successBlock:(successBlock)successBlock
                   failureBlock:(failureBlock)failureBlock;
/**
 B端：首页-我的甩单详情

 @param dict id 甩单id
 
 */
- (void)v1businessOrderJunkDetail:(NSDictionary *)dict
                     successBlock:(successBlock)successBlock
                     failureBlock:(failureBlock)failureBlock;

/**
 B端：首页-甩单-重新甩单

 @param dict id 甩单id
 */
- (void)v1businessOrderJunkAgain:(NSDictionary *)dict
                    successBlock:(successBlock)successBlock
                    failureBlock:(failureBlock)failureBlock;

///B端：店铺-创建店铺界面展示用户基本信息
- (void)v1businessShopShowCreate:(NSDictionary *)dict
                    successBlock:(successBlock)successBlock
                    failureBlock:(failureBlock)failureBlock;
/**
 B端：店铺-创建店铺

 @param dict work_time 工作年限
 introduce 合作信息
 */
- (void)v1businessShopShowCreateWI:(NSDictionary *)dict
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock;
/**
 B端：店铺-主页

 @param dict work_time 工作年限
 introduce 合作信息
 
 */
- (void)v1businessShopIndex:(NSDictionary *)dict
               successBlock:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock;

/**
 B端：店铺-客户订单列表-个人中心抢的订单列表(共用该接口)

 @param dict status 切换状态,不传为全部,0=>办理中,1=>待评价,2=>订单记录
 create_time 订单时间,加载更多时传入最底部一条订单的时间
 refer 订单来源,customer=>店铺客户申请的订单,junk=>个人中心抢的订单
 
 */
- (void)v1businessShopOrder:(NSDictionary *)dict
               successBlock:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock;
/**
 B端：店铺-客户订单详情-个人中心订单详情(共用该接口)

 @param dict id 订单id
 */
- (void)v1businessShopOrderDetail:(NSDictionary *)dict
                     successBlock:(successBlock)successBlock
                     failureBlock:(failureBlock)failureBlock;
/**
 B端：店铺-个人中心-订单中客户详情(共用该接口)

 @param dict id 订单id
 */
- (void)v1businessShopCustomerDetail:(NSDictionary *)dict
                        successBlock:(successBlock)successBlock
                        failureBlock:(failureBlock)failureBlock;

/**
 B端：店铺-客户订单-详情执行流程审批

 @param dict id 订单id
 status 流程状态,1->2步时传1,  2->3步时传2,   3->4步传3
 money 金额,2->3步时传入签约金额,3->4步时传入放款金额
 */
- (void)v1businessShopOrderProcess:(NSDictionary *)dict
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock;
/**
 B端：店铺-客户订单-评价界面用户印象
 */
- (void)v1businessShopOrderCommentLabel:(NSDictionary *)dict
                           successBlock:(successBlock)successBlock
                           failureBlock:(failureBlock)failureBlock;

/**
 B端：店铺-客户订单-评价提交

 @param dict id  订单id
 score 评分,5以内的数字,包括5,最多保留一位小数
 label_ids 印象id合集,逗号间隔
 describe 评论内容
 */
- (void)v1businessShopOrderComment:(NSDictionary *)dict
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock;

/**
 B端：店铺-客户订单-拒绝申请

 @param dict id 订单id
 reason  拒绝原因
 */
- (void)v1businessShopCustomerOrderRefuse:(NSDictionary *)dict
                             successBlock:(successBlock)successBlock
                             failureBlock:(failureBlock)failureBlock;

/**
 B端：店铺-客户订单-甩单(用户申请的订单甩出去)

 @param dict id 订单id
 score 积分金额
 */
- (void)v1businessShopOrderJunk:(NSDictionary *)dict
                   successBlock:(successBlock)successBlock
                   failureBlock:(failureBlock)failureBlock;
/**
 B端：店铺:我的店铺：代理产品：产品类型
 */
- (void)v1businessOtherType:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock;

/**
 B端：店铺-已代理的产品列表|可代理产品

 @param dict create_time 代理时间,加载更多时传入最底部一条记录的时间
 */
- (void)v1businessProductMyProduct:(NSDictionary *)dict
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock;

/**
 B端：店铺-代理产品详情(未代理和已代理产品详情共用该接口)

 @param dict id  产品id
 source 产品来源  sys=>系统产品,other=>第三方产品
 agented 该产品是否已代理,0=>未代理,1=>已代理
 根据是从未代理列表进入还是已代理列表进入进行判断
 */
- (void)v1businessProductDetail:(NSDictionary *)dict
                   successBlock:(successBlock)successBlock
                   failureBlock:(failureBlock)failureBlock;


/**
 B端：店铺-个人中心-订单举报(共用该接口)

 @param dict id  订单id
 reason 举报原因
 */
- (void)v1businessShopReport:(NSDictionary *)dict
                successBlock:(successBlock)successBlock
                failureBlock:(failureBlock)failureBlock;

/**
 B端：我的-实名认证-提交认证资料

 @param dict header_img 头像
 username 姓名
 idcard 身份证号码
 agent_type 机构类型
 agent_name 机构名称
 department 所属部门
 hand_idcard_front 手持身份证正面
 hand_idcard_back 手持身份证背面
 work_card 工牌
 card 名片
 contract_page 合同
 logo_personal 与公司合影
 province_id  省id
 city_id 城市id
 region_id 区县id
 lat 纬度
 lng  经度
 operate_type 提交类型,insert=>初次提交,update=>重新提交
 */
- (void)v1businessManagerSubmitProfile:(NSDictionary *)dict
                          successBlock:(successBlock)successBlock
                          failureBlock:(failureBlock)failureBlock;

/**
 B端：我的-实名认证-认证资料展示
 */
- (void)v1businessManagerProfile:(NSDictionary *)dict
                    successBlock:(successBlock)successBlock
                    failureBlock:(failureBlock)failureBlock;

///B端：B！抢单:配置
- (void)v1businessOrderGrabConfig:(successBlock)successBlock
                     failureBlock:(failureBlock)failureBlock;

/**
 B端：店铺-产品-代理|取消代理

 @param dict id Id
 Action 添加：Add|取消：cancel
 */
- (void)v1businessProductSetAgent:(NSDictionary *)dict
                     successBlock:(successBlock)successBlock
                     failureBlock:(failureBlock)failureBlock;
@end
