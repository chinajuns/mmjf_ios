//
//  ClientRegisteredViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/11/25.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientRegisteredViewModel : NSObject
//注册
@property(nonatomic, strong) RACCommand   *registereCommand;
@end
