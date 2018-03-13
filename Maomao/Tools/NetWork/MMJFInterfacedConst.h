//
//  MMJFInterfacedConst.h
//  Maomao
//
//  Created by 御顺 on 2017/11/9.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark --H5
/** 文章详情H5*/
UIKIT_EXTERN NSString *const v1ArticleDetails;
/** 我能贷多少*/
UIKIT_EXTERN NSString *const v1How;
/**  注册服务协议*/
UIKIT_EXTERN NSString *const v1logupArg;
/** 关于我们*/
UIKIT_EXTERN NSString *const v1aboutus;
/** 积分规则*/
UIKIT_EXTERN NSString *const v1interHelp;
/** 邀请奖励规则*/
UIKIT_EXTERN NSString *const v1recom;
/** 房贷计算器*/
UIKIT_EXTERN NSString *const v1calculator;
/** 微名片*/
UIKIT_EXTERN NSString *const v1sharecard;
/** 邀请有奖*/
UIKIT_EXTERN NSString *const v1kuanjiedai;
/** 实名认证协议*/
UIKIT_EXTERN NSString *const v1authen;

#pragma mark - 详细接口地址
/** 获取token*/
UIKIT_EXTERN NSString *const v1getToken;
/** 图片上传(用户注册头像上传请调用2.2)*/
UIKIT_EXTERN NSString *const v1upload;
/** 注册：手机验证码：获取*/
UIKIT_EXTERN NSString *const v1getCode;
/** 注册：手机验证码：验证*/
UIKIT_EXTERN NSString *const v1checkCode;
/** 注册：用户注册 */
UIKIT_EXTERN NSString *const v1register;
/** 登录：用户登录 */
UIKIT_EXTERN NSString *const v1login;
/** 忘记密码 */
UIKIT_EXTERN NSString *const v1forgot;
/** 修改密码 */
UIKIT_EXTERN NSString *const v1reset;
/** 地区信息 */
UIKIT_EXTERN NSString *const v1region;
/** C首页:顾问推荐 */
UIKIT_EXTERN NSString *const v1clientManager;
/** C首页:搜索配置 */
UIKIT_EXTERN NSString *const v1clientAttrConfig;
/** C首页:搜索 */
UIKIT_EXTERN NSString *const v1clientSearch;
/** C首页:信贷经理：详情 */
UIKIT_EXTERN NSString *const v1clientInfoId;
/** C首页:信贷经理：详情：列表 */
UIKIT_EXTERN NSString *const v1clientProListId;
/** C首页:信贷经理:详情:举报 */
UIKIT_EXTERN NSString *const v1clientReport;
/** C首页:产品详情 */
UIKIT_EXTERN NSString *const v1clientSingle;
/** C首页:贷款申请:基本配置 */
UIKIT_EXTERN NSString *const v1clientConfig;
/** C首页:贷款申请:申请 */
UIKIT_EXTERN NSString *const v1clientApply;
/** C首页:申请成功：推荐信贷经理 */
UIKIT_EXTERN NSString *const v1clientRecommend;
/** C首页: 店铺：评价：综合信息 */
UIKIT_EXTERN NSString *const v1clientAverageId;
/** C首页: 店铺：评价：列表 */
UIKIT_EXTERN NSString *const v1clientEvaluate;
/** C首页:店铺：添加收藏*/
UIKIT_EXTERN NSString *const v1mobileClient;
/** C贷款：首页 */
UIKIT_EXTERN NSString *const v1clientLoan;
/** C贷款：搜索 配置 */
UIKIT_EXTERN NSString *const v1clientLoanConfig;
/** C贷款：搜索：地区数据 */
UIKIT_EXTERN NSString *const v1clientLoanRegionRegion;
/** C贷款：搜索 */
UIKIT_EXTERN NSString *const v1clientLoanSearch;
/** C消息提醒 */
UIKIT_EXTERN NSString *const v1clientMessageType;
/** C个人中心:积分 */
UIKIT_EXTERN NSString *const v1clientMemberPoint;
/** C个人中心:积分流水 */
UIKIT_EXTERN NSString *const v1clientMemberPointList;
/** C我的设置 ：意见反馈 */
UIKIT_EXTERN NSString *const v1clientMemberFeedback;
/** C我的实名认证：填写资料 */
UIKIT_EXTERN NSString *const v1clientMemberDocument;
/** C我的实名认证：认证情况 */
UIKIT_EXTERN NSString *const v1clientMemberAuthDocument;
/** C我的收藏列表 */
UIKIT_EXTERN NSString *const v1clientMemberFavoriteList;
/** C我的收藏：添加|取消 */
UIKIT_EXTERN NSString *const v1clientMemberSetFavorite;
/** C我的：订单 */
UIKIT_EXTERN NSString *const v1clientMemberHistory;
/** C我的：订单：基础类型 */
UIKIT_EXTERN NSString *const v1userScoreType;
/** C我的：订单 ：添加点评 */
UIKIT_EXTERN NSString *const v1userAddScore;
/** 个人中心：个人：头像修改 */
UIKIT_EXTERN NSString *const v1userAvatar;
/** 我的：检查：收藏 */
UIKIT_EXTERN NSString *const v1clientCheckFavorite;
/** 首页:未读消息：检查*/
UIKIT_EXTERN NSString *const v1clientCheckNotice;
/** 消息:已读设置*/
UIKIT_EXTERN NSString *const v1messageSetRead;
/** 咨询：咨询首页*/
UIKIT_EXTERN NSString *const v1clientArticle;
/** 咨询：咨询：列表*/
UIKIT_EXTERN NSString *const v1clientArticleList;
/** 首页:贷款申请:申请成功：快速申请 */
UIKIT_EXTERN NSString *const v1clientQuickApply;
/** 退出登录 */
UIKIT_EXTERN NSString *const v1logout;
/** 首页:地图：顶部条件 */
UIKIT_EXTERN NSString *const v1clientTopConfig;
/** 首页:地图搜索 */
UIKIT_EXTERN NSString *const v1clientMap;
/** 第三方绑定检查：如果已经绑定：直接返回用户信息 */
UIKIT_EXTERN NSString *const v1setAuth;
/** 第三方绑定：成功直接返回用户信息 */
UIKIT_EXTERN NSString *const v1setOauthBind;
/** 个人中心：第三方绑定 */
UIKIT_EXTERN NSString *const v1memberSetOauthBind;
/** 个人中心：个人：绑定记录 */
UIKIT_EXTERN NSString *const v1memberOauthBind;
/** 个人中心：分享：二维码 */
UIKIT_EXTERN NSString *const v1webGetQrcode;
/** 个人中心：推送状态：读取 */
UIKIT_EXTERN NSString *const v1getPushStatus;
/** 个人中心：推送状态设置 */
UIKIT_EXTERN NSString *const v1setPushStatus;
/** 个人中心：分享：邀请信息统计 */
UIKIT_EXTERN NSString *const v1memberInviteInfo;

#pragma Mark--B端
/** B端：首页 */
UIKIT_EXTERN NSString *const v1businessIndex;
/** B端：首页-抢单-列表 */
UIKIT_EXTERN NSString *const v1businessOrderIndex;
/** B端：首页-抢单-详情 */
UIKIT_EXTERN NSString *const v1businessOrderDetail;
/** B端：首页-抢单-检查抢单资格 */
UIKIT_EXTERN NSString *const v1businessOrderCheckPurchase;
/** B端：首页-抢单-立即支付 */
UIKIT_EXTERN NSString *const v1businessOrderPurchase;
/**  B！抢单:配置 */
UIKIT_EXTERN NSString *const v1businessOrderGrabConfig;
/** B端：首页-甩单-展示发布甩单界面相关属性 */
UIKIT_EXTERN NSString *const v1businessOrderJunkAttr;
/** B端：首页-甩单发布(经理填写发布) */
UIKIT_EXTERN NSString *const v1businessOrderJunkPublish;
/** B端：首页-我的甩单列表(个人中心甩单列表共用该接口) */
UIKIT_EXTERN NSString *const v1businessOrderJunkList;
/** B端：首页-我的甩单详情 */
UIKIT_EXTERN NSString *const v1businessOrderJunkDetail;
/** B端：首页-甩单-重新甩单 */
UIKIT_EXTERN NSString *const v1businessOrderJunkAgain;
/** B端：店铺-创建店铺界面展示用户基本信息 */
UIKIT_EXTERN NSString *const v1businessShopShowCreate;
/** B端：店铺-创建店铺 */
UIKIT_EXTERN NSString *const v1businessShopShowCreateWI;
/** B端：店铺-主页 */
UIKIT_EXTERN NSString *const v1businessShopIndex;
/** B端：店铺-客户订单列表-个人中心抢的订单列表(共用该接口) */
UIKIT_EXTERN NSString *const v1businessShopOrder;
/** B端：店铺-客户订单详情-个人中心订单详情(共用该接口) */
UIKIT_EXTERN NSString *const v1businessShopOrderDetail;
/** B端：店铺-个人中心-订单中客户详情(共用该接口) */
UIKIT_EXTERN NSString *const v1businessShopCustomerDetail;
/** B端：店铺-客户订单-详情执行流程审批 */
UIKIT_EXTERN NSString *const v1businessShopOrderProcess;
/** B端：店铺-客户订单-评价界面用户印象 */
UIKIT_EXTERN NSString *const v1businessShopOrderCommentLabel;
/** B端：店铺-客户订单-评价提交 */
UIKIT_EXTERN NSString *const v1businessShopOrderComment;
/** B端：店铺-客户订单-拒绝申请 */
UIKIT_EXTERN NSString *const v1businessShopCustomerOrderRefuse;
/** B端：店铺-客户订单-甩单(用户申请的订单甩出去) */
UIKIT_EXTERN NSString *const v1businessShopOrderJunk;
//* 店铺:我的店铺：代理产品：产品类型*/
UIKIT_EXTERN NSString *const v1businessOtherType;
/** B端：店铺-已代理的产品列表|可代理产品 */
UIKIT_EXTERN NSString *const v1businessProductMyProduct;
/** B端：店铺-代理产品详情(未代理和已代理产品详情共用该接口) */
UIKIT_EXTERN NSString *const v1businessProductDetail;
/** B端：店铺-产品-代理|取消代理 */
UIKIT_EXTERN NSString *const v1businessProductSetAgent;
/** B端：店铺-个人中心-订单举报(共用该接口) */
UIKIT_EXTERN NSString *const v1businessShopReport;
/** B端：我的-实名认证-提交认证资料 */
UIKIT_EXTERN NSString *const v1businessManagerSubmitProfile;
/** B端：我的-实名认证-认证资料展示 */
UIKIT_EXTERN NSString *const v1businessManagerProfile;

