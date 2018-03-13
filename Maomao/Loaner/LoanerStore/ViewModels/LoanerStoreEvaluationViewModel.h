//
//  LoanerStoreEvaluationViewModel.h
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "MMJFBaseViewModel.h"

@interface LoanerStoreEvaluationViewModel : MMJFBaseViewModel

//刷新标签
- (void)refreshTag:(NSArray *)array;

/**
 B端：店铺-客户订单-评价提交
 */
@property (nonatomic, strong)RACSubject *orderCommentSubject;
@end
