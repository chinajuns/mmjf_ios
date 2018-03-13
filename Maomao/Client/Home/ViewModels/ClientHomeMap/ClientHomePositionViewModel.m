//
//  MMJFHomePositionViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/11/1.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomePositionViewModel.h"
@interface ClientHomePositionViewModel ()

@end
@implementation ClientHomePositionViewModel

- (void)dealloc{
    [self.positionSubject sendCompleted];
    [self.locationSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        /* 创建信号 */
        _positionSubject = [RACSubject subject];
        _locationSubject = [RACSubject subject];
        _locService = [[BMKLocationService alloc]init];
        //初始化离线地图服务
//        _offlineMap = [[BMKOfflineMap alloc]init];
    }
    return self;
}
//绑定
- (void)bindViewToViewModel:(UIView *)view {
    _mapView = (BMKMapView *)view;
    _mapView.zoomLevel = 12;//地图的级别
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(30.674498, 104.069978)];
    //开启定位
    [self startLocation];
}
//设置代理
- (void)setUpdelegate{
    _locService.delegate = self;
    _mapView.delegate = self;
}
//清楚代理
- (void)clearDelegate{
    _locService.delegate = nil;
    _mapView.delegate = nil;
    
}
//开始定位
- (void)startLocation{
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}
//跟随状态
- (void)startFollowing{
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;
}
//罗盘状态
- (void)startFollowHeading{
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    _mapView.showsUserLocation = YES;
}
//停止定位
- (void)stopLocation{
    [_locService stopUserLocationService];
    _mapView.showsUserLocation = NO;
}

/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    MMJF_Log(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    MMJF_Log(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    MMJF_ShareV.lat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    MMJF_ShareV.lng = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __weak typeof(self)weakSelf = self;
    [geocoder reverseGeocodeLocation: userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            [_locService stopUserLocationService];
            CLPlacemark *placemark = [array objectAtIndex:0];
            if (placemark != nil) {
                MMJF_Log(@"%@",placemark.addressDictionary);
                //省
                NSString *province = placemark.administrativeArea;
                //市
                NSString *city = placemark.locality;
                if (!city) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    city = placemark.administrativeArea;
                }
                //区
                NSString *area = placemark.subLocality;
                //街道
                NSString *stree = placemark.thoroughfare;
                //街道编码
                NSString *streetCode = placemark.subThoroughfare;
                
//                weakSelf.addressStr = placemark.name;
//                [weakSelf setButtonAround];
//                
//
//                NSLog(@"当前城市名称------%@",city);
//                [weakSelf.leftButton2 setTitle:city forState:UIControlStateNormal];
                
//                NSArray* records = [_offlineMap searchCity:city];
//                BMKOLSearchRecord* oneRecord = [records objectAtIndex:0];
                [weakSelf.locationSubject sendNext:placemark.addressDictionary];
                //城市编码如:北京为131
                NSString *cityId = placemark.postalCode;
                
                MMJF_Log(@"当前城市编号-------->%zd",cityId);
                if ([MMJF_DEFAULTS objectForKey:@"users"][@"cusno"] && cityId.length != 0) {
                    NSDictionary *dic = @{@"cusno":[NSString stringWithFormat:@"%@",[MMJF_DEFAULTS objectForKey:@"users"][@"cusno"]],@"type":@"2",@"province":province ? province : @"",@"city":city ? city : @"",@"area":area ? area : @"",@"citycode":cityId ? cityId : @"",@"street":stree ? stree : @"",@"streetcode":streetCode ? streetCode : @"",@"lng":MMJF_ShareV.lng,@"lat":MMJF_ShareV.lat};
                    MMJF_Log(@"%@",dic);
//                    [MMJF_NetworkShare AddressUpdateDidChange:dic successBlock:^(id object) {
//
//                    } failure:^(id object) {
//
//                    }];
                }
            
            }
        }
    }];
    
    /* 发送信号 */
    [_positionSubject sendNext:@"successful"];
    [_mapView updateLocationData:userLocation];
}


/**
 *在地图View停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
   
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [_positionSubject sendNext:@"failure"];
}

@end
