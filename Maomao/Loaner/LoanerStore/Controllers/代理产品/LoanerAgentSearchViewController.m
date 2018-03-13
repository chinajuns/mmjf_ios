//
//  LoanerAgentSearchViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/13.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerAgentSearchViewController.h"
#import "LoanerAgentSearchViewModel.h"
#import "LoanerStoreNetWorkViewModel.h"

@interface LoanerAgentSearchViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UITableView *listTab;

@property (nonatomic, strong)LoanerAgentSearchViewModel *agentViewModel;

@property (nonatomic, strong)LoanerStoreNetWorkViewModel *netWorkViewModel;
@end

@implementation LoanerAgentSearchViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAgentViewModel];
    [self setUpSearchText];
    [self setUpNetWork];
}

- (IBAction)cancelBut:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpSearchText{
    UIImage *im = [UIImage imageNamed:@"sou-suo-1"];
    UIImageView *iv = [[UIImageView alloc] initWithImage:im];
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    iv.center = lv.center;
    [lv addSubview:iv];
    self.searchText.leftViewMode = UITextFieldViewModeUnlessEditing;
    self.searchText.leftView = lv;
    self.searchText.delegate = self;
    self.searchText.returnKeyType = UIReturnKeySearch;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([NSString hasEmoji:textField.text] || [NSString stringContainsEmoji:textField.text]) {
        [MBProgressHUD showError:@"不支持输入表情"];
        return;
    }
    NSDictionary *dic = @{@"keyword":textField.text};
    [self.netWorkViewModel.myProductCommand execute:dic];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //不支持系统表情的输入
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        [MBProgressHUD showError:@"不支持输入表情"];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self.searchText resignFirstResponder];
  return YES;
}

- (void)setAgentViewModel{
    [self.agentViewModel bindViewToViewModel:self.listTab];
}

- (void)setUpNetWork{
    __weak typeof(self)weakSelf = self;
    [self.netWorkViewModel.myProductCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        MMJF_Log(@"%@",x);
        [weakSelf.agentViewModel refresh:x[@"product"]];
    }];
    
}

- (LoanerAgentSearchViewModel *)agentViewModel{
    if (!_agentViewModel) {
        _agentViewModel = [[LoanerAgentSearchViewModel alloc]init];
    }
    return _agentViewModel;
}

- (LoanerStoreNetWorkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[LoanerStoreNetWorkViewModel alloc]init];
    }
    return _netWorkViewModel;
}

@end
