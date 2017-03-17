//
//  ProductListVC.m
//  MillenniumStarERP
//
//  Created by yjq on 16/9/8.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "ProductListVC.h"
#import "YQItemTool.h"
#import "ProductListHeadBtn.h"
#import "ProductListTableCell.h"
#import "ProductListView.h"
#import "ProductPopView.h"
#import "ScanViewController.h"
#import "CustomProDetailVC.h"
#import "AllListPopView.h"
#import "CDRTranslucentSideBar.h"
#import "ScreeningRightView.h"
#import "ScreenPopView.h"
#import "FinishedProInfoVC.h"
#import "ProductInfo.h"
#import "ScreeningInfo.h"
#import "OrderDetailVC.h"
#import "StrWithIntTool.h"
#import "DetailTypeInfo.h"
#import "AllListHeadView.h"
#import "ClassListController.h"
#import "OrderListController.h"
#import "ConfirmOrderVC.h"
#import "OrderNumTool.h"
#import "CustomTextField.h"
#define MENUHEIHT 40
@interface ProductListVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,
                        productItemClickDelegate,CDRTranslucentSideBarDelegate>{
    int curPage;
    int pageCount;
    int totalCount;//商品总数量
}
@property (weak, nonatomic) AllListHeadView *heaView;
@property (weak, nonatomic) UITextField *searchFie;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (copy, nonatomic) NSString *keyWord;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) UIView *baView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ScreenPopView *screenPop;
@property (nonatomic, strong) AllListPopView *popClassView;
@property (nonatomic, strong) CDRTranslucentSideBar *rightSideBar;
@property (nonatomic, strong) ScreeningRightView *slideRightTab;
@end

@implementation ProductListVC

- (UIView *)baView{
    if (_baView==nil) {
        _baView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SDevWidth, SDevHeight)];
        _baView.backgroundColor = CUSTOM_COLOR_ALPHA(0, 0, 0, 0.5);
    }
    return _baView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseAllViewData];
}

- (void)setBaseAllViewData{
    self.dataArray = [NSMutableArray new];
    self.orderNumLab.layer.cornerRadius = 8;
    self.orderNumLab.layer.masksToBounds = YES;
    [self.orderNumLab setAdjustsFontSizeToFitWidth:YES];
    pageCount = 10;
    curPage = 1;
    [self setupSearchBar];
    [self setupRightItem];
    [self setupRightSiderBar];
    [self setProTableView];
    [self setPopView];
    [self setupHeadView];
    [self setupHeaderRefresh];
    [self creatNearNetView:^(BOOL isWifi) {
        [self.tableView.header beginRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    App;
    [OrderNumTool orderWithNum:app.shopNum andView:self.orderNumLab];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_searchFie resignFirstResponder];
}

#pragma mark -- 创建导航按钮-头视图
- (void)setProTableView{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DefaultColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(40.5);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)setupSearchBar{
    CGFloat width = SDevWidth*0.70;
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,  width, 30)];
    titleView.backgroundColor = [UIColor clearColor];
    CustomTextField *titleFie = [[CustomTextField alloc]initWithFrame:CGRectMake(0, 0, width-40, 30)];
    titleFie.delegate = self;

    UIButton *seaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seaBtn.frame = CGRectMake(width-35, 0, 30, 30);
    [seaBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [seaBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [titleView addSubview:titleFie];
    [titleView addSubview:seaBtn];
    _searchFie = titleFie;
    self.navigationItem.titleView = titleView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchClick];
    return YES;
}

- (void)searchClick{
    [_searchFie resignFirstResponder];
    NSMutableArray *addArr = @[].mutableCopy;
    if (_searchFie.text.length>0) {
        NSArray *arr = [_searchFie.text componentsSeparatedByString:@" "];
        for (NSString *str in arr) {
            if (![str isEqualToString:@""]) {
                [addArr addObject:str];
            }
        }
        self.keyWord = [StrWithIntTool strWithArr:addArr];
        [self changeTextFieKeyWord:self.keyWord];
    }
    if (self.keyWord.length>0&&_searchFie.text.length==0) {
        [self changeTextFieKeyWord:@""];
    }
}

- (void)setupRightItem{
    UIView *right = [YQItemTool setItem:self Action:@selector(scan:)
                                               image:@"iocn_qr" title:@"扫一扫"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:right];
}

- (void)scan:(id)sender{
    ScanViewController *scan = [ScanViewController new];
    scan.scanBack = ^(id message){
        [self changeTextFieKeyWord:message];
    };
    [self.navigationController pushViewController:scan animated:YES];
}

- (void)changeTextFieKeyWord:(NSString *)searchWord{
    _searchFie.text = searchWord;
    _keyWord = searchWord;
    [self.tableView.header beginRefreshing];
}

#pragma mark -- 创建侧滑菜单
- (void)setupRightSiderBar{
    self.rightSideBar = [[CDRTranslucentSideBar alloc] initWithDirection:YES];
    self.rightSideBar.delegate = self;
    self.rightSideBar.sideBarWidth = SDevWidth*0.8;
    CGRect frame = CGRectMake(0, 20, SDevWidth*0.8, SDevHeight-20);
    ScreeningRightView *slideTab = [[ScreeningRightView alloc]initWithFrame:frame];
    slideTab.tableBack = ^(NSDictionary *dict,BOOL isSel){
        [self.backDict removeAllObjects];
        [self.backDict addEntriesFromDictionary:dict];
        [self.tableView.header beginRefreshing];
    };
    [self.rightSideBar setContentViewInSideBar:slideTab];
    slideTab.rightSideBar = self.rightSideBar;
    self.slideRightTab = slideTab;
}

#pragma mark - Gesture Handler 侧滑出菜单
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.rightSideBar.isCurrentPanGestureTarget = YES;
    }
    [self.rightSideBar handlePanGestureToShow:recognizer inView:self.view];
}

#pragma mark - CDRTranslucentSideBarDelegate
- (void)sideBar:(CDRTranslucentSideBar *)sideBar willAppear:(BOOL)animated
{
    [self.view addSubview:self.baView];
}

- (void)sideBar:(CDRTranslucentSideBar *)sideBar willDisappear:(BOOL)animated
{
    [self.baView removeFromSuperview];
}

#pragma mark -- 顶部5个按钮
- (IBAction)classList:(UIButton *)sender {
    [_searchFie resignFirstResponder];
    self.titleBtn.selected = !self.titleBtn.selected;
    if (self.titleBtn.selected) {
        [self.view addSubview:self.popClassView];
    }else{
        [self.popClassView removeFromSuperview];
    }
}

- (IBAction)currentOrder:(id)sender {
    ConfirmOrderVC *orderVC = [ConfirmOrderVC new];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)historyOrder:(id)sender {
    OrderListController *listVC = [OrderListController new];
    [self.navigationController pushViewController:listVC animated:YES];
}

- (IBAction)classifyQuery:(id)sender {
    ClassListController *classVc = [ClassListController new];
    classVc.listBack = ^(BOOL isYes){
        if (isYes) {
            [self.tableView.header beginRefreshing];
        }
    };
    [self.navigationController pushViewController:classVc animated:YES];
}

- (IBAction)screenyClick:(id)sender {
    [_searchFie resignFirstResponder];
    [self.rightSideBar show];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.titleBtn.selected){
        self.titleBtn.selected = NO;
    }
    if (self.heaView.lBtn.selected){
        self.heaView.lBtn.selected = NO;
    }
    [self.popClassView removeFromSuperview];
    [self.screenPop removeFromSuperview];
}
#pragma mark -- 头视图
- (void)setupHeadView{
    CGRect frame = CGRectMake(0, 0, SDevWidth, 40);
    AllListHeadView *headView = [[AllListHeadView alloc]initWithFrame:frame];
    [headView.tBtn addTarget:self action:@selector(openClick:)
                                  forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = headView;
    self.heaView = headView;
}

- (void)openClick:(UIButton *)btn{
    [_searchFie resignFirstResponder];
    self.heaView.lBtn.selected = !self.heaView.lBtn.selected;
    if (self.heaView.lBtn.selected) {
        [self.view addSubview:self.screenPop];
    }else{
        [self.screenPop removeFromSuperview];
    }
}
//弹出视图
- (void)setPopView{
    CGRect allFrame = CGRectMake(0, 40, SDevWidth, SDevHeight-40);
    AllListPopView * allPop = [[AllListPopView alloc]initWithFrame:allFrame
                                                          andFloat:self.titleLab.x];
    allPop.popBack = ^(id dict){
        if (self.titleBtn.selected){
            self.titleBtn.selected = NO;
        }
        [_backDict removeAllObjects];
        _titleLab.text = [dict allValues][0];
        _backDict[@"category"] = [dict allKeys][0];
        [self changeTextFieKeyWord:@""];
    };
    self.popClassView = allPop;
    
    CGRect frame = CGRectMake(0, 80, SDevWidth, SDevHeight-80);
    ScreenPopView *popView = [[ScreenPopView alloc]initWithFrame:frame];
    popView.popBack = ^(NSDictionary *dict){
        if (self.heaView.lBtn.selected){
            self.heaView.lBtn.selected = NO;
        }
        [_backDict removeAllObjects];
        [_backDict addEntriesFromDictionary:dict];
        [self.tableView.header beginRefreshing];
    };
    self.screenPop = popView;
}

#pragma mark -- 网络请求
- (void)setupHeaderRefresh{
    // 刷新功能
    MJRefreshStateHeader*header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];
    [header setTitle:@"用力往下拉我!!!" forState:MJRefreshStateIdle];
    [header setTitle:@"快放开我!!!" forState:MJRefreshStatePulling];
    [header setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
    _tableView.header = header;
    [self.tableView.header beginRefreshing];
}

- (void)setupFootRefresh{
    
    MJRefreshAutoNormalFooter*footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];
    [footer setTitle:@"上拉有惊喜" forState:MJRefreshStateIdle];
    [footer setTitle:@"好了，可以放松一下手指" forState:MJRefreshStatePulling];
    [footer setTitle:@"努力加载中，请稍候" forState:MJRefreshStateRefreshing];
    _tableView.footer = footer;
}
#pragma mark - MJRefresh
- (void)headerRereshing{
    [self loadNewRequestWith:YES];
}

- (void)footerRereshing{
    [self loadNewRequestWith:NO];
}

- (void)loadNewRequestWith:(BOOL)isPullRefresh{
    if (isPullRefresh){
        curPage = 1;
        [self.dataArray removeAllObjects];
    }
    NSMutableDictionary *params = [self dictForLoadData];
    [self getCommodityData:params];
}

- (NSMutableDictionary *)dictForLoadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tokenKey"] = [AccountTool account].tokenKey;
    if (_keyWord.length>0) {
        params[@"keyword"] = _keyWord;
    }
    params[@"cpage"] = @(curPage);
    if (self.backDict.count>0) {
        [params addEntriesFromDictionary:self.backDict];
    }
    return params;
}
#pragma mark - 信息查找
//通过搜索关键词查找信息
- (void)getCommodityData:(NSMutableDictionary *)params{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"%@modelListPage",baseUrl];
    [BaseApi getGeneralData:^(BaseResponse *response, NSError *error) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        if ([response.error intValue]==0) {
            [self setupFootRefresh];
            if ([YQObjectBool boolForObject:response.data]){
                [self setupDataWithData:response.data];
                [self setupListDataWithDict:response.data];
                [self.tableView reloadData];
                if ([YQObjectBool boolForObject:response.data[@"waitOrderCount"]]) {
                    App;
                    app.shopNum = [response.data[@"waitOrderCount"]intValue];
                    [OrderNumTool orderWithNum:app.shopNum andView:self.orderNumLab];
                }
            }
            [SVProgressHUD dismiss];
        }
    } requestURL:url params:params];
}
//初始化数据
- (void)setupDataWithData:(NSDictionary *)data{
    if([YQObjectBool boolForObject:data[@"typeList"]]){
        self.slideRightTab.goods = [ScreeningInfo
                              objectArrayWithKeyValuesArray:data[@"typeList"]];
    }
    if (data[@"typeFiler"]||data[@"searchValue"]) {
        self.screenPop.list = @[data[@"typeFiler"],data[@"searchValue"]];
    }
    if([YQObjectBool boolForObject:data[@"customList"]]){
        self.popClassView.productList = [DetailTypeInfo
                             objectArrayWithKeyValuesArray:data[@"customList"]];
    }
}
//初始化列表数据
- (void)setupListDataWithDict:(NSDictionary *)data{
    if([YQObjectBool boolForObject:data[@"model"][@"modelList"]]){
        self.tableView.footer.state = MJRefreshStateIdle;
        curPage++;
        totalCount = [data[@"model"][@"list_count"]intValue];
        NSArray *seaArr = [ProductInfo objectArrayWithKeyValuesArray:data[@"model"][@"modelList"]];
        [_dataArray addObjectsFromArray:seaArr];
        if(_dataArray.count>=totalCount){
            MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.tableView.footer;
            [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
            self.tableView.footer.state = MJRefreshStateNoMoreData;
        }
    }else{
//        [self.tableView.header removeFromSuperview];
        MJRefreshAutoNormalFooter*footer = (MJRefreshAutoNormalFooter*)self.tableView.footer;
        [footer setTitle:@"暂时没有商品" forState:MJRefreshStateNoMoreData];
        self.tableView.footer.state = MJRefreshStateNoMoreData;
    }
}

#pragma mark - tableViewDatasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int row = 0;
    if (self.dataArray.count %2 == 0)
    {
        row = (int)self.dataArray.count/2;
    }else{
        row = (int)self.dataArray.count/2 + 1;
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductListTableCell *tableCell = [ProductListTableCell cellWithTableView:tableView
                                                                andDelegate:self];
    [tableCell updateDevInfoWith:self.dataArray index:(int)indexPath.row];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableCell;
}

#pragma mark - productItemClickDelegate
- (void)productItemClickWith:(int)index
{
    ProductInfo *info = self.dataArray[index];
    CustomProDetailVC *customDeVC = [CustomProDetailVC new];
    customDeVC.proId = info.id;
    [self.navigationController pushViewController:customDeVC animated:YES];
}

@end
