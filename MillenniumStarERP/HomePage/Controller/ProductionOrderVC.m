//
//  ProductionOrderVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/11/21.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ProductionOrderVC.h"
#import "ConfirmOrdCell.h"
#import "OrderListInfo.h"
#import "ProduceHeadView.h"
#import "ProduceOrderInfo.h"
#import "ProgressOrderVc.h"
@interface ProductionOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,  weak) ProduceHeadView *proHView;
@property (nonatomic,  copy) NSArray *dataArr;
@end

@implementation ProductionOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生产中";
    [self setupTableView];
    [self loadOrderDataWithBool:YES];
}

- (void)setupTableView{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 180)];
    ProduceHeadView *headView = [ProduceHeadView view];
    [headV addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headV).offset(0);
        make.bottom.equalTo(headV).offset(0);
        make.left.equalTo(headV).offset(0);
        make.right.equalTo(headV).offset(0);
    }];
    self.tableView.tableHeaderView = headV;
    self.proHView = headView;
}

- (void)loadOrderDataWithBool:(BOOL)isNew{
    NSString *netUrl = isNew?@"ModelOrderProduceDetailPage":
                             @"ModelOrderProduceDetailHistoryPage";
    NSMutableDictionary *params = [NSMutableDictionary new];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseUrl,netUrl];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[@"orderNum"] = self.orderNum;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"modelList"]]) {
                self.dataArr = [OrderListInfo objectArrayWithKeyValuesArray:response.data[@"modelList"]];
                [self.tableView reloadData];
            }
            if ([YQObjectBool boolForObject:response.data[@"orderInfo"]]) {
                self.proHView.orderInfo = [ProduceOrderInfo
                                objectWithKeyValues:response.data[@"orderInfo"]];
            }
        }
    } requestURL:url params:params];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConfirmOrdCell *conCell = [ConfirmOrdCell cellWithTableView:tableView];
    conCell.isTopHidden = YES;
    OrderListInfo *listInfo;
    if (indexPath.section<self.dataArr.count) {
        listInfo = self.dataArr[indexPath.section];
    }
    conCell.listInfo = listInfo;
    return conCell;
}

- (IBAction)bottomClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self loadOrderDataWithBool:!sender.selected];
}

- (IBAction)lookProgress:(id)sender {
    NSString *class = @"ProgressOrderVc";
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    //如果没有则注册一个类
    if (!newClass) {
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        objc_registerClassPair(newClass);
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    [instance setValue:self.orderNum forKey:@"orderNum"];
    [self.navigationController pushViewController:instance animated:YES];
}

@end
