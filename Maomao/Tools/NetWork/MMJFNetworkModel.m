 //
//  MMJFNetworkModel.m
//  Maomao
//
//  Created by 御顺 on 2017/11/16.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFNetworkModel.h"
#import "MMJFInterfacedConst.h"
#import "MMJFtokenModel.h"

@implementation MMJFNetworkModel

// GCD 创建单例
+ (MMJFNetworkModel *)shareInstance{
    static MMJFNetworkModel *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[MMJFNetworkModel alloc] init];
    });
    return share;
}
///获取token
- (void)v1getToken{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_tokenUrl,v1getToken];
    NSDictionary *dic = [self getSystemInformation];
    [PPNetworkHelper POST:urlStr isImage:NO parameters:dic isCache:NO success:^(MMJFBaseModel * baseModel) {
    MMJFtokenModel *tokenModel = [MMJFtokenModel yy_modelWithJSON:baseModel.data];
        [MMJF_DEFAULTS setObject:baseModel.data forKey:@"tokenModel"];
        MMJF_ShareV.uid = tokenModel.uid;
        MMJF_ShareV.token = tokenModel.token;
        MMJF_ShareV.api_url = tokenModel.api_url;
        MMJF_ShareV.image_url = tokenModel.image_url;
        // 继续queue
        [MMJF_ShareV.queue setSuspended:NO];
        NSLog(@"ssssssss%@",baseModel.data);
        if (MMJF_ShareV.uid.length == 0) {
            // 创建文件管理对象
            NSFileManager *manager = [NSFileManager defaultManager];
            // 删除
            BOOL isDelete = [manager removeItemAtPath:MMJF_UserInfoPath error:nil];
            if (isDelete) {
                
            }
        }
        //设置请求头
        [PPNetworkHelper setValue:MMJF_ShareV.token  forHTTPHeaderField:@"token"];
        [PPNetworkHelper setValue:MMJF_ShareV.phoneId  forHTTPHeaderField:@"deviceid"];
        //设置图片请求头
        [[SDWebImageDownloader sharedDownloader] setValue:MMJF_ShareV.token forHTTPHeaderField:@"token"];
        [[SDWebImageDownloader sharedDownloader] setValue:MMJF_ShareV.phoneId forHTTPHeaderField:@"deviceid"];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *fileName = [path stringByAppendingPathComponent:@"local.plist" ];
        NSArray *array = [NSArray arrayWithContentsOfFile:fileName];
        if (array.count == 0) {
            [MMJF_NetworkShare v1region];
        }
    } failure:^(MMJFBaseModel * baseModel) {
        // 继续queue
        [MMJF_ShareV.queue setSuspended:NO];
        NSLog(@"ssssssss%@",baseModel.msg);
    }];
}

///图片上传(用户注册头像上传请调用2.2)
- (void)v1imgupload:(successBlock)successBlock
       failureBlock:(failureBlock)failureBlock
             images:(NSArray *)images{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1upload];
    NSDictionary *dic = @{@"image":images};
    [MBProgressHUD showMessage:@"正在加载" toView:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:nil];
    });
    [PPNetworkHelper uploadImagesWithURL:urlStr parameters:dic name:@"image" images:images fileNames:nil imageScale:0.8 imageType:@"jpg" progress:^(NSProgress *progress) {
        
    } success:^(MMJFBaseModel *baseModel) {
        [MBProgressHUD hideHUDForView:nil];
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        [MBProgressHUD hideHUDForView:nil];
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}
///注册：手机验证码：获取
- (void)v1getCode:(NSDictionary *)dict
     successBlock:(successBlock)successBlock
     failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1getCode];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}
///注册：手机验证码：验证
- (void)v1checkCode:(NSDictionary *)dict
       successBlock:(successBlock)successBlock
       failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1checkCode];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}
///注册：用户注册 
- (void)v1register:(NSDictionary *)dict
      successBlock:(successBlock)successBlock
      failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1register];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}
///登录：用户登录
- (void)v1login:(NSDictionary *)dict
   successBlock:(successBlock)successBlock
   failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1login];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///忘记密码
- (void)v1forgot:(NSDictionary *)dict
   successBlock:(successBlock)successBlock
   failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1forgot];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///修改密码
- (void)v1reset:(NSDictionary *)dict
    successBlock:(successBlock)successBlock
    failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1reset];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}
///地区信息
- (void)v1region{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1region];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *fileName = [path stringByAppendingPathComponent:@"local.plist" ];
        NSArray *array = baseModel.data;
        [array writeToFile:fileName atomically:YES];
        
    } failure:^(MMJFBaseModel *baseModel) {
        
    }];
}

///C端：首页:顾问推荐
- (void)v1clientManager:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientManager];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:YES success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：首页:搜索配置
- (void)v1clientAttrConfig:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientAttrConfig];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：首页:搜索
- (void)v1clientSearch:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientSearch];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:YES success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：首页:信贷经理：详情
- (void)v1clientInfoId:(NSString *)Id
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",MMJF_ShareV.api_url,v1clientInfoId,Id];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：首页:信贷经理：详情：列表
- (void)v1clientProListId:(NSString *)Id
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",MMJF_ShareV.api_url,v1clientProListId,Id];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：首页:信贷经理:详情:举报
- (void)v1clientReport:(NSDictionary *)dict
             successBlock:(successBlock)successBlock
             failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientReport];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：首页:产品详情
- (void)v1clientSingle:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientSingle];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C首页:贷款申请:基本配置
- (void)v1clientConfigId:(successBlock)successBlock
             failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientConfig];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：首页:产品详情
- (void)v1clientApply:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientApply];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：首页:申请成功：推荐信贷经理
- (void)v1clientRecommend:(NSDictionary *)dict
             successBlock:(successBlock)successBlock
             failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientRecommend];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：首页: 店铺：评价：综合信息
- (void)v1clientAverageId:(NSString *)Id
            successBlock:(successBlock)successBlock
            failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",MMJF_ShareV.api_url,v1clientAverageId,Id];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：首页: 店铺：评价：列表
- (void)v1clientEvaluate:(NSDictionary *)dict
         successBlock:(successBlock)successBlock
         failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientEvaluate];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：首页:店铺：添加收藏
- (void)v1mobileClient:(NSDictionary *)dict
            successBlock:(successBlock)successBlock
            failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1mobileClient];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：贷款：首页
- (void)v1clientLoan:(NSString *)page successBlock:(successBlock)successBlock
        failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?page=%@",MMJF_ShareV.api_url,v1clientLoan,page];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:YES success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：贷款：搜索 配置
- (void)v1clientLoanConfig:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientLoanConfig];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：贷款：搜索：地区数据
- (void)v1clientLoanRegion:(NSDictionary *)dict
              successBlock:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientLoanRegionRegion];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：贷款：搜索
- (void)v1clientLoanSearch:(NSDictionary *)dict
                      page:(NSString *)page
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?page=%@",MMJF_ShareV.api_url,v1clientLoanSearch,page];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:YES success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：消息提醒
- (void)v1clientMessageType:(NSString *)type
                       page:(NSString *)page
              successBlock:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@?page=%@",MMJF_ShareV.api_url,v1clientMessageType,type,page];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:YES success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：个人中心:积分
- (void)v1clientMemberPoint:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientMemberPoint];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///C端：个人中心:积分流水
- (void)v1clientMemberPointList:(NSString *)page
                   successBlock:(successBlock)successBlock
                   failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?page=%@",MMJF_ShareV.api_url,v1clientMemberPointList,page];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///我的：设置 ：意见反馈
- (void)v1clientMemberFeedback:(NSDictionary *)dict
              successBlock:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientMemberFeedback];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///我的：实名认证：填写资料
- (void)v1clientMemberDocument:(NSDictionary *)dict
                  successBlock:(successBlock)successBlock
                  failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientMemberDocument];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///我的：实名认证：认证情况
- (void)v1clientMemberAuthDocument:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientMemberAuthDocument];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///我的：收藏列表
- (void)v1clientMemberFavoriteList:(NSDictionary *)dict
                              page:(NSString *)page
                  successBlock:(successBlock)successBlock
                  failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?page=%@",MMJF_ShareV.api_url,v1clientMemberFavoriteList,page];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:YES success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///我的：收藏：添加|取消
- (void)v1clientMemberSetFavorite:(NSDictionary *)dict
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientMemberSetFavorite];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///我的：订单
- (void)v1clientMemberHistory:(NSDictionary *)dict
                     successBlock:(successBlock)successBlock
                     failureBlock:(failureBlock)failureBlock{
    NSString *page = dict[@"page"];
    NSDictionary *dic = dict[@"dict"];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?page=%@",MMJF_ShareV.api_url,v1clientMemberHistory,page];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dic isCache:YES success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///我的：订单：基础类型
- (void)v1userScoreType:(successBlock)successBlock
           failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1userScoreType];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///我的：订单 ：添加点评
- (void)v1userAddScore:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1userAddScore];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///个人中心：个人：头像修改
- (void)v1userAvatar:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1userAvatar];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///我的：检查：收藏
- (void)v1clientCheckFavorite:(NSDictionary *)dict
        successBlock:(successBlock)successBlock
        failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientCheckFavorite];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///首页:未读消息：检查
- (void)v1clientCheckNotice:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientCheckNotice];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///消息:已读设置
- (void)v1messageSetRead:(NSDictionary *)dict
                 successBlock:(successBlock)successBlock
                 failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1messageSetRead];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///咨询：咨询首页
- (void)v1clientArticle:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientArticle];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:YES success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///咨询：咨询：列表
- (void)v1clientArticleList:(NSString *)Id
                       page:(NSString *)page
               successBlock:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@?page=%@",MMJF_ShareV.api_url,v1clientArticleList,Id,page];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:YES success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///首页:贷款申请:申请成功：快速申请
- (void)v1clientQuickApply:(NSDictionary *)dict
            successBlock:(successBlock)successBlock
            failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientQuickApply];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///退出登录
- (void)v1logout:(successBlock)successBlock
    failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1logout];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///首页:地图：顶部条件
- (void)v1clientTopConfig:(successBlock)successBlock
    failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientTopConfig];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///首页:地图搜索
- (void)v1clientMap:(NSDictionary *)dict
       successBlock:(successBlock)successBlock
       failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1clientMap];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///第三方绑定检查：如果已经绑定：直接返回用户信息
- (void)v1setAuth:(NSDictionary *)dict
       successBlock:(successBlock)successBlock
       failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1setAuth];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///第三方绑定：成功直接返回用户信息
- (void)v1setOauthBind:(NSDictionary *)dict
     successBlock:(successBlock)successBlock
     failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1setOauthBind];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///个人中心：第三方绑定
- (void)v1memberSetOauthBind:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1memberSetOauthBind];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///个人中心：个人：绑定记录
- (void)v1memberOauthBind:(NSDictionary *)dict
                successBlock:(successBlock)successBlock
                failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1memberOauthBind];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///个人中心：分享：二维码
- (void)v1webGetQrcode:(NSDictionary *)dict
                successBlock:(successBlock)successBlock
                failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1webGetQrcode];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///个人中心：推送状态：读取
- (void)v1getPushStatus:(NSDictionary *)dict
             successBlock:(successBlock)successBlock
             failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1getPushStatus];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///个人中心：推送状态设置
- (void)v1setPushStatus:(NSDictionary *)dict
          successBlock:(successBlock)successBlock
          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1setPushStatus];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///个人中心：分享：邀请信息统计
- (void)v1memberInviteInfo:(NSDictionary *)dict
           successBlock:(successBlock)successBlock
           failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1memberInviteInfo];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

#pragma mark --B端
///B端：首页
- (void)v1businessIndex:(NSDictionary *)dict
              successBlock:(successBlock)successBlock
              failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessIndex];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：首页-抢单-列表
- (void)v1businessOrderIndex:(NSDictionary *)dict
           successBlock:(successBlock)successBlock
           failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessOrderIndex];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：首页-抢单-详情
- (void)v1businessOrderDetail:(NSDictionary *)dict
                successBlock:(successBlock)successBlock
                failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessOrderDetail];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：首页-抢单-检查抢单资格
- (void)v1businessOrderCheckPurchase:(NSDictionary *)dict
                 successBlock:(successBlock)successBlock
                 failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessOrderCheckPurchase];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：首页-抢单-立即支付
- (void)v1businessOrderPurchase:(NSDictionary *)dict
                        successBlock:(successBlock)successBlock
                        failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessOrderPurchase];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：首页-甩单-展示发布甩单界面相关属性
- (void)v1businessOrderJunkAttr:(NSDictionary *)dict
                   successBlock:(successBlock)successBlock
                   failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessOrderJunkAttr];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：首页-甩单发布(经理填写发布)
- (void)v1businessOrderJunkPublish:(NSDictionary *)dict
                   successBlock:(successBlock)successBlock
                   failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessOrderJunkPublish];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：首页-我的甩单列表(个人中心甩单列表共用该接口)
- (void)v1businessOrderJunkList:(NSDictionary *)dict
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessOrderJunkList];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：首页-我的甩单详情
- (void)v1businessOrderJunkDetail:(NSDictionary *)dict
                   successBlock:(successBlock)successBlock
                   failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessOrderJunkDetail];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：首页-甩单-重新甩单
- (void)v1businessOrderJunkAgain:(NSDictionary *)dict
                     successBlock:(successBlock)successBlock
                     failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessOrderJunkAgain];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-创建店铺界面展示用户基本信息
- (void)v1businessShopShowCreate:(NSDictionary *)dict
                    successBlock:(successBlock)successBlock
                    failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopShowCreate];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-创建店铺
- (void)v1businessShopShowCreateWI:(NSDictionary *)dict
                    successBlock:(successBlock)successBlock
                    failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopShowCreateWI];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-主页
- (void)v1businessShopIndex:(NSDictionary *)dict
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopIndex];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-客户订单列表-个人中心抢的订单列表(共用该接口)
- (void)v1businessShopOrder:(NSDictionary *)dict
               successBlock:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopOrder];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-客户订单详情-个人中心订单详情(共用该接口)
- (void)v1businessShopOrderDetail:(NSDictionary *)dict
               successBlock:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopOrderDetail];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-个人中心-订单中客户详情(共用该接口)
- (void)v1businessShopCustomerDetail:(NSDictionary *)dict
                     successBlock:(successBlock)successBlock
                     failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopCustomerDetail];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-客户订单-详情执行流程审批
- (void)v1businessShopOrderProcess:(NSDictionary *)dict
                        successBlock:(successBlock)successBlock
                        failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopOrderProcess];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-客户订单-评价界面用户印象
- (void)v1businessShopOrderCommentLabel:(NSDictionary *)dict
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopOrderCommentLabel];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-客户订单-评价提交
- (void)v1businessShopOrderComment:(NSDictionary *)dict
                           successBlock:(successBlock)successBlock
                           failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopOrderComment];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-客户订单-拒绝申请
- (void)v1businessShopCustomerOrderRefuse:(NSDictionary *)dict
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopCustomerOrderRefuse];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-客户订单-甩单(用户申请的订单甩出去)
- (void)v1businessShopOrderJunk:(NSDictionary *)dict
                             successBlock:(successBlock)successBlock
                             failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopOrderJunk];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺:我的店铺：代理产品：产品类型
- (void)v1businessOtherType:(successBlock)successBlock
               failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessOtherType];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-已代理的产品列表|可代理产品
- (void)v1businessProductMyProduct:(NSDictionary *)dict
                  successBlock:(successBlock)successBlock
                  failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessProductMyProduct];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-代理产品详情(未代理和已代理产品详情共用该接口)
- (void)v1businessProductDetail:(NSDictionary *)dict
                      successBlock:(successBlock)successBlock
                      failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessProductDetail];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：店铺-个人中心-订单举报(共用该接口)
- (void)v1businessShopReport:(NSDictionary *)dict
                        successBlock:(successBlock)successBlock
                        failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessShopReport];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：我的-实名认证-提交认证资料
- (void)v1businessManagerSubmitProfile:(NSDictionary *)dict
                successBlock:(successBlock)successBlock
                failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessManagerSubmitProfile];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：我的-实名认证-认证资料展示
- (void)v1businessManagerProfile:(NSDictionary *)dict
                          successBlock:(successBlock)successBlock
                          failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessManagerProfile];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}

///B端：B！抢单:配置
- (void)v1businessOrderGrabConfig:(successBlock)successBlock
                    failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessOrderGrabConfig];
    [PPNetworkHelper netWork:MMJFNetworkGET isImage:NO URl:urlStr parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}
//B端：店铺-产品-代理|取消代理
- (void)v1businessProductSetAgent:(NSDictionary *)dict
                     successBlock:(successBlock)successBlock
                     failureBlock:(failureBlock)failureBlock{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",MMJF_ShareV.api_url,v1businessProductSetAgent];
    [PPNetworkHelper netWork:MMJFNetworkPOST isImage:NO URl:urlStr parameters:dict isCache:NO success:^(MMJFBaseModel *baseModel) {
        if (successBlock) {
            successBlock(baseModel);
        }
    } failure:^(MMJFBaseModel *baseModel) {
        if (failureBlock) {
            failureBlock(baseModel);
        }
    }];
}
@end
