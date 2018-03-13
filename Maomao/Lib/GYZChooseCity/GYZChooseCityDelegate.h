//
//  GYZChooseCityDelegate.h
//  GYZChooseCityDemo
//  选择城市相关delegate
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

@class GYZCity;
@class GYZChooseCityController;

@protocol GYZChooseCityDelegate <NSObject>

- (void) cityPickerController:(GYZChooseCityController *)chooseCityController
                didSelectCity:(GYZCity *)city;

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController;
//点击取消
- (void)cancel:(GYZChooseCityController *)cancel;
@end

@protocol GYZCityGroupCellDelegate <NSObject>

- (void) cityGroupCellDidSelectCity:(GYZCity *)city;

@end
