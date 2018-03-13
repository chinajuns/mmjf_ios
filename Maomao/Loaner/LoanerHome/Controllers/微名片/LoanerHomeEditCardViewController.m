//
//  LoanerHomeEditCardViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/11.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerHomeEditCardViewController.h"
#import "LoanerHomeEditCardViewModel.h"

@interface LoanerHomeEditCardViewController ()
@property (weak, nonatomic) IBOutlet UITableView *loanerTab;

@property (nonatomic, strong)LoanerHomeEditCardViewModel *editCardViewModel;
@end

@implementation LoanerHomeEditCardViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑名片";
    [self setUpEditCard];
}

- (void)setUpEditCard{
    [self.editCardViewModel bindViewToViewModel:self.loanerTab];
}

- (LoanerHomeEditCardViewModel *)editCardViewModel{
    if (!_editCardViewModel) {
        _editCardViewModel = [[LoanerHomeEditCardViewModel alloc]init];
    }
    return _editCardViewModel;
}

@end
