//
//  DistrictSearchDemoViewController.h
//  IphoneMapSdkDemo
//
//  Created by wzy on 16/1/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#ifndef DistrictSearchDemoViewController_h
#define DistrictSearchDemoViewController_h

#import <UIKit/UIKit.h>

@interface ClientHomeDistrictMongoliaViewModel : MMJFBaseViewModel
//行政区
@property (nonatomic, strong)RACSubject *retrieveSubject;
@property (nonatomic, strong)RACSubject *mapclickSubject;
/**
 编码
 */
@property (nonatomic, strong)RACSubject *geoCodeSubject;

/**
 划分行政区YES
 */
@property (nonatomic, assign)BOOL isRegion;
@property (nonatomic, assign)BOOL isMark;
//设置代理
- (void)setUpdelegate;
//清楚代理
- (void)clearDelegate;
//移除
- (void)remove;

/**
 检查行政区

 @param area 行政区
 */
- (void)districtSearch:(NSString *)area;

/**
 添加标注
 */
- (void)addPointAnnotation:(NSArray *)array;

/**
 正向编码
 
 @param cityStr 城市
 */
-(void)onClickGeocode:(NSString *)cityStr;

/**
 反向编码
 
 @param lng 经度
 @param lat 纬度
 */
-(void)onClickReverseGeocode:(NSString *)lng lat:(NSString *)lat;
@end

#endif /* DistrictSearchDemoViewController_h */
