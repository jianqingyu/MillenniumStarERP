//
//  SettlementListVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementListVC.h"
#import "SettlementListHeadView.h"
#import "SettlementListCell.h"
#import "DeliveryOrderVC.h"
#import "SettlementOrderVC.h"
@interface SettlementListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *setListTable;
@end

@implementation SettlementListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算单";
    [self setHeadView];
}

- (void)setHeadView{
    self.setListTable.backgroundColor = DefaultColor;
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 180)];
    SettlementListHeadView *headView = [SettlementListHeadView createHeadView];
    [headV addSubview:headView];
    headView.backgroundColor = DefaultColor;
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headV).offset(0);
        make.bottom.equalTo(headV).offset(0);
        make.left.equalTo(headV).offset(0);
        make.right.equalTo(headV).offset(0);
    }];
    headView.clickBack = ^(BOOL isClick){
        [self loadSettlementVC];
    };
    self.setListTable.tableHeaderView = headV;
    self.setListTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettlementListCell *listCell = [SettlementListCell cellWithTableView:tableView];
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadDeliveryWithIndex:indexPath];
}

//出货单
- (void)loadDeliveryWithIndex:(NSIndexPath *)indexPath{
    DeliveryOrderVC *orderVc = [DeliveryOrderVC new];
    
    [self.navigationController pushViewController:orderVc animated:YES];
}
//结算单
- (void)loadSettlementVC{
    SettlementOrderVC *orderVc = [SettlementOrderVC new];
    
    [self.navigationController pushViewController:orderVc animated:YES];
}
@end
