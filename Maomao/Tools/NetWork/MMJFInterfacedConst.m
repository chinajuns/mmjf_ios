//
//  MMJFInterfacedConst.m
//  Maomao
//
//  Created by 御顺 on 2017/11/9.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFInterfacedConst.h"

/** 文章详情H5*/
NSString *const v1ArticleDetails = @"Article-details.html";
/** 我能贷多少*/
NSString *const v1How = @"How.html";
/**  注册服务协议*/
NSString *const v1logupArg = @"logup-arg.html";
/** 关于我们*/
NSString *const v1aboutus = @"aboutus.html";
/** 积分规则*/
NSString *const v1interHelp = @"inter-help.html";
/** 邀请奖励规则*/
NSString *const v1recom = @"recom.html";
/** 房贷计算器*/
NSString *const v1calculator = @"Calculator.html";
/** 微名片*/
NSString *const v1sharecard = @"sharecard.html";
/** 邀请有奖*/
NSString *const v1kuanjiedai = @"share.html";
/** 实名认证协议*/
NSString *const v1authen = @"authen.html";

#pragma mark--C端
/** 获取token*/
NSString *const v1getToken = @"api/v1/token";
/** 图片上传(用户注册头像上传请调用2.2)
 */
NSString *const v1upload = @"api/v1/upload";
/** 注册：手机验证码：获取*/
NSString *const v1getCode = @"api/v1/getCode";
/** 注册：手机验证码：验证*/
NSString *const v1checkCode = @"api/v1/checkCode";
/** 注册：用户注册 */
NSString *const v1register = @"api/v1/register";
/** 登录：用户登录 */
NSString *const v1login = @"api/v1/login";
/** 忘记密码 */
NSString *const v1forgot = @"api/v1/forgot";
/** 修改密码 */
NSString *const v1reset = @"api/v1/reset";
/** 地区信息 */
NSString *const v1region = @"api/v1/region";
/** C首页:顾问推荐 */
NSString *const v1clientManager = @"api/v1/mobile/client/manager";
/** C首页:搜索配置 */
NSString *const v1clientAttrConfig = @"api/v1/mobile/client/attrConfig";
/** C首页:搜索 */
NSString *const v1clientSearch = @"api/v1/mobile/client/search";
/** C首页:信贷经理：详情 */
NSString *const v1clientInfoId = @"api/v1/mobile/client/info/";
/** C首页:信贷经理：详情：列表 */
NSString *const v1clientProListId = @"api/v1/mobile/client/proList/";
/** C首页:信贷经理:详情:举报 */
NSString *const v1clientReport = @"api/v1/mobile/client/report";
/** C首页:产品详情 */
NSString *const v1clientSingle = @"api/v1/mobile/client/single";
/** C首页:贷款申请:基本配置 */
NSString *const v1clientConfig = @"api/v1/mobile/client/config";
/** C首页:贷款申请:申请 */
NSString *const v1clientApply = @"api/v1/mobile/client/apply";
/** C首页:申请成功：推荐信贷经理 */
NSString *const v1clientRecommend = @"api/v1/mobile/client/recommend";
/** C首页: 店铺：评价：综合信息 */
NSString *const v1clientAverageId = @"api/v1/mobile/client/average/";
/** C首页: 店铺：评价：列表 */
NSString *const v1clientEvaluate = @"api/v1/mobile/client/evaluate";
/** C首页:店铺：添加收藏*/
NSString *const v1mobileClient = @"api/v1/mobile/client";
/** C贷款：首页 */
NSString *const v1clientLoan = @"api/v1/mobile/client/loan";
/** C贷款：搜索 配置 */
NSString *const v1clientLoanConfig = @"api/v1/mobile/client/loan/config";
/** 贷款：搜索：地区数据 */
NSString *const v1clientLoanRegionRegion = @"api/v1/mobile/client/loan/region/";
/** C贷款：搜索 */
NSString *const v1clientLoanSearch = @"api/v1/mobile/client/loan/search";
/** C消息提醒 */
NSString *const v1clientMessageType = @"api/v1/mobile/client/message/type/";
/** C个人中心:积分 */
NSString *const v1clientMemberPoint = @"api/v1/mobile/client/member/point";
/** C个人中心:积分流水 */
NSString *const v1clientMemberPointList = @"api/v1/mobile/client/member/pointList";
/** C设置 ：意见反馈 */
NSString *const v1clientMemberFeedback = @"api/v1/mobile/client/member/feedback";
/** C实名认证：填写资料 */
NSString *const v1clientMemberDocument = @"api/v1/mobile/client/member/document";
/** C实名认证：认证情况 */
NSString *const v1clientMemberAuthDocument = @"api/v1/mobile/client/member/authDocument";
/** C收藏列表 */
NSString *const v1clientMemberFavoriteList = @"api/v1/mobile/client/member/favoriteList";
/** C收藏：添加|取消 */
NSString *const v1clientMemberSetFavorite = @"api/v1/mobile/client/member/setFavorite";
/** C我的：订单 */
NSString *const v1clientMemberHistory = @"api/v1/mobile/client/member/history";
/** C我的：订单：基础类型 */
NSString *const v1userScoreType = @"api/v1/user/scoreType";
/** C我的：订单 ：添加点评 */
NSString *const v1userAddScore = @"api/v1/user/addScore";
/** 个人中心：个人：头像修改 */
NSString *const v1userAvatar = @"api/v1/user/avatar";
/** 我的：检查：收藏 */
NSString *const v1clientCheckFavorite = @"api/v1/mobile/client/checkFavorite";
/** 首页:未读消息：检查*/
NSString *const v1clientCheckNotice = @"api/v1/mobile/client/checkNotice";
/** 消息:已读设置*/
NSString *const v1messageSetRead = @"api/v1/mobile/client/message/setRead";
/** 咨询：咨询首页*/
NSString *const v1clientArticle = @"api/v1/mobile/client/article";
/** 咨询：咨询：列表*/
NSString *const v1clientArticleList = @"api/v1/mobile/client/articleList/";
/** 首页:贷款申请:申请成功：快速申请 */
NSString *const v1clientQuickApply = @"api/v1/mobile/client/quickApply";
/** 退出登录 */
NSString *const v1logout = @"api/v1/logout";
/** 首页:地图：顶部条件 */
NSString *const v1clientTopConfig = @"api/v1/mobile/client/topConfig";
/** 首页:地图搜索 */
NSString *const v1clientMap = @"api/v1/mobile/client/map";
/** 第三方绑定检查：如果已经绑定：直接返回用户信息 */
NSString *const v1setAuth = @"api/v1/setAuth";
/** 第三方绑定：成功直接返回用户信息 */
NSString *const v1setOauthBind = @"api/v1/setOauthBind";
/** 个人中心：第三方绑定 */
NSString *const v1memberSetOauthBind = @"api/v1/mobile/client/member/setOauthBind";
/** 个人中心：个人：绑定记录 */
NSString *const v1memberOauthBind = @"api/v1/mobile/client/member/oauthBind";
/** 个人中心：分享：二维码 */
NSString *const v1webGetQrcode = @"api/v1/web/getQrcode";
/** 个人中心：推送状态：读取 */
NSString *const v1getPushStatus = @"api/v1/mobile/client/member/getPushStatus";
/** 个人中心：推送状态设置 */
NSString *const v1setPushStatus = @"api/v1/mobile/client/member/setPushStatus";
/** 个人中心：分享：邀请信息统计 */
NSString *const v1memberInviteInfo = @"api/v1/mobile/client/member/inviteInfo";

#pragma mark--B端
/** B端：首页 */
NSString *const v1businessIndex = @"api/v1/mobile/business/index";
/** B端：首页-抢单-列表 */
NSString *const v1businessOrderIndex = @"api/v1/mobile/business/order/index";
/** B端：首页-抢单-详情 */
NSString *const v1businessOrderDetail = @"api/v1/mobile/business/order/detail";
/** B端：首页-抢单-检查抢单资格 */
NSString *const v1businessOrderCheckPurchase = @"api/v1/mobile/business/order/checkPurchase";
/** B端：首页-抢单-立即支付 */
NSString *const v1businessOrderPurchase = @"api/v1/mobile/business/order/purchase";
/**  B！抢单:配置 */
NSString *const v1businessOrderGrabConfig = @"api/v1/mobile/business/order/grabConfig";
/** B端：首页-甩单-展示发布甩单界面相关属性 */
NSString *const v1businessOrderJunkAttr = @"api/v1/mobile/business/order/junkAttr";
/** B端：首页-甩单发布(经理填写发布) */
NSString *const v1businessOrderJunkPublish = @"api/v1/mobile/business/order/junkPublish";
/** B端：首页-我的甩单列表(个人中心甩单列表共用该接口) */
NSString *const v1businessOrderJunkList = @"api/v1/mobile/business/order/junkList";
/** B端：首页-我的甩单详情 */
NSString *const v1businessOrderJunkDetail = @"api/v1/mobile/business/order/junkDetail";
/** B端：首页-甩单-重新甩单 */
NSString *const v1businessOrderJunkAgain = @"api/v1/mobile/business/order/junkAgain";
/** B端：店铺-创建店铺界面展示用户基本信息 */
NSString *const v1businessShopShowCreate = @"api/v1/mobile/business/shop/showCreate";
/** B端：店铺-创建店铺 */
NSString *const v1businessShopShowCreateWI = @"api/v1/mobile/business/shop/create";
/** B端：店铺-主页 */
NSString *const v1businessShopIndex = @"api/v1/mobile/business/shop/index";
/** B端：店铺-客户订单列表-个人中心抢的订单列表(共用该接口) */
NSString *const v1businessShopOrder = @"api/v1/mobile/business/shop/order";
/** B端：店铺-客户订单详情-个人中心订单详情(共用该接口) */
NSString *const v1businessShopOrderDetail = @"api/v1/mobile/business/shop/orderDetail";
/** B端：店铺-个人中心-订单中客户详情(共用该接口) */
NSString *const v1businessShopCustomerDetail = @"api/v1/mobile/business/shop/customerDetail";
/** B端：店铺-客户订单-详情执行流程审批 */
NSString *const v1businessShopOrderProcess = @"api/v1/mobile/business/shop/orderProcess";
/** B端：店铺-客户订单-评价界面用户印象 */
NSString *const v1businessShopOrderCommentLabel = @"api/v1/mobile/business/shop/orderCommentLabel";
/** B端：店铺-客户订单-评价提交 */
NSString *const v1businessShopOrderComment = @"api/v1/mobile/business/shop/orderComment";
/** B端：店铺-客户订单-拒绝申请 */
NSString *const v1businessShopCustomerOrderRefuse = @"api/v1/mobile/business/shop/orderRefuse";
/** B端：店铺-客户订单-甩单(用户申请的订单甩出去) */
NSString *const v1businessShopOrderJunk = @"api/v1/mobile/business/shop/orderJunk";
/** 店铺:我的店铺：代理产品：产品类型 */
NSString *const v1businessOtherType = @"api/v1/mobile/business/product/otherType";
/** B端：店铺-已代理的产品列表|可代理产品 */
NSString *const v1businessProductMyProduct = @"api/v1/mobile/business/product/myProduct";
/** B端：店铺-代理产品详情(未代理和已代理产品详情共用该接口) */
NSString *const v1businessProductDetail = @"api/v1/mobile/business/product/detail";
/** B端：店铺-产品-代理|取消代理 */
NSString *const v1businessProductSetAgent = @"api/v1/mobile/business/product/setAgent";
/** B端：店铺-个人中心-订单举报(共用该接口) */
NSString *const v1businessShopReport = @"api/v1/mobile/business/shop/report";
/** B端：我的-实名认证-提交认证资料 */
NSString *const v1businessManagerSubmitProfile = @"api/v1/mobile/business/manager/submitProfile";
/** B端：我的-实名认证-认证资料展示 */
NSString *const v1businessManagerProfile = @"api/v1/mobile/business/manager/profile";
