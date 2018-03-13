//
//  ClientMineFeedbackViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/7.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMineFeedbackViewController.h"
#import "CMInputView.h"
#import "ClientMineNetworkViewModel.h"

@interface ClientMineFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UIView *textView;

@property (weak, nonatomic) IBOutlet UILabel *statisticalLab;

@property (nonatomic, strong)ClientMineNetworkViewModel *netWorkViewModel;

@property (weak, nonatomic) IBOutlet UIButton *submitBut;
@property (nonatomic, strong)CMInputView *input;
@property (nonatomic, copy)NSString *textStr;
@end

@implementation ClientMineFeedbackViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.submitBut.userInteractionEnabled = NO;
    [self setUpText];
}

- (void)setUpText{
    _input = [[CMInputView alloc]initWithFrame:self.textView.bounds];
    
    _input.font = [UIFont fontWithName:@"PingFang SC" size:12];
    _input.placeholder = @"请对我的服务做评价";
    _input.maxNumber = 100;
    //_inputView.placeholderFont = [UIFont systemFontOfSize:22];
    __weak typeof(self)weakSelf = self;
    _input.text = self.textStr;
    // 设置文本框最大行
    self.statisticalLab.text = [NSString stringWithFormat:@"%ld/%d",self.textStr.length,100];
    // 设置文本框最大行
    [_input textValueDidChanged:^(NSString *text, CGFloat textHeight) {
        if (textHeight > 162) {
            CGRect frame = weakSelf.input.frame;
            frame.size.height = textHeight;
            weakSelf.input.frame = frame;
        }
        weakSelf.textStr = text;
        //限制输入必须大于9个字
        if (text.length > 9) {
            weakSelf.submitBut.backgroundColor = MMJF_COLOR_Yellow;
            weakSelf.submitBut.userInteractionEnabled = YES;
        }else{
            weakSelf.submitBut.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
            weakSelf.submitBut.userInteractionEnabled = NO;
        }
        weakSelf.statisticalLab.text = [NSString stringWithFormat:@"%ld/%d",text.length,100];
    }];
    
    _input.maxNumberOfLines = 7;
    [self.textView addSubview:_input];
    
    [self.netWorkViewModel.feedbackCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [MBProgressHUD showSuccess:@"提交成功"];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}
//提交
- (IBAction)submitBut:(UIButton *)sender {
    [self.view endEditing:YES];
    NSDictionary *dic = @{@"comment":self.input.text};
    [self.netWorkViewModel.feedbackCommand execute:dic];
}

- (ClientMineNetworkViewModel *)netWorkViewModel{
    if (!_netWorkViewModel) {
        _netWorkViewModel = [[ClientMineNetworkViewModel alloc]init];
    }
    return _netWorkViewModel;
}

@end
