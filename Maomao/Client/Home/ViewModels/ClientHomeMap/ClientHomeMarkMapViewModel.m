//
//  ClientHomeMarkMapViewModel.m
//  Maomao
//
//  Created by 御顺 on 2017/11/30.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientHomeMarkMapViewModel.h"
#import "MyAnimatedAnnotationView.h"
#import "ClientMapModel.h"

@interface ClientHomeMarkMapViewModel (){
    BMKPointAnnotation* pointAnnotation;
}
@property (nonatomic, strong)NSMutableArray *mutArray;
@property (nonatomic, copy)NSArray *mapArray;

@end
@implementation ClientHomeMarkMapViewModel

- (void)dealloc{
    [self.clickSubject sendCompleted];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutArray = [NSMutableArray array];
        self.clickSubject = [RACSubject subject];
    }
    return self;
}

//设置代理
- (void)setUpdelegate{
    _mapView.delegate = self;
    
}
//清楚代理
- (void)clearDelegate{
    _mapView.delegate = nil;
    
}

//绑定
- (void)bindViewToViewModel:(UIView *)view {
    _mapView = (BMKMapView *)view;
    
}

//添加标注
- (void)addPointAnnotation:(NSArray *)array
{
    self.mapView.delegate = nil;
    [_mapView removeOverlays:_mapView.overlays];
//    [_mapView removeAnnotations:_mapView.annotations];
    
    self.mapArray = array;
//    NSArray *sss = @[@"金牛区",@"锦江区",@"青羊区",@"成华区",@"高新区",@"新都区"];
    if (pointAnnotation == nil) {
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
        
    }
    MMJF_Log(@"%@",self.mutArray);
    _mapView.delegate = self;
    [_mapView addAnnotations:self.mutArray];
    //    [_mapView addAnnotation:pointAnnotation];
    
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    MMJF_Log(@"%@",annotation);
    //动画annotation
//    if (annotation == pointAnnotation) {
    
    
        NSString *AnnotationViewID = @"AnimatedAnnotation";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        }
//        NSMutableArray *images = [NSMutableArray array];
//        for (int i = 1; i < 4; i++) {
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"wei-xuan"]];
//            [images addObject:image];
//        }
        annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"wei-xuan"]];
//    NSString *str = annotation.title;
//    for (NSDictionary *dic in self.mapArray) {
//        ClientMapModel *model = [ClientMapModel yy_modelWithJSON:dic];
//        if ([model.name isEqualToString:str]) {
//            annotationView.counts = model.counts;
//        }
//    }
        return annotationView;
//    }
//    return nil;
}

/**
 *当选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    view.image = [UIImage imageNamed:@"yi-xuan1"];
    MMJF_Log(@"%@",view.annotation.title);
    NSArray *array = [view.annotation.subtitle componentsSeparatedByString:@","];
    NSDictionary *dic = @{@"title":view.annotation.title,@"ID":array[1]};
    [self.clickSubject sendNext:dic];
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param view 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    view.image = [UIImage imageNamed:@"wei-xuan"];
    NSDictionary *dic = @{@"title":@"取消"};
    [self.clickSubject sendNext:dic];
}

///**
// *点中底图空白处会回调此接口
// *@param mapView 地图View
// *@param coordinate 空白处坐标点的经纬度
// */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    NSDictionary *dic = @{@"title":@"全取消"};
    [self.clickSubject sendNext:dic];
}
@end
