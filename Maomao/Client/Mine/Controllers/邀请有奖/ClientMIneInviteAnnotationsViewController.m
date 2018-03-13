//
//  ClientMIneInviteAnnotationsViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/6.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientMIneInviteAnnotationsViewController.h"

@interface ClientMIneInviteAnnotationsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cotentLab;
@end

@implementation ClientMIneInviteAnnotationsViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.cotentLab.text];
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#33abff"]};
    [attrString setAttributes:attributes range:[self.cotentLab.text rangeOfString:@"详情咨询：400-123-14252"]];
    self.cotentLab.attributedText = attrString;
}

- (IBAction)backView:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
