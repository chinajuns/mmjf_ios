//
//  ShareView.m
//  TYAlertControllerDemo
//
//  Created by tanyang on 15/10/26.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "ShareTabTwoView.h"
#import "UIView+TYAlertView.h"
#import "SelectedTabCell.h"

static NSString *const identify = @"SelectedTabCell";
@interface ShareTabTwoView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy)NSArray *dataSouce;

@property (nonatomic, strong)NSMutableDictionary *mutDict;

@end
@implementation ShareTabTwoView

- (void)setUpUI{
    self.listTab.dataSource = self;
    self.listTab.delegate = self;
    self.listTab.tableFooterView = [UIView new];
    if (self.chooseStr.length != 0) {
        self.determineBut.backgroundColor = MMJF_COLOR_Yellow;
        self.determineBut.userInteractionEnabled = YES;
    }else{
        self.determineBut.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        self.determineBut.userInteractionEnabled = NO;
    }
}

- (IBAction)cancelBut:(UIButton *)sender {
    [self hideView];
}

#pragma mark--UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSouce.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectedTabCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SelectedTabCell" owner:self options:nil]lastObject];
    }
    cell.titleLab.text = self.dataSouce[indexPath.section];
    NSString *str = [self.mutDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
    cell.selectedImg.hidden = YES;
    if (str.length != 0) {
        cell.titleLab.textColor = MMJF_COLOR_Yellow;
        cell.selectedImg.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.mutDict = [NSMutableDictionary dictionary];
    NSString *str = self.dataSouce[indexPath.section];
    self.chooseStr = str;
    [self.mutDict setObject:str forKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
    if (self.chooseStr.length != 0) {
        self.determineBut.backgroundColor = MMJF_COLOR_Yellow;
        self.determineBut.userInteractionEnabled = YES;
    }else{
        self.determineBut.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6"];
        self.determineBut.userInteractionEnabled = NO;
    }
    [self.listTab reloadData];
}

- (void)refresh:(NSArray *)array{
    self.dataSouce = array;
    [self.listTab reloadData];
}
@end
