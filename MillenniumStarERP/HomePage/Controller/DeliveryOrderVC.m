//
//  DeliveryOrderVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/3/3.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "DeliveryOrderVC.h"
#import "DeliveryListInfo.h"
#import "DetailHeadInfo.h"
#import "DeliveryOrderHeadView.h"
#import "DeliveryOrderTableCell.h"
@interface DeliveryOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak,  nonatomic) IBOutlet UITableView *deliveryTab;
@property (nonatomic,strong)NSArray *listArr;
@property (nonatomic,  weak)DeliveryOrderHeadView *delHView;
@end

@implementation DeliveryOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"出货单";
    [self setBaseView];
}

- (void)setBaseView{
    self.deliveryTab.backgroundColor = DefaultColor;
    
    DeliveryListInfo *info = [DeliveryListInfo new];
    info.title = @"女戒";
    info.ordernum = @"5623545";
    info.price = 881.5;
    info.pic = @"aaaa";
    info.sDetail = @"手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g";
    info.detail = @"手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g 手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g 手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g 手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g";
    DeliveryListInfo *info1 = [DeliveryListInfo new];
    info1.title = @"女戒";
    info1.ordernum = @"5623545";
    info1.price = 881.5;
    info1.pic = @"aaaa";
    info1.sDetail = @"手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g";
    info1.detail = @"手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g 手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g 手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g 手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g";
    info1.isOpen = YES;
    DeliveryListInfo *info2 = [DeliveryListInfo new];
    info2.title = @"女戒";
    info2.ordernum = @"5623545";
    info2.price = 881.5;
    info2.pic = @"aaaa";
    info2.sDetail = @"手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g";
    info2.detail = @"手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g 手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g 手寸：11 毛重:3g 净金重:3.15g 耗损:0.85g 手寸：11 毛重:3g";
    self.listArr = @[info,info1,info2];
    
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 120)];
    DeliveryOrderHeadView *headView = [DeliveryOrderHeadView createHeadView];
    [headV addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headV).offset(0);
        make.bottom.equalTo(headV).offset(0);
        make.left.equalTo(headV).offset(0);
        make.right.equalTo(headV).offset(0);
    }];
    self.deliveryTab.tableHeaderView = headV;
    self.deliveryTab.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.delHView = headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryListInfo *sInfo = self.listArr[indexPath.row];
    return sInfo.isOpen?130:80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryOrderTableCell *cell = [DeliveryOrderTableCell cellWithTableView:tableView];
    DeliveryListInfo *sInfo = self.listArr[indexPath.row];
    cell.index = (int)indexPath.row+1;
    cell.deliveryInfo = sInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeliveryListInfo *sInfo = self.listArr[indexPath.row];
    sInfo.isOpen = !sInfo.isOpen;
    [_deliveryTab reloadRowsAtIndexPaths:@[indexPath]
                        withRowAnimation:UITableViewRowAnimationNone];
}

@end
