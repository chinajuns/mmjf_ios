//
//  ViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/11/15.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ViewController.h"
#import "MMJFtokenModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    MMJF_Log(@"token%@",MMJF_ShareV.token);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [PPNetworkHelper netWork:MMJFNetworkPOST URl:@"" parameters:nil isCache:NO success:^(MMJFBaseModel *baseModel) {
//        NSLog(@"w%@",baseModel.data);
//    } failure:^(MMJFBaseModel *baseModel) {
//        NSLog(@"w%@",baseModel.data);
//    }];
//    NSLog(@"token%@",MMJF_ShareV.token);
//    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
