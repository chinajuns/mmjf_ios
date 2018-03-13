//
//  LoanerShareEditorViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerShareEditorViewController.h"
#import "LoanerShareEditorViewModel.h"

@interface LoanerShareEditorViewController ()
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic, strong)LoanerShareEditorViewModel *shareEditorViewModel;
@end

@implementation LoanerShareEditorViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑店铺";
    [self setUpShareEditorViewModel];
}
//保存
- (IBAction)saveBut:(UIButton *)sender {
}

- (void)setUpShareEditorViewModel{
    [self.shareEditorViewModel bindViewToViewModel:self.listTab];
}

- (LoanerShareEditorViewModel *)shareEditorViewModel{
    if (!_shareEditorViewModel) {
        _shareEditorViewModel = [[LoanerShareEditorViewModel alloc]init];
    }
    return _shareEditorViewModel;
}
@end
