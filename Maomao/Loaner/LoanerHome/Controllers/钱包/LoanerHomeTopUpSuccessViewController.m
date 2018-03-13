//
//  LoanerHomeTopUpSuccessViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/14.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerHomeTopUpSuccessViewController.h"

@interface LoanerHomeTopUpSuccessViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cotnet;

@property (nonatomic, copy)NSString *content;
@end

@implementation LoanerHomeTopUpSuccessViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值成功";
    [self setAttr:self.cotnet.text];
    __block NSInteger index = 5;
    __weak typeof(self)weakSelf = self;
    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] take:index] subscribeNext:^(id x) {
        
        index --;
        weakSelf.content = [NSString stringWithFormat:@"预计3-5天以内到账，%ldS后自动跳转至上一页面",index];
        [weakSelf setAttr:weakSelf.content];
        if (index <= 0) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
}

- (void)setAttr:(NSString *)str{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#33abff"]};
    [attrString setAttributes:attributes1 range:NSMakeRange(11, 2)];
    self.cotnet.attributedText = attrString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
