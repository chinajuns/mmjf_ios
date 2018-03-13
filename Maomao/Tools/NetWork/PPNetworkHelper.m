//
//  PPNetworkHelper.m
//  PPNetworkHelper
//
//  Created by AndyPang on 16/8/12.
//  Copyright © 2016年 AndyPang. All rights reserved.
//


#import "PPNetworkHelper.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "MMJFtokenModel.h"
static NSUInteger const kSnapshotImageDataLengthMax = 1 * 1024 * 1024; // 最大 2 M
#ifdef DEBUG
#define PPLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define PPLog(...)
#endif

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

@implementation PPNetworkHelper

static BOOL _isCookie;  //获取设置请求头
static NSMutableArray *_allSessionTask;
static AFHTTPSessionManager *_sessionManager;

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(PPNetworkStatus)networkStatus {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkStatus ? networkStatus(PPNetworkStatusUnknown) : nil;
//                if (_isOpenLog) PPLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus ? networkStatus(PPNetworkStatusNotReachable) : nil;
//                if (_isOpenLog) PPLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus ? networkStatus(PPNetworkStatusReachableViaWWAN) : nil;
//                if (_isOpenLog) PPLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus ? networkStatus(PPNetworkStatusReachableViaWiFi) : nil;
//                if (_isOpenLog) PPLog(@"WIFI");
                break;
        }
    }];

}

+ (BOOL)isNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork {
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

//+ (void)openLog {
//    _isOpenLog = YES;
//}
//
//+ (void)closeLog {
//    _isOpenLog = NO;
//}

+ (void)openCookie {
    _isCookie = YES;
}

+ (void)closeCookie {
    _isCookie = NO;
}

+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma 判断token
+ (void)netWork:(MMJFNetworkType)type
        isImage:(BOOL)isImage
            URl:(NSString *)URL
     parameters:(id)parameters
        isCache:(BOOL)isCache
        success:(PPHttpRequestSuccess)success
        failure:(PPHttpRequestFailed)failure{
    if (MMJF_ShareV.token.length == 0 || MMJF_ShareV.api_url.length == 0 || MMJF_ShareV.image_url.length == 0) {
        NSDictionary *dic = [MMJF_DEFAULTS objectForKey:@"tokenModel"];
        MMJFtokenModel *tokenModel = [MMJFtokenModel yy_modelWithJSON:dic];
        MMJF_ShareV.uid = tokenModel.uid;
        MMJF_ShareV.token = tokenModel.token;
        MMJF_ShareV.api_url = tokenModel.api_url;
        MMJF_ShareV.image_url = tokenModel.image_url;
        [self setStatusCode4001:URL type:type isImage:isImage params:parameters isCache:isCache successBlock:success failureBlock:failure];
    }else{
        
        if (type == MMJFNetworkPOST) {
            [PPNetworkHelper POST:URL isImage:isImage parameters:parameters isCache:isCache success:success failure:failure];
        }else{
            [PPNetworkHelper GET:URL isImage:isImage parameters:parameters isCache:isCache success:success failure:failure];
        }
    }
}

#pragma mark - GET请求
+ (NSURLSessionTask *)GET:(NSString *)URL
                  isImage:(BOOL)isImage
               parameters:(id)parameters
                  isCache:(BOOL)isCache
                  success:(PPHttpRequestSuccess)success
                  failure:(PPHttpRequestFailed)failure {
    
    NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self networkRequestStatus:responseObject url:URL type:MMJFNetworkGET isImage:isImage params:parameters isCache:isCache successBlock:success failBlock:failure];
        [[self allSessionTask] removeObject:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MMJF_Log(@"error%@",error.localizedDescription);
        if (isCache) {
            //读取缓存
            id object = [PPNetworkCache httpCacheForURL:URL parameters:parameters];
            MMJFBaseModel *baseModel = [MMJFBaseModel yy_modelWithJSON:object];
            if (success && object){
                success(baseModel);
            }else{
                NSDictionary *dic = @{@"msg":error.localizedDescription};
                MMJFBaseModel *baseModel = [MMJFBaseModel yy_modelWithJSON:dic];
                failure ? failure(baseModel) : nil;
            }
        }else{
            NSDictionary *dic = @{@"msg":error.localizedDescription};
            MMJFBaseModel *baseModel = [MMJFBaseModel yy_modelWithJSON:dic];
            failure ? failure(baseModel) : nil;
        }
        [[self allSessionTask] removeObject:task];
    }];
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - POST请求
+ (NSURLSessionTask *)POST:(NSString *)URL
                   isImage:(BOOL)isImage
                parameters:(id)parameters
                   isCache:(BOOL)isCache
                   success:(PPHttpRequestSuccess)success
                   failure:(PPHttpRequestFailed)failure {
    
    NSURLSessionDataTask * _Nullable extractedExpr = [_sessionManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self networkRequestStatus:responseObject url:URL type:MMJFNetworkPOST isImage:isImage params:parameters isCache:isCache successBlock:success failBlock:failure];
        [[self allSessionTask] removeObject:task];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MMJF_Log(@"error%@",error.localizedDescription);
        if (isCache) {
            //读取缓存
            id object = [PPNetworkCache httpCacheForURL:URL parameters:parameters];
            if (success && object){
                success(object);
            }else{
                NSDictionary *dic = @{@"msg":error.localizedDescription};
                MMJFBaseModel *baseModel = [MMJFBaseModel yy_modelWithJSON:dic];
                failure ? failure(baseModel) : nil;
            }
        }else{
            NSDictionary *dic = @{@"msg":error.localizedDescription};
            MMJFBaseModel *baseModel = [MMJFBaseModel yy_modelWithJSON:dic];
            failure ? failure(baseModel) : nil;
        }
        
        [[self allSessionTask] removeObject:task];
    }];
    NSURLSessionTask *sessionTask = extractedExpr;
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}
//成功状态判断
+ (void)networkRequestStatus:(id)responseObject
                         url:(NSString *)url
                        type:(MMJFNetworkType)type
                     isImage:(BOOL)isImage
                      params:(NSDictionary *)params
                     isCache:(BOOL)isCache
                successBlock:(PPHttpRequestSuccess)successBlock
                   failBlock:(PPHttpRequestFailed)failBlock{
    MMJFBaseModel *eff = [MMJFBaseModel yy_modelWithJSON:responseObject];
    MMJF_Log(@"sssss%@",responseObject);
    if (MMJF_ShareV.number > 2) {
        MMJF_ShareV.number = 0;
        if (failBlock){
            failBlock(eff);
        }
        //跳转登录
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"LogonFailure" object:nil userInfo:responseObject];
        // 创建文件管理对象
        NSFileManager *manager = [NSFileManager defaultManager];
        // 删除
        [manager removeItemAtPath:MMJF_UserInfoPath error:nil];
        return ;
    }
    if ([eff.status isEqualToString:@"200"]) {
        if (successBlock){
            successBlock(eff);
        }
        if ([eff.data isKindOfClass:[NSDictionary class]] || [eff.data isKindOfClass:[NSArray class]]) {
            //对数据进行异步缓存
            if (isCache) {
                [PPNetworkCache setHttpCache:responseObject URL:url parameters:params];
            }
        }
    }else if ([eff.status isEqualToString:@"4001"]){
        [self setStatusCode4001:url type:type isImage:isImage params:params isCache:isCache successBlock:successBlock failureBlock:failBlock];
    }else if ([eff.status isEqualToString:@"4004"]){
        MMJF_ShareV.number = 0;
        if (failBlock){
            failBlock(eff);
        }
        //跳转登录
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LogonFailure" object:nil userInfo:responseObject];
        // 创建文件管理对象
        NSFileManager *manager = [NSFileManager defaultManager];
        // 删除
        [manager removeItemAtPath:MMJF_UserInfoPath error:nil];
        
        return ;
    }else{
        if (isCache) {
            //读取缓存
            id object = [PPNetworkCache httpCacheForURL:url parameters:params];
            if (successBlock && object){
                successBlock(eff);
            }else{
                if (failBlock){
                    failBlock(eff);
                }
            }
        }else{
            MMJF_ShareV.errorStatus = eff.msg;
            if (failBlock){
                failBlock(eff);
            }
        }
    }
}
//token失效
+ (void)setStatusCode4001:(NSString *)url
                     type:(MMJFNetworkType)type
                  isImage:(BOOL)isImage
                  params:(NSDictionary *)params
                 isCache:(BOOL)isCache
            successBlock:(PPHttpRequestSuccess)successBlock
            failureBlock:(PPHttpRequestFailed)failureBlock{
    __weak typeof (self)weakSelf = self;
    MMJF_ShareV.number ++;
    MMJF_Log(@"%ld",MMJF_ShareV.number);
    if (MMJF_ShareV.number > 2) {
        NSDictionary *dic = @{@"msg":@"连接服务器失败"};
        MMJFBaseModel *baseModel = [MMJFBaseModel yy_modelWithJSON:dic];
        failureBlock ? failureBlock(baseModel) : nil;
    }else{
        MMJF_ShareV.queue.maxConcurrentOperationCount = 1;
        //创建任务
        NSBlockOperation *operationA = [NSBlockOperation blockOperationWithBlock:^{
            // 暂停queue
            [MMJF_ShareV.queue setSuspended:YES];
            //重新获取token
            [MMJF_NetworkShare v1getToken];
        }];
        NSBlockOperation *operationB = [NSBlockOperation blockOperationWithBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSString *strUrl;
                if (isImage == NO) {
                    strUrl = [url stringByReplacingOccurrencesOfString:@"(null)" withString:MMJF_ShareV.api_url ? MMJF_ShareV.api_url : @""];
                }else{
                    strUrl = [url stringByReplacingOccurrencesOfString:@"(null)" withString:MMJF_ShareV.image_url ? MMJF_ShareV.image_url : @""];
                }
                
                if (type == MMJFNetworkPOST) {
                    [weakSelf POST:strUrl isImage:isImage parameters:params isCache:isCache success:successBlock failure:failureBlock];
                }else{
                    [weakSelf GET:strUrl isImage:isImage parameters:params isCache:isCache success:successBlock failure:failureBlock];
                }
            }];
            
        }];
        //设置两个任务相互依赖
        // operationB 任务依赖于 operationA
        [operationB addDependency:operationA];
        //添加操作到队列中（自动异步执行任务，并发）
        [MMJF_ShareV.queue addOperation:operationA];
        [MMJF_ShareV.queue addOperation:operationB];
    }
}
#pragma mark - 上传文件
+ (NSURLSessionTask *)uploadFileWithURL:(NSString *)URL
                             parameters:(id)parameters
                                   name:(NSString *)name
                               filePath:(NSString *)filePath
                               progress:(PPHttpProgress)progress
                                success:(PPHttpRequestSuccess)success
                                failure:(PPHttpRequestFailed)failure {
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        if (_isOpenLog) {PPLog(@"responseObject = %@",responseObject);}
        [[self allSessionTask] removeObject:task];
        MMJFBaseModel *baseModel = [MMJFBaseModel yy_modelWithJSON:responseObject];
        if ([baseModel.status isEqualToString:@"200"]) {
            success ? success(baseModel) : nil;
        }else{
            failure ? failure(baseModel) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        if (_isOpenLog) {PPLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        NSDictionary *dic = @{@"msg":error.localizedDescription};
        MMJFBaseModel *baseModel = [MMJFBaseModel yy_modelWithJSON:dic];
        failure ? failure(baseModel) : nil;
//        MMJF_ShareV.errorStatus = error.localizedDescription;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 上传多张图片
+ (NSURLSessionTask *)uploadImagesWithURL:(NSString *)URL
                               parameters:(id)parameters
                                     name:(NSString *)name
                                   images:(NSArray<UIImage *> *)images
                                fileNames:(NSArray<NSString *> *)fileNames
                               imageScale:(CGFloat)imageScale
                                imageType:(NSString *)imageType
                                 progress:(PPHttpProgress)progress
                                  success:(PPHttpRequestSuccess)success
                                  failure:(PPHttpRequestFailed)failure {
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSUInteger i = 0; i < images.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ?: 1.f);
            UIImage *newImage = images[i];
            // 默认图片的文件名, 若fileNames为nil就使用
            if (imageData.length > kSnapshotImageDataLengthMax) {
                imageData = UIImageJPEGRepresentation(newImage, 0.5); // 压缩
                
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = NSStringFormat(@"%@%ld.%@",str,i,imageType?:@"jpg");
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileNames ? NSStringFormat(@"%@.%@",fileNames[i],imageType?:@"jpg") : imageFileName
                                    mimeType:NSStringFormat(@"image/%@",imageType ?: @"jpg")];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        if (_isOpenLog) {PPLog(@"responseObject = %@",responseObject);}
        MMJFBaseModel *baseModel = [MMJFBaseModel yy_modelWithJSON:responseObject];
        NSLog(@"%@",baseModel);
        [[self allSessionTask] removeObject:task];
        if ([baseModel.status isEqualToString:@"200"]) {
            success ? success(baseModel) : nil;
        }else{
           failure ? failure(baseModel) : nil;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        if (_isOpenLog) {PPLog(@"error = %@",error);}
        [[self allSessionTask] removeObject:task];
        NSDictionary *dic = @{@"msg":error.localizedDescription};
        MMJFBaseModel *baseModel = [MMJFBaseModel yy_modelWithJSON:dic];
        failure ? failure(baseModel) : nil;
//        MMJF_ShareV.errorStatus = error.localizedDescription;
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(PPHttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(PPHttpRequestFailed)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    __block NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        NSDictionary *dic = @{@"msg":error.localizedDescription};
        MMJFBaseModel *baseModel = [MMJFBaseModel yy_modelWithJSON:dic];
        if(failure && error) {failure(baseModel) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    //开始下载
    [downloadTask resume];
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    
    return downloadTask;
}

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - 初始化AFHTTPSessionManager相关属性
/**
 开始监测网络状态
 */
+ (void)load {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager
 *  原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 */
+ (void)initialize {
    _sessionManager = [AFHTTPSessionManager manager];
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    // 打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

#pragma mark - 重置AFHTTPSessionManager相关属性

+ (void)setAFHTTPSessionManagerProperty:(void (^)(AFHTTPSessionManager *))sessionManager {
    sessionManager ? sessionManager(_sessionManager) : nil;
}

+ (void)setRequestSerializer:(PPRequestSerializer)requestSerializer {
    _sessionManager.requestSerializer = requestSerializer==PPRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(PPResponseSerializer)responseSerializer {
    _sessionManager.responseSerializer = responseSerializer==PPResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)openNetworkActivityIndicator:(BOOL)open {
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:open];
}

+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName {
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    // 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果需要验证自建证书(无效证书)，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    // 是否需要验证域名，默认为YES;
    securityPolicy.validatesDomainName = validatesDomainName;
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    [_sessionManager setSecurityPolicy:securityPolicy];
}

#pragma mark--自定义
// 将JSON串转化为字典或者数组
+ (id)dictionaryWithJsonString:(NSData *)jsonData {
    if (jsonData == nil) {
        return nil;
    }
    NSError *err;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return jsonObject;
}
@end



