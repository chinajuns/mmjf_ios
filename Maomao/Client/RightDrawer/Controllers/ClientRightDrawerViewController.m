//
//  ClientRightDrawerViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/17.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientRightDrawerViewController.h"
#import "ClientRightDrawerViewModel.h"

@interface ClientRightDrawerViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine;
@property (nonatomic, strong)ClientRightDrawerViewModel *rightDrawerViewModel;
@end

@implementation ClientRightDrawerViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(MMJF_WIDTH* 0.7, MMJF_HEIGHT);
    [self setUpRightDrawerViewModel];
    if (MMJF_HEIGHT > 800) {
        self.bottomLine.constant = 22;
    }
}

///设置viewModel
- (void)setUpRightDrawerViewModel{
    [self.rightDrawerViewModel bindViewToViewModel:self.collectionView];
    [self.rightDrawerViewModel.clientAttrConfigCommand execute:nil];
}
- (IBAction)bottomBut:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.rightDrawerViewModel emptyChoose];
    }else{
        [self.viewDeckController closeSide:YES];
        NSDictionary *dic = [self.rightDrawerViewModel getScreeningIds];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ClientRightDrawerViewController" object:nil userInfo:dic];
    }
}

#pragma mark--getter
- (ClientRightDrawerViewModel *)rightDrawerViewModel{
    if (!_rightDrawerViewModel) {
        _rightDrawerViewModel = [[ClientRightDrawerViewModel alloc]init];
    }
    return _rightDrawerViewModel;
}

@end
