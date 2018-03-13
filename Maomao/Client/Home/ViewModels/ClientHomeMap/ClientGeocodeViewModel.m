//
//  ClientGeocodeViewModel.m
//  Maomao
//
//  Created by 御顺 on 2018/1/9.
//  Copyright © 2018年 御顺. All rights reserved.
//

#import "ClientGeocodeViewModel.h"

@implementation ClientGeocodeViewModel

- (void)dealloc
{
    [self.geoCodeSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.geoCodeSubject = [RACSubject subject];
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    }
    return self;
}

//绑定
- (void)bindViewToViewModel:(UIView *)view {
    _mapView = (BMKMapView *)view;
}

//设置代理
- (void)setUpdelegate{
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
//清楚代理
- (void)clearDelegate{
    _mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil; // 不用时，置nil
}

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSDictionary *dic = @{@"lng":[NSString stringWithFormat:@"%f",item.coordinate.longitude],@"lat":[NSString stringWithFormat:@"%f",item.coordinate.latitude]};
        [self.geoCodeSubject sendNext:dic];
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}
//反向编码
-(void)onClickReverseGeocode:(NSString *)lng lat:(NSString *)lat
{
    isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (lng != nil && lat != nil) {
        pt = (CLLocationCoordinate2D){[lat floatValue], [lng floatValue]};
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        MMJF_Log(@"反geo检索发送成功");
    }
    else
    {
        MMJF_Log(@"反geo检索发送失败");
        [self.geoCodeSubject sendNext:@""];
    }
    
}
//正向编码
-(void)onClickGeocode:(NSString *)cityStr
{
    isGeoSearch = true;
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= @"";
    geocodeSearchOption.address = cityStr;
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        MMJF_Log(@"geo检索发送成功");
    }
    else
    {
        MMJF_Log(@"geo检索发送失败");
    }
    
}
@end
