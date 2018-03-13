//
//  LoanerRegisteredViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/23.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "LoanerRegisteredViewController.h"
#import "RegisteredCardView.h"

@interface LoanerRegisteredViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;

@end

@implementation LoanerRegisteredViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.backView.layer setShadow:6 opacity:1 color:[UIColor colorWithRed:245.0f/255.0f green:143.0f/255.0f blue:0.0f/255.0f alpha:0.7f] shadowRadius:12 shadowOffset:CGSizeMake(2, 3)];
    RegisteredCardView * card = [[[NSBundle mainBundle]loadNibNamed:@"RegisteredCardView" owner:self options:nil] lastObject];
    card.frame = self.backView.bounds;
    [self.backView addSubview:card];
    if (MMJF_HEIGHT > 800) {
        self.topLine.constant = 52;
    }
}

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
