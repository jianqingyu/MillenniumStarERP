//
//  NewCustomProDetailVC.m
//  MillenniumStarERP
//
//  Created by yjq on 17/7/14.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NewCustomProDetailVC.h"
#import "ConfirmOrderVC.h"
#import "CustomFirstCell.h"
#import "NewCustomProCell.h"
#import "CustomLastCell.h"
#import "MWPhotoBrowser.h"
#import "DetailTypeInfo.h"
#import "DetailModel.h"
#import "DetailTypeInfo.h"
#import "OrderListInfo.h"
#import "DetailHeadInfo.h"
#import "StrWithIntTool.h"
#import "CommonUtils.h"
#import "OrderNumTool.h"
#import "CustomJewelInfo.h"
#import "CustomPickView.h"
#import "HYBLoopScrollView.h"
#import "NakedDriSeaListInfo.h"
#import "NakedDriLibViewController.h"
@interface NewCustomProDetailVC ()<UINavigationControllerDelegate,UITableViewDelegate,
UITableViewDataSource,MWPhotoBrowserDelegate>
@property (nonatomic,  weak) UITableView *tableView;
@property (nonatomic,  weak) IBOutlet UIButton *lookBtn;
@property (nonatomic,  weak) IBOutlet UIButton *addBtn;
@property (nonatomic,  weak) IBOutlet UILabel *numLab;
@property (nonatomic,  copy)NSArray *typeArr;
@property (nonatomic,  copy)NSArray *typeTArr;
@property (nonatomic,  copy)NSArray *typeSArr;
@property (nonatomic,  copy)NSArray*detailArr;
@property (nonatomic,  copy)NSString*firstStr;
@property (nonatomic,  copy)NSString*handStr;
@property (nonatomic,  copy)NSArray*remakeArr;
@property (nonatomic,  copy)NSArray*IDarray;
@property (nonatomic,  copy)NSArray*headImg;
@property (nonatomic,  copy)NSArray*photos;
@property (nonatomic,  copy)NSArray*specTitles;
@property (nonatomic,  copy)NSString*lastMess;
@property (nonatomic,  copy)NSArray *handArr;
@property (nonatomic,  copy)NSArray *numArr;
@property (nonatomic,  strong)NSMutableArray*mutArr;
@property (nonatomic,    copy)NSString *driCode;
@property (nonatomic,    copy)NSString *driPrice;
@property (nonatomic,    copy)NSString *driId;
@property (nonatomic,  strong)UIView *hView;
@property (nonatomic,  strong)DetailModel *modelInfo;
@property (nonatomic,  strong)CustomPickView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@end

@implementation NewCustomProDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制信息";
    self.view.backgroundColor = DefaultColor;
    [self loadBaseCustomView];
}

- (void)loadBaseCustomView{
    [self.numLab setLayerWithW:8 andColor:BordColor andBackW:0.001];
    [self.lookBtn setLayerWithW:5 andColor:BordColor andBackW:0.5];
    [self.addBtn setLayerWithW:5 andColor:BordColor andBackW:0.001];
    self.priceLab.hidden = ![[AccountTool account].isShow intValue];
    [self.priceLab setAdjustsFontSizeToFitWidth:YES];
    [self.numLab setAdjustsFontSizeToFitWidth:YES];
    if (self.isEdit) {
        [self.lookBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.addBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    self.typeArr = @[@"主   石",@"副石A",@"副石B",@"副石C"];
    self.typeSArr = @[@"stone",@"stoneA",@"stoneB",@"stoneC"];
    self.mutArr = @[].mutableCopy;
    [self setBaseTableView];
    [self setupDetailData];
    [self setupPopView];
    [self creatNaviBtn];
    [self creatNearNetView:^(BOOL isWifi) {
        [self setupDetailData];
    }];
    [self setHandSize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAddress:)
                                                name:NotificationDriName object:nil];
}
//显示地址
- (void)changeAddress:(NSNotification *)notification{
    NakedDriSeaListInfo *listInfo = notification.userInfo[UserInfoDriName];
    NSArray *infoArr = @[@"钻石",listInfo.Weight,@"圆形",listInfo.Color,listInfo.Purity];
    NSArray *arr = self.mutArr[0];
    for (int i=0; i<arr.count; i++) {
        DetailTypeInfo *info = arr[i];
        info.id = 1;
        NSString *title = [infoArr[i] length]>0?infoArr[i]:@"默认";
        info.title = title;
    }
    self.driCode = listInfo.CertCode;
    self.driPrice = listInfo.Price;
    self.driId = listInfo.id;
    self.firstStr = @"1";
    [self.tableView reloadData];
}

- (void)addStoneWithDic:(NSDictionary *)data{
    CustomJewelInfo *CusInfo = [CustomJewelInfo objectWithKeyValues:data];
    NSArray *infoArr = @[@"钻石",CusInfo.jewelStoneWeight,@"圆形",CusInfo.jewelStoneColor,
                         CusInfo.jewelStonePurity];
    NSMutableArray *mutA = [NSMutableArray new];
    for (int i=0; i<5; i++) {
        DetailTypeInfo *info = [DetailTypeInfo new];
        info.id = 1;
        BOOL isNull = [infoArr[i] length]>0&&![infoArr[i] isEqualToString:@" "];
        NSString *title = isNull?infoArr[i]:@"默认";
        info.title = title;
        [mutA addObject:info];
    }
    self.driCode = CusInfo.jewelStoneCode;
    self.driPrice = CusInfo.jewelStonePrice;
    self.driId = CusInfo.jewelStoneId;
    self.firstStr = @"1";
    [self.mutArr addObject:mutA];
    [self.tableView reloadData];
}

- (void)orientChange:(NSNotification *)notification{
    [self changeTableHeadView];
}

- (void)changeTableHeadView{
    if (SDevHeight>SDevWidth) {
        [self.hView removeFromSuperview];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(0);
        }];
        [self setupHeadView:self.headImg and:YES];
    }else{
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(SDevWidth*0.5);
        }];
        [self setupHeadView:self.headImg and:NO];
    }
}

- (void)setBaseTableView{
    UITableView *table = [[UITableView alloc]init];
    table.backgroundColor = DefaultColor;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = UITableViewAutomaticDimension;
    table.estimatedRowHeight = 125;
    [self.view addSubview:table];
    CGFloat headF = 0;
    if (!IsPhone){
        headF = 20;
    }
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(headF);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    self.tableView = table;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:
                                               CGRectMake(0, 0, SDevWidth, 10)];
}

- (void)setHandSize{
    self.typeTArr = @[@"类型",@"规格",@"形状",@"颜色",@"净度"];
    self.numArr = @[@{@"title":@"1"},@{@"title":@"2"},@{@"title":@"3"},
                    @{@"title":@"4"}, @{@"title":@"5"},@{@"title":@"6"},
                    @{@"title":@"7"},@{@"title":@"8"},@{@"title":@"9"},
                    @{@"title":@"10"},@{@"title":@"11"},@{@"title":@"12"},
                    @{@"title":@"13"},@{@"title":@"14"},@{@"title":@"15"},
                    @{@"title":@"16"},@{@"title":@"17"},@{@"title":@"18"}];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    App;
    [OrderNumTool orderWithNum:app.shopNum andView:self.numLab];
    self.navigationController.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)creatNaviBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 20, 54, 54);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- loadData 初始化数据
- (void)setupDetailData{
    [SVProgressHUD show];
    NSString *detail;
    if (self.isEdit==1) {
        detail = @"ModelDetailPageForCurrentOrderEditPage";
    }else if (self.isEdit==2){
        detail = @"ModelOrderWaitCheckModelDetailPageForCurrentOrderEditPage";
    }else{
        detail = @"ModelDetailPage";
    }
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSString *proId = self.isEdit?@"itemId":@"id";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[proId] = @(_proId);
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if ([YQObjectBool boolForObject:response.data[@"jewelStone"]]) {
                [self addStoneWithDic:response.data[@"jewelStone"]];
            }
            if ([YQObjectBool boolForObject:response.data[@"model"]]) {
                DetailModel *modelIn = [DetailModel objectWithKeyValues:
                                        response.data[@"model"]];
                [self setupBaseListData:modelIn];
                [self creatCusTomHeadView];
                [self.tableView reloadData];
            }
            if ([YQObjectBool boolForObject:response.data[@"handSizeData"]]) {
                NSMutableArray *mutA = [NSMutableArray new];
                for (NSString *title in response.data[@"handSizeData"]) {
                    [mutA addObject:@{@"title":title}];
                }
                self.handArr = mutA.copy;
            }
            if ([YQObjectBool boolForObject:response.data[@"remarks"]]) {
                self.remakeArr = response.data[@"remarks"];
            }
        }
        [SVProgressHUD dismiss];
    } requestURL:regiUrl params:params];
}

- (void)setupBaseListData:(DetailModel *)modelIn{
    self.modelInfo = modelIn;
    self.lastMess = modelIn.remark;
    if (self.isEdit) {
        self.firstStr = modelIn.number;
        self.handStr = modelIn.handSize;
    }
    self.detailArr  = @[[self arrWithDict:modelIn.stone],
                        [self arrWithDict:modelIn.stoneA],
                        [self arrWithDict:modelIn.stoneB],
                        [self arrWithDict:modelIn.stoneC]];
    [self setBaseMutArr];
}

- (void)setBaseMutArr{
    int i=0;
    for (NSArray *arr in self.detailArr) {
        if (i==0&&self.mutArr.count==0) {
            [self setMutAWith:arr];
        }else{
            if (![self boolWithNoArr:arr]) {
                [self setMutAWith:arr];
            }
        }
        i++;
    }
}

- (void)setMutAWith:(NSArray *)arr{
    NSMutableArray *mut = [NSMutableArray new];
    for (DetailTypeInfo *new in arr) {
        [mut addObject:[new newInfo]];
    }
    [self.mutArr addObject:mut];
}
//一个石头里面的数据都是空的
- (BOOL)boolWithNoArr:(NSArray *)arr{
    for (DetailTypeInfo *info in arr) {
        if (info.title.length>0) {
            return NO;
        }
    }
    return YES;
}

- (NSMutableArray *)arrWithDict:(NSDictionary *)dict{
    DetailTypeInfo *in1 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"typeTitle"]]) {
        in1.id = [dict[@"typeId"]intValue];
        in1.title = dict[@"typeTitle"];
    }
    DetailTypeInfo *in2 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"specTitle"]]) {
        in2.title = dict[@"specTitle"];
    }
    DetailTypeInfo *in3 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"shapeTitle"]]) {
        in3.id = [dict[@"shapeId"]intValue];
        in3.title = dict[@"shapeTitle"];
    }
    DetailTypeInfo *in4 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"colorTitle"]]) {
        in4.id = [dict[@"colorId"]intValue];
        in4.title = dict[@"colorTitle"];
    }
    DetailTypeInfo *in5 = [DetailTypeInfo new];
    if ([YQObjectBool boolForObject:dict[@"purityTitle"]]) {
        in5.id = [dict[@"purityId"]intValue];
        in5.title = dict[@"purityTitle"];
    }
    return @[in1,in2,in3,in4,in5].mutableCopy;
}
#pragma mark - 初始化图片
- (void)creatCusTomHeadView{
    NSMutableArray *pic  = @[].mutableCopy;
    NSMutableArray *mPic = @[].mutableCopy;
    NSMutableArray *bPic = @[].mutableCopy;
    for (NSDictionary*dict in self.modelInfo.pics) {
        NSString *str = [dict[@"pic"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (str.length>0) {
            [pic addObject:str];
        }
        NSString *strm = [dict[@"picm"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (strm.length>0) {
            [mPic addObject:strm];
        }
        NSString *strb = [dict[@"picb"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (strb.length>0) {
            [bPic addObject:strb];
        }
    }
    NSArray *headArr;
    if (mPic.count==0) {
        mPic = @[@"pic"].mutableCopy;
    }
    headArr = mPic.copy;
    self.headImg = headArr;
    self.IDarray = [bPic copy];
    [self changeTableHeadView];
}

- (void)setupHeadView:(NSArray *)headArr and:(BOOL)isHead{
    CGRect headF = CGRectMake(0, 0, SDevWidth*0.5, SDevHeight-60);
    if (!IsPhone){
        headF = CGRectMake(0, 20, SDevWidth*0.5, SDevHeight-80);
    }
    if (isHead) {
        headF = CGRectMake(0, 0, SDevWidth, SDevWidth);
    }
    UIView *headView = [[UIView alloc]initWithFrame:headF];
    CGFloat wid = headView.width;
    CGFloat height = headView.height;
    CGRect frame = CGRectMake(0, 0, wid, height);
    HYBLoopScrollView *loop = [HYBLoopScrollView loopScrollViewWithFrame:
                               frame imageUrls:headArr];
    loop.timeInterval = 6.0;
    loop.didSelectItemBlock = ^(NSInteger atIndex,HYBLoadImageView  *sender){
        [self didImageWithIndex:atIndex];
    };
    loop.alignment = kPageControlAlignRight;
    [headView addSubview:loop];
    self.hView = headView;
    if (isHead) {
        self.tableView.tableHeaderView = self.hView;
    }else{
        [self.view addSubview:self.hView];
        [self.view sendSubviewToBack:self.hView];
    }
}

- (void)didImageWithIndex:(NSInteger)index{
    //网络图片展示
    if (self.IDarray.count==0) {
        [MBProgressHUD showError:@"暂无图片"];
        return;
    }
    [self networkImageShow:index];
}

- (void)networkImageShow:(NSUInteger)index{
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *str in self.IDarray) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:str]];
        [photos addObject:photo];
    }
    self.photos = [photos copy];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count){
        return [_photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark -- CustomPopView
- (void)setupPopView{
    CustomPickView *popV = [[CustomPickView alloc]init];
    popV.popBack = ^(int staue,id dict){
        DetailTypeInfo *info = [dict allValues][0];
        if (staue==2){
            self.handStr = info.title;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else if (staue==4){
            self.lastMess = [NSString stringWithFormat:@"%@%@",self.lastMess,info.title];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.mutArr.count+1 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:
             UITableViewRowAnimationNone];
        }
        [self dismissCustomPopView];
    };
    [self.view addSubview:popV];
    [popV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.pickView = popV;
    [self dismissCustomPopView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissCustomPopView];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    [self updateBottomPrice];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.mutArr.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        CustomFirstCell *firstCell = [CustomFirstCell cellWithTableView:tableView];
        firstCell.MessBack = ^(BOOL isSel,NSString *messArr){
            if (isSel) {
                self.firstStr = messArr;
            }else{
                [self openNumberAndhandSize:2 and:indexPath];
            }
        };
        firstCell.isNew = YES;
        if (self.driCode) {
            firstCell.certCode = self.driCode;
        }
        firstCell.modelInfo = self.modelInfo;
        firstCell.messArr = self.firstStr;
        firstCell.handSize = self.handStr;
        return firstCell;
    }else if (indexPath.row==self.mutArr.count+1){
        CustomLastCell *lastCell = [CustomLastCell cellWithTableView:tableView];
        [lastCell.btn addTarget:self action:@selector(openRemark:)
               forControlEvents:UIControlEventTouchUpInside];
        lastCell.messBack = ^(id message){
            if ([message isKindOfClass:[NSString class]]) {
                self.lastMess = message;
            }
        };
        lastCell.message = self.lastMess;
        return lastCell;
    }else{
        NewCustomProCell *proCell = [NewCustomProCell cellWithTableView:tableView];
        proCell.titleStr = self.typeArr[indexPath.row-1];
        proCell.list = self.mutArr[indexPath.row-1];
        if (self.driCode) {
            proCell.certCode = self.driCode;
        }
        return proCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        [self gotoNakedDriLib];
    }
}

- (void)openNumberAndhandSize:(int)staue and:(NSIndexPath *)index{
    if (staue==2) {
        self.pickView.typeList = self.handArr;
        NSString *title = self.handStr?self.handStr:@"12";
        self.pickView.titleStr = @"手寸";
        self.pickView.selTitle = title;
    }
    self.pickView.section = index;
    self.pickView.staue = staue;
    [self showCustomPopView];
}

- (void)openRemark:(id)sender{
    if (self.remakeArr.count==0) {
        [MBProgressHUD showError:@"没有备注可选"];
        return;
    }
    self.pickView.typeList = self.remakeArr;
    self.pickView.section = [NSIndexPath indexPathForRow:0 inSection:0];
    self.pickView.titleStr = @"备注";
    self.pickView.staue = 4;
    [self showCustomPopView];
}

- (void)showCustomPopView{
    self.pickView.hidden = NO;
}

- (void)dismissCustomPopView{
    self.pickView.hidden = YES;
}

- (void)gotoNakedDriLib{
    NakedDriLibViewController *libVc = [NakedDriLibViewController new];
    libVc.isSel = YES;
    [self.navigationController pushViewController:libVc animated:YES];
}

- (IBAction)lookOrder:(id)sender {
    if (self.isEdit) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    ConfirmOrderVC *orderVC = [ConfirmOrderVC new];
    [self.navigationController pushViewController:orderVC animated:YES];
}
#pragma mark -- 提交订单
- (IBAction)addOrder:(id)sender {
    if ([self.firstStr length]==0) {
        [MBProgressHUD showError:@"请选择件数"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    for (int i=0; i<self.mutArr.count; i++) {
        NSMutableArray *arr = self.mutArr[i];
        [self paramsWithArr:arr andI:i andD:params];
    }
    [self addOrderWithDict:params];
}

- (void)paramsWithArr:(NSArray *)arr andI:(int)i andD:(NSMutableDictionary *)params{
    NSMutableArray *mutA = @[].mutableCopy;
    for (DetailTypeInfo *info in arr) {
        if (info.id) {
            [mutA addObject:@(info.id)];
        }else{
            if (info.title) {
                [mutA addObject:info.title];
            }else{
                [mutA addObject:@""];
            }
        }
    }
    NSString *str = [StrWithIntTool strWithIntOrStrArr:mutA];
    NSString *key = self.typeSArr[i];
    if (![key isEqualToString:@"stone"]) {
        str = [NSString stringWithFormat:@"%@|0",str];
    }
    params[self.typeSArr[i]] = str;
}

- (void)addOrderWithDict:(NSMutableDictionary *)params{
    NSString *detail;
    if (self.isEdit==1) {
        detail = @"OrderCurrentEditModelItemDo";
    }else if (self.isEdit==2){
        detail = @"ModelOrderWaitCheckOrderCurrentEditModelItemDo";
    }else{
        detail = @"OrderDoCurrentModelItemDo";
    }
    NSString *regiUrl = [NSString stringWithFormat:@"%@%@",baseUrl,detail];
    NSString *proId = self.isEdit?@"itemId":@"productId";
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    params[proId] = @(self.proId);
    params[@"number"] = self.firstStr;
    if ([self.handStr length]>0) {
        params[@"handSize"] = self.handStr;
    }
    if (self.driId.length>0) {
        params[@"jewelStoneId"] = self.driId;
    }
    if (!self.isEdit) {
        params[@"categoryId"] = @(self.modelInfo.categoryId);
    }
    if (self.lastMess.length>0) {
        params[@"remarks"] = self.lastMess;
    }
    [self addOrderData:params andUrl:regiUrl];
}

- (void)addOrderData:(NSMutableDictionary *)params andUrl:(NSString *)netUrl{
    [SVProgressHUD show];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        if ([response.error intValue]==0) {
            if (self.isEdit) {
                [self loadEditType:response.data];
                return;
            }
            if ([YQObjectBool boolForObject:response.data]&&
                [YQObjectBool boolForObject:response.data[@"waitOrderCount"]]) {
                App;
                app.shopNum = [response.data[@"waitOrderCount"]intValue];
                [OrderNumTool orderWithNum:app.shopNum andView:self.numLab];
            }
            [MBProgressHUD showSuccess:@"添加订单成功"];
        }else{
            [MBProgressHUD showError:response.message];
        }
    }requestURL:netUrl params:params];
}

- (void)loadEditType:(NSDictionary *)data{
    OrderListInfo *listI = [OrderListInfo objectWithKeyValues:data];
    if (self.orderBack) {
        self.orderBack(listI);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateBottomPrice{
    float price = _modelInfo.price;
    if (self.driPrice.length>0) {
        price = price + [self.driPrice floatValue];
    }
    self.priceLab.text = [NSString stringWithFormat:@"￥%0.0f",price];
}

@end
