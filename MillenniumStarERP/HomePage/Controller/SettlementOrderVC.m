//
//  SettlementOrderVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementOrderVC.h"
#import "SettlementHeadInfo.h"
#import "SettlementListInfo.h"
#import "SettlementSecHedView.h"
#import "SettlementHeadView.h"
#import "SettlementTableCell.h"
#import "SettlementFootView.h"
@interface SettlementOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak,  nonatomic) IBOutlet UITableView *settlementTab;
@property (nonatomic,strong) NSArray *listArr;
@property (nonatomic,  weak) SettlementHeadView *delHView;
@property (nonatomic,  weak) SettlementFootView *delFView;
@end

@implementation SettlementOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算单";
    [self setBaseView];
}

- (void)setBaseView{
    self.settlementTab.backgroundColor = DefaultColor;
    
    SettlementListInfo *info = [SettlementListInfo new];
    info.titles =  @[@[@"品名",@"净金重",@"损耗",@"金价",@"金额"],@[@"男戒",@"0.16",@"0.56",@"293.6",@"56301.0"],@[@"男戒",@"0.16",@"0.56",@"293.6",@"56301.0"],@[@"男戒",@"0.16",@"0.56",@"293.6",@"56301.0"],@[@"男戒",@"0.16",@"0.56",@"293.6",@"56301.0"],@[@"小计",@"0.16",@"",@"",@"56301.0"]];
    SettlementListInfo *info1 = [SettlementListInfo new];
    info1.titles = @[@[@"品名",@"件数",@"单件工费",@"超额工费",@"起版费",@"金额"],@[@"男戒",@"0.16",@"0.56",@"293.6",@"293.6",@"56301.0"],@[@"小计",@"2",@"",@"0.16",@"0.56",@"56301.0"]];
    SettlementListInfo *info2 = [SettlementListInfo new];
    info2.titles = @[@[@"品名",@"数量",@"工费",@"金额"],@[@"男戒",@"0.16",@"0.56",@"56301.0"],@[@"小计",@"",@"0.56",@"56301.0"]];
    self.listArr = @[info,info1,info2];
    
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 130)];
    headV.backgroundColor = DefaultColor;
    SettlementHeadView *headView = [SettlementHeadView createHeadView];
    [headV addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headV).offset(0);
        make.bottom.equalTo(headV).offset(-10);
        make.left.equalTo(headV).offset(0);
        make.right.equalTo(headV).offset(0);
    }];
    
    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 90)];
    SettlementFootView *footView = [SettlementFootView createHeadView];
    [footV addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footV).offset(0);
        make.bottom.equalTo(footV).offset(0);
        make.left.equalTo(footV).offset(0);
        make.right.equalTo(footV).offset(0);
    }];
    
    self.settlementTab.tableHeaderView = headV;
    self.settlementTab.tableFooterView = footV;
    self.delHView = headView;
    self.delFView = footView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 11.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SettlementSecHedView *headV = [SettlementSecHedView creatView];
    return headV;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 11)];
    footV.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SDevWidth, 1)];
    line .backgroundColor = DefaultColor;
    [footV addSubview:line];
    return footV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettlementListInfo *sInfo = self.listArr[indexPath.section];
    return 24*sInfo.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettlementTableCell *cell = [SettlementTableCell cellWithTableView:tableView];
    SettlementListInfo *sInfo = self.listArr[indexPath.section];
    cell.info = sInfo;
    return cell;
}

@end
