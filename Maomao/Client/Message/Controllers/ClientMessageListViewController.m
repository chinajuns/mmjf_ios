//
//  ClientMessageListViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMessageListViewController.h"
#import "ClientMessageListViewModel.h"
#import "UITabBar+badge.h"

@interface ClientMessageListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *messagetab;

@property (nonatomic, strong)ClientMessageListViewModel *messageListViewModel;

@end

@implementation ClientMessageListViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.messageListViewModel.number = _number;
    [self.messageListViewModel.netWorkViewModel.checkNoticeCommand execute:nil];
    [self setUpMessageListView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self check];
}

- (void)check{
    //未读消息检查
    __weak typeof(self)weakSelf = self; [self.messageListViewModel.netWorkViewModel.checkNoticeCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSString *str = [NSString stringWithFormat:@"%@",x[@"no_read"]];
        if ([str isEqualToString:@"1"]) {
            //进入就设置消息的小红点
            [weakSelf.tabBarController.tabBar showBadgeOnItmIndex:3];
        }else{
            //进入就设置消息的小红点
            [weakSelf.tabBarController.tabBar hideBadgeOnItemIndex:3];
        }
    }];
}

- (void)setUpMessageListView{
    [self.messageListViewModel bindViewToViewModel:self.messagetab];
}

- (ClientMessageListViewModel *)messageListViewModel{
    if (!_messageListViewModel) {
        _messageListViewModel = [[ClientMessageListViewModel alloc]init];
    }
    return _messageListViewModel;
}

@end
