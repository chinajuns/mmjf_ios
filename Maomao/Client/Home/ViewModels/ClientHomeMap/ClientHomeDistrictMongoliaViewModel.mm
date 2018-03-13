//
//  DistrictSearchDemoViewController.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 16/1/13.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "ClientHomeDistrictMongoliaViewModel.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "MyAnimatedAnnotationView.h"
#import "ClientMapModel.h"

@interface ClientHomeDistrictMongoliaViewModel ()<BMKDistrictSearchDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate> {
    BMKDistrictSearch *_districtSearch;
    BMKMapView *_mapView;
    BMKPointAnnotation* pointAnnotation;
    BMKGeoCodeSearch* _geocodesearch;
    bool isGeoSearch; 
}
@property (nonatomic, strong)NSMutableArray *mutArray;
@property (nonatomic, copy)NSArray *mapArray;

@property (nonatomic, strong)BMKPointAnnotation* item;


@end

@implementation ClientHomeDistrictMongoliaViewModel

- (void)dealloc{
    [self.retrieveSubject sendCompleted];
    [self.mapclickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _districtSearch = [[BMKDistrictSearch alloc] init];
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        self.retrieveSubject = [RACSubject subject];
        self.mapclickSubject = [RACSubject subject];
        self.geoCodeSubject = [RACSubject subject];
    }
    return self;
}

//设置代理
- (void)setUpdelegate{
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _districtSearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
//清楚代理
- (void)clearDelegate{
    _mapView.delegate = nil;
    _districtSearch.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil; // 不用时，置nil
}

//绑定
- (void)bindViewToViewModel:(UIView *)view {
    _mapView = (BMKMapView *)view;
    
}
//检查行政区
- (void)districtSearch:(NSString *)area {
    BMKDistrictSearchOption *option = [[BMKDistrictSearchOption alloc] init];
    option.city = area;
    //    option.district = _districtField.text;
    BOOL flag = [_districtSearch districtSearch:option];
    if (flag) {
        MMJF_Log(@"district检索发送成功");
        self.isRegion = YES;
    } else {
        MMJF_Log(@"district检索发送失败");
    }
}

/**
 *返回行政区域搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结BMKDistrictSearch果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetDistrictResult:(BMKDistrictSearch *)searcher result:(BMKDistrictResult *)result errorCode:(BMKSearchErrorCode)error {
    MMJF_Log(@"onGetDistrictResult error: %d", error);
    NSArray *overlayArray = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:overlayArray];
    if (error == BMK_SEARCH_NO_ERROR) {
        MMJF_Log(@"\nname:%@\ncode:%d\ncenter latlon:%lf,%lf", result.name, (int)result.code, result.center.latitude, result.center.longitude);
        
        BOOL flag = YES;
        for (NSString *path in result.paths) {
            BMKPolygon* polygon = [self transferPathStringToPolygon:path];
            if (polygon) {
                [_mapView addOverlay:polygon]; // 添加overlay
                if (flag) {
                    [self mapViewFitPolygon:polygon];
                    flag = NO;
                }
            }
        }
        
    }else{
        [self.retrieveSubject sendNext:@""];
        [MBProgressHUD showError:@"检索失败"];
        
    }
}
//3
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]]) {
        BMKPolygonView *polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.6];
        polygonView.fillColor = [UIColor colorWithRed:255.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:0.3];
        polygonView.lineWidth = 0.5;
//        polygonView.lineDash = YES;
        [self.retrieveSubject sendNext:@""];
        return polygonView;
    }
    [self.retrieveSubject sendNext:@""];
    return nil;
}

//移除
- (void)remove{
    NSArray *overlayArray = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:overlayArray];
}


//根据polygone设置地图范围  2
- (void)mapViewFitPolygon:(BMKPolygon *) polygon {
    CGFloat leftTopX, leftTopY, rightBottomX, rightBottomY;
    if (polygon.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polygon.points[0];
    // 左上角顶点
    leftTopX = pt.x;
    leftTopY = pt.y;
    // 右下角顶点
    rightBottomX = pt.x;
    rightBottomY = pt.y;
    for (int i = 1; i < polygon.pointCount; i++) {
        BMKMapPoint pt = polygon.points[i];
        leftTopX = pt.x < leftTopX ? pt.x : leftTopX;
        leftTopY = pt.y < leftTopY ? pt.y : leftTopY;
        rightBottomX = pt.x > rightBottomX ? pt.x : rightBottomX;
        rightBottomY = pt.y > rightBottomY ? pt.y : rightBottomY;
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(leftTopX, leftTopY);
    rect.size = BMKMapSizeMake(rightBottomX - leftTopX, rightBottomY - leftTopY);
    UIEdgeInsets padding = UIEdgeInsetsMake(30, 0, 100, 0);
    BMKMapRect fitRect = [_mapView mapRectThatFits:rect edgePadding:padding];
    [_mapView setVisibleMapRect:fitRect];
}
//1
- (BMKPolygon*)transferPathStringToPolygon:(NSString*) path {
    if (path == nil || path.length < 1) {
        return nil;
    }
    NSArray *pts = [path componentsSeparatedByString:@";"];
    if (pts == nil || pts.count < 1) {
        return nil;
    }
    BMKMapPoint *points = new BMKMapPoint[pts.count];
    NSInteger index = 0;
    for (NSString *ptStr in pts) {
        if (ptStr && [ptStr rangeOfString:@","].location != NSNotFound) {
            NSRange range = [ptStr rangeOfString:@","];
            NSString *xStr = [ptStr substringWithRange:NSMakeRange(0, range.location)];
            NSString *yStr = [ptStr substringWithRange:NSMakeRange(range.location + range.length, ptStr.length - range.location - range.length)];
            if (xStr && xStr.length > 0 && [xStr respondsToSelector:@selector(doubleValue)]
                && yStr && yStr.length > 0 && [yStr respondsToSelector:@selector(doubleValue)]) {
                points[index] = BMKMapPointMake(xStr.doubleValue, yStr.doubleValue);
                index++;
            }
        }
    }
    BMKPolygon *polygon = nil;
    if (index > 0) {
        polygon = [BMKPolygon polygonWithPoints:points count:index];
    }
    delete [] points;
    return polygon;
}

#pragma mark--标注
//添加标注
- (void)addPointAnnotation:(NSArray *)array
{
    if (self.isRegion == NO) {
        [_mapView removeAnnotations:self.mutArray];
        [_mapView removeOverlays:_mapView.overlays];
        self.mutArray = [NSMutableArray array];
        self.mapArray = array;
        //    NSArray *sss = @[@"金牛区",@"锦江区",@"青羊区",@"成华区",@"高新区",@"新都区"];
        for (int i = 0; i < array.count; i ++) {
            NSDictionary *dic = array[i];
            ClientMapModel *model = [ClientMapModel yy_modelWithJSON:dic];
            NSString *str = [NSString stringWithFormat:@"%@",model.counts];
            if ([str isEqualToString:@"0"]) {
                break;
            }
            pointAnnotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [model.lat floatValue];
            coor.longitude = [model.lng floatValue];
            pointAnnotation.coordinate = coor;
            pointAnnotation.title = [NSString stringWithFormat:@"%@",model.name];
            pointAnnotation.subtitle = [NSString stringWithFormat:@"%@,%@",model.counts,model.Id];
            [self.mutArray addObject:pointAnnotation];
        }
        MMJF_Log(@"%@",self.mutArray);
        [_mapView addAnnotations:self.mutArray];
    }
    self.isMark = NO;
    
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    MMJF_Log(@"%@",annotation);
//    if (self.isMark == YES) {
//        NSString *AnnotationViewID = @"annotationViewID";
//        //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
//        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//        if (annotationView == nil) {
//            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//            ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
//            ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
//        }
//
//        annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
//        annotationView.annotation = annotation;
//        annotationView.canShowCallout = NO;
//        return annotationView;
//    }
//    else{
        NSString *AnnotationViewID = @"AnimatedAnnotation";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
        annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"wei-xuan"]];
        return annotationView;
//    }

}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    if ([view.annotation.subtitle isEqualToString:@"s"]) {
        return;
    }
    self.isRegion = YES;
//    self.isMark = NO;
    view.image = [UIImage imageNamed:@"yi-xuan1"];
    MMJF_Log(@"%@",view.annotation.title);
    NSArray *array = [view.annotation.subtitle componentsSeparatedByString:@","];
    NSDictionary *dic = @{@"title":view.annotation.title,@"ID":array[1]};
    [self.mapclickSubject sendNext:dic];
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    if ([view.annotation.subtitle isEqualToString:@"s"]) {
        return;
    }
    self.isRegion = YES;
    view.image = [UIImage imageNamed:@"wei-xuan"];
    NSDictionary *dic = @{@"title":@"取消"};
    [self.mapclickSubject sendNext:dic];
}

///**
// *点中底图空白处会回调此接口
// *@param mapView 地图View
// *@param coordinate 空白处坐标点的经纬度
// */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    NSDictionary *dic = @{@"title":@"全取消"};
    self.isRegion = NO;
    [self remove];
    [self.mapclickSubject sendNext:dic];
}

#pragma mark--编码

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    [_mapView removeAnnotation:self.item];
    if (error == 0) {
//        self.isMark = YES;
//        self.item.coordinate = result.location;
//        self.item.title = result.address;
//        self.item.subtitle = @"s";
//        [_mapView addAnnotation:self.item];
        _mapView.centerCoordinate = result.location;
        
        NSDictionary *dic = @{@"lng":[NSString stringWithFormat:@"%f",self.item.coordinate.longitude],@"lat":[NSString stringWithFormat:@"%f",self.item.coordinate.latitude]};
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

- (BMKPointAnnotation *)item{
    if (!_item) {
        _item = [[BMKPointAnnotation alloc]init];
    }
    return _item;
}

@end
