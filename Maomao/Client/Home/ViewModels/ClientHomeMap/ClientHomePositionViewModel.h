//
//  MMJFHomePositionViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/11/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface ClientHomePositionViewModel : MMJFBaseViewModel<BMKLocationServiceDelegate,BMKMapViewDelegate>{
    BMKLocationService* _locService;
    BMKMapView* _mapView;
    BMKOfflineMap* _offlineMap;
}
//定位信号
@property (nonatomic, strong)RACSubject *positionSubject;

/**
 我的位置信号
 */
@property (nonatomic, strong)RACSubject *locationSubject;

//设置代理
- (void)setUpdelegate;
//清楚代理
- (void)clearDelegate;
//开始定位
- (void)startLocation;
//跟随状态
- (void)startFollowing;
//罗盘状态
- (void)startFollowHeading;
//停止定位
- (void)stopLocation;
@end
