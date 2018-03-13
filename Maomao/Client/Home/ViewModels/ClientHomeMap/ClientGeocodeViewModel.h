//
//  ClientGeocodeViewModel.h
//  Maomao
//
//  Created by 御顺 on 2018/1/9.
//  Copyright © 2018年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface ClientGeocodeViewModel : MMJFBaseViewModel<BMKMapViewDelegate, BMKGeoCodeSearchDelegate>{
    BMKMapView* _mapView;
    BMKGeoCodeSearch* _geocodesearch;
    bool isGeoSearch; 
}
/**
 编码
 */
@property (nonatomic, strong)RACSubject *geoCodeSubject;
//设置代理
- (void)setUpdelegate;
//清楚代理
- (void)clearDelegate;

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
