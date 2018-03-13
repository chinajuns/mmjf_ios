//
//  ClientLogCardViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/11/24.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClientPublicBaseViewModel.h"

@interface ClientLogCardViewModel : ClientPublicBaseViewModel

@property(nonatomic, strong) RACCommand   *loginCommand;

@end
