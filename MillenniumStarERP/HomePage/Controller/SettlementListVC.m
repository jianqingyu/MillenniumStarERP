//
//  SettlementListVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/7.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "SettlementListVC.h"
#import "OrderSetmentInfo.h"
#import "DelSListInfo.h"
#import "SettlementListHeadView.h"
#import "SettlementListCell.h"
#import "DeliveryOrderVC.h"
#import "SettlementOrderVC.h"
@interface SettlementListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *setListTable;
@property (nonatomic,copy) NSArray *setList;
@end

@implementation SettlementListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"结算单";
    [self setHeadView];
    [self loadSetListData];
}

- (void)setHeadView{
    self.setListTable.backgroundColor = DefaultColor;
    self.setListTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)loadSetListData{
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url = [NSString stringWithFormat:@"%@ModelFinishBillList",baseUrl];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderNum"] = self.orderNumber;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"recList"]]) {
                self.setList = [OrderSetmentInfo objectArrayWithKeyValuesArray:
                                   response.data[@"recList"]];
                [self.setListTable reloadData];
            }
        }
    } requestURL:url params:params];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.setList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OrderSetmentInfo *list = self.setList[section];
    return list.moList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 180.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
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
    OrderSetmentInfo *list = self.setList[section];
    headView.headInfo = list;
    headView.clickBack = ^(BOOL isClick){
        [self loadSettlementVC:section];
    };
    return headV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettlementListCell *listCell = [SettlementListCell cellWithTableView:tableView];
    OrderSetmentInfo *list = self.setList[indexPath.section];
    listCell.listInfo = list.moList[indexPath.row];
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadDeliveryWithIndex:indexPath];
}
//出货单
- (void)loadDeliveryWithIndex:(NSIndexPath *)indexPath{
    OrderSetmentInfo *list = self.setList[indexPath.section];
    DelSListInfo *sInfo = list.moList[indexPath.row];
    DeliveryOrderVC *orderVc = [DeliveryOrderVC new];
    orderVc.orderNum = sInfo.moNum;
    [self.navigationController pushViewController:orderVc animated:YES];
}
//结算单
- (void)loadSettlementVC:(NSInteger)section{
    OrderSetmentInfo *list = self.setList[section];
    SettlementOrderVC *orderVc = [SettlementOrderVC new];
    orderVc.orderNum = list.recNum;
    [self.navigationController pushViewController:orderVc animated:YES];
}

@end
