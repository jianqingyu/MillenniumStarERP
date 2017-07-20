//
//  NakedDriLibViewController.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriLibViewController.h"
#import "NakedDriListOrderVc.h"
#import "NakedDriLibHeadView.h"
#import "NakedDriLibListCell.h"
#import "NakedDriLibBLabCell.h"
#import "NakedDriLibSLabCell.h"
#import "NakedDriLiblistInfo.h"
#import "NakedDriLibInfo.h"
#import "NakedDriLibImgInfo.h"
#import "StrWithIntTool.h"
#import "NakedDriSearchVC.h"
@interface NakedDriLibViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic,   weak)NakedDriLibHeadView *headView;
@property (nonatomic, strong)NSMutableArray *NakedArr;
@property (nonatomic, strong)NSDictionary *dict;
@property (nonatomic, strong)NSArray *headArr;
@property (nonatomic, strong)NakedDriLiblistInfo *hedInfo;
@end

@implementation NakedDriLibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"裸钻库";
    [self setRightNaviBar];
    [self setNakedTableView];
    [self setNakedHeadView];
    [self setHomeData];
    self.NakedArr = @[].mutableCopy;
}

- (void)setNakedTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)setNakedHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 270)];
    headView.backgroundColor = DefaultColor;
    NakedDriLibHeadView *headV = [[NakedDriLibHeadView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, 270)];
    headV.back = ^(id mess){
        self.dict = mess;
    };
    [headView addSubview:headV];
    self.tableView.tableHeaderView = headView;
    self.headView = headV;
}

- (void)setHomeData{
    NSString *regiUrl = [NSString stringWithFormat:@"%@stoneSearchInfo",baseUrl];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"certAuth"]]) {
                _hedInfo = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"certAuth"]];
                self.headView.info = [self lisInfoWith:_hedInfo];
            }
            NSMutableArray *mutH = [NSMutableArray new];
            if ([YQObjectBool boolForObject:response.data[@"weight"]]) {
                [mutH addObject:response.data[@"weight"]];
            }
            if ([YQObjectBool boolForObject:response.data[@"price"]]) {
                [mutH addObject:response.data[@"price"]];
            }
            self.headArr = mutH.copy;
            self.headView.dicArr = mutH.copy;
            NSMutableArray *mut = [NSMutableArray new];
            if ([YQObjectBool boolForObject:response.data[@"shape"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"shape"]];
                [mut addObject:[self ImgInfoWith:info]];
            }
            NSMutableArray *mutA = [NSMutableArray new];
            if ([YQObjectBool boolForObject:response.data[@"color"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"color"]];
                [mutA addObject:[self lisInfoWith:info]];
            }
            if ([YQObjectBool boolForObject:response.data[@"purity"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"purity"]];
                [mutA addObject:[self lisInfoWith:info]];
            }
            NSMutableArray *mutB = [NSMutableArray new];
            if ([YQObjectBool boolForObject:response.data[@"cut"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"cut"]];
                [mutB addObject:[self lisInfoWith:info]];
            }
            if ([YQObjectBool boolForObject:response.data[@"polishing"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"polishing"]];
                [mutB addObject:[self lisInfoWith:info]];
            }
            if ([YQObjectBool boolForObject:response.data[@"symmetric"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"symmetric"]];
                [mutB addObject:[self lisInfoWith:info]];
            }
            if ([YQObjectBool boolForObject:response.data[@"fluorescence"]]) {
                NakedDriLiblistInfo *info = [NakedDriLiblistInfo objectWithKeyValues:response.data[@"fluorescence"]];
                [mutB addObject:[self lisInfoWith:info]];
            }
            if (mut.count>0) {
                [self.NakedArr addObject:mut];
            }
            if (mutA.count>0) {
                [self.NakedArr addObject:mutA];
            }
            if (mutB.count>0) {
                [self.NakedArr addObject:mutB];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:response.message];
        }
    } requestURL:regiUrl params:params];
}

- (NakedDriLiblistInfo *)ImgInfoWith:(NakedDriLiblistInfo *)info{
    NSMutableArray *arr = [NSMutableArray new];
    for (NSDictionary *dic in info.values) {
        NakedDriLibImgInfo *linfo = [NakedDriLibImgInfo new];
        linfo.pic = dic[@"pic"];
        linfo.pic1 = dic[@"pic1"];
        linfo.name = dic[@"name"];
        [arr addObject:linfo];
    }
    info.values = arr.copy;
    return info;
}

- (NakedDriLiblistInfo *)lisInfoWith:(NakedDriLiblistInfo *)info{
    NSMutableArray *arr = [NSMutableArray new];
    for (NSString *str in info.values) {
        NakedDriLibInfo *linfo = [NakedDriLibInfo new];
        linfo.name = str;
        [arr addObject:linfo];
    }
    info.values = arr.copy;
    return info;
}

- (void)setRightNaviBar{
    UIButton *bar = [UIButton buttonWithType:UIButtonTypeCustom];
    bar.frame = CGRectMake(0, 0, 80, 30);
    [bar setTitle:@"我的订单" forState:UIControlStateNormal];
    bar.titleLabel.font = [UIFont systemFontOfSize:16];
    [bar setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bar addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bar];
}

- (void)btnClick:(id)sender{
    NakedDriListOrderVc *listVc = [NakedDriListOrderVc new];
    [self.navigationController pushViewController:listVc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.NakedArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.NakedArr[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.NakedArr[indexPath.section];
    if (indexPath.section==0) {
        NakedDriLibListCell *imgCell = [NakedDriLibListCell cellWithTableView:tableView];
        imgCell.imgInfo = arr[indexPath.row];
        return imgCell;
    }else if (indexPath.section==1){
        NakedDriLibBLabCell *BCell = [NakedDriLibBLabCell cellWithTableView:tableView];
        BCell.textInfo = arr[indexPath.row];
        return BCell;
    }else{
        NakedDriLibSLabCell *sCell = [NakedDriLibSLabCell cellWithTableView:tableView];
        sCell.textSInfo = arr[indexPath.row];
        return sCell;
    }
}

- (IBAction)searchClick:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *mutA = @[].mutableCopy;
    for (id info in _hedInfo.values) {
        BOOL isSel = [[info valueForKey:@"isSel"]boolValue];
        NSString *name = [info valueForKey:@"name"];
        if (isSel) {
            [mutA addObject:name];
        }
    }
    params[_hedInfo.keyword] = mutA.copy;
    for (NSArray *arr in self.NakedArr) {
        for (NakedDriLiblistInfo *linfo in arr) {
            NSMutableArray *mutA = @[].mutableCopy;
            for (id info in linfo.values) {
                BOOL isSel = [[info valueForKey:@"isSel"]boolValue];
                NSString *name = [info valueForKey:@"name"];
                if (isSel) {
                    [mutA addObject:name];
                }
            }
            params[linfo.keyword] = mutA.copy;
        }
    }
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj count]>0) {
            params[key] = [StrWithIntTool strWithArr:obj With:@","];
        }else{
            [params removeObjectForKey:key];
        }
    }];
    [params addEntriesFromDictionary:self.dict];
    if (self.headView.numFie.text.length>0) {
        params[@"percent"] = self.headView.numFie.text;
    }
    NakedDriSearchVC *seaVc = [NakedDriSearchVC new];
    seaVc.isSel = self.isSel;
    seaVc.seaDic = params;
    [self.navigationController pushViewController:seaVc animated:YES];
}

- (IBAction)resetClick:(id)sender {
    for (id info in _hedInfo.values) {
        [info setValue:@NO forKey:@"isSel"];
    }
    for (NSArray *arr in self.NakedArr) {
        for (NakedDriLiblistInfo *linfo in arr) {
            for (id info in linfo.values) {
                [info setValue:@NO forKey:@"isSel"];
            }
        }
    }
    self.headView.dicArr = self.headArr;
    self.headView.info = _hedInfo;
    self.headView.numFie.text = @"";
    self.dict = @{};
    [self.tableView reloadData];
}

@end
