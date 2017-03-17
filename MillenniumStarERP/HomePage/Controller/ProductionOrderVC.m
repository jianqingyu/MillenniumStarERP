//
//  ProductionOrderVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/11/21.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ProductionOrderVC.h"
#import "ProductionDetailView.h"
#import "OrderListInfo.h"
#import "ProduceOrderInfo.h"
@interface ProductionOrderVC ()
@property (nonatomic,  weak) ProductionDetailView *proView;
@end

@implementation ProductionOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生产中";
    [self creatProTabView];
    [self loadOrderDataWithBool:YES];
}

- (void)creatProTabView{
    CGRect frame = CGRectMake(0, 0, SDevWidth, SDevHeight-64);
    ProductionDetailView *proV = [[ProductionDetailView alloc]initWithFrame:frame];
    [self.view addSubview:proV];
    proV.back = ^(BOOL isLoad){
        [self loadOrderDataWithBool:isLoad];
    };
    self.proView = proV;
    self.proView.superNav = self.navigationController;
}

- (void)loadOrderDataWithBool:(BOOL)isNew{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    NSString *netUrl = isNew?@"ModelOrderProduceDetailPage":
                             @"ModelOrderProduceDetailHistoryPage";
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,netUrl];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderNum"] = self.orderNum;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"modelList"]]) {
                NSArray *arr = [OrderListInfo objectArrayWithKeyValuesArray:response.data[@"modelList"]];
                dict[@"orderList"] = arr;
            }
            if ([YQObjectBool boolForObject:response.data[@"orderInfo"]]) {
                ProduceOrderInfo *info = [ProduceOrderInfo
                                objectWithKeyValues:response.data[@"orderInfo"]];
                dict[@"orderInfo"] = info;
            }
            dict[@"orderNum"] = self.orderNum;
            self.proView.dict = dict.copy;
        }
    } requestURL:url params:params];
}

@end
