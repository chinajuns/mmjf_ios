//
//  ClientEvaluationOfViewController.m
//  Maomao
//
//  Created by 御顺 on 2017/12/4.
//  Copyright © 2017年 御顺. All rights reserved.
//

#import "ClientEvaluationOfViewController.h"
#import "ClientHomeEvaluationTopViewModel.h"

@interface ClientEvaluationOfViewController ()
@property (weak, nonatomic) IBOutlet UITableView *evaluationTab;

@property (nonatomic, strong)ClientHomeEvaluationTopViewModel *evaluationViewModel;
@end

@implementation ClientEvaluationOfViewController

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    MMJF_Log(@"%ld",self.number);
    if (self.number == 1) {
        self.number = 3;
    }else if (self.number == 2){
        self.number = 4;
    }else if (self.number == 3){
        self.number = 5;
    }
    NSDictionary *dic = @{@"id":self.Id,@"type":[NSString stringWithFormat:@"%ld",self.number]};
    [self.evaluationViewModel setUpData:dic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpEvaluationViewModel];
}

- (void)setUpEvaluationViewModel{
    [self.evaluationViewModel bindViewToViewModel:self.evaluationTab];
}

- (ClientHomeEvaluationTopViewModel *)evaluationViewModel{
    if (!_evaluationViewModel) {
        _evaluationViewModel = [[ClientHomeEvaluationTopViewModel alloc]init];
    }
    return _evaluationViewModel;
}

@end
