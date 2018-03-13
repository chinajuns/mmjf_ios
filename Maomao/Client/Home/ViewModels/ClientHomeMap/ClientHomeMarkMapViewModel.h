//
//  ClientHomeMarkMapViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/11/30.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface ClientHomeMarkMapViewModel : MMJFBaseViewModel<BMKMapViewDelegate>{
    
}

@property (nonatomic, strong)BMKMapView* mapView;

@property (nonatomic, strong)RACSubject *clickSubject;

//@property (nonatomic, strong)RACSubject *clickSubject;
//设置代理
- (void)setUpdelegate;
//去除代理
- (void)clearDelegate;

- (void)addPointAnnotation:(NSArray *)array;
@end
