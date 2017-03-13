//
//  OrderListController.m
//  MillenniumStarERP
//
//  Created by yjq on 16/10/26.
//  Copyright © 2016年 com.millenniumStar. All rights reserved.
//

#import "OrderListController.h"
#import "UserManagerMenuHrizontal.h"
#import "UserManagerScrollPageView.h"
#define MENUHEIHT 40
@interface OrderListController ()<UserManagerMenuHrizontalDelegate,UserManagerScrollPageViewDelegate>{
    NSArray*titleArray;
    UserManagerScrollPageView*mScrollPageView;
    UserManagerMenuHrizontal*menuHorizontalView;
}
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *cellDataArray;
@property (nonatomic, strong) UIView *tempPagesView;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, assign) int intoViewCount;
@end

@implementation OrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定制";
    titleArray = @[@{@"title":@"待审核",@"netUrl":@"ModelOrderWaitCheckList",@"proId":@"10"},
                   @{@"title":@"生产中",@"netUrl":@"ModelOrderProduceListPage",@"proId":@"20"},
                   @{@"title":@"已发货",@"netUrl":@"ModelBillList",@"proId":@"30"},
                   @{@"title":@"已完成",@"netUrl":@"",@"proId":@"40"}];
    [self initCustomView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headBtnNum:)
                                              name:NotificationList object:nil];
}
//显示条数
- (void)headBtnNum:(NSNotification *)notification{
    NSMutableArray *arr = notification.userInfo[ListNum];
    menuHorizontalView.imgArr = arr.copy;
}

#pragma mark UI初始化
- (void)initCustomView{
    //main view
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGRect vViewRect = CGRectMake(0, 0, SDevWidth, SDevHeight);
    UIView *mainContentView = [[UIView alloc] initWithFrame:vViewRect];
    menuHorizontalView = [[UserManagerMenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, SDevWidth, MENUHEIHT) ButtonItems:titleArray];
    menuHorizontalView.delegate = self;
    //默认选中第一个button
    [menuHorizontalView clickButtonAtIndex:_index];
    
    [mainContentView addSubview:menuHorizontalView];
    //初始化滑动列表
    mScrollPageView = [[UserManagerScrollPageView alloc] initScrollPageView:CGRectMake(0, MENUHEIHT, SDevWidth, mainContentView.frame.size.height - MENUHEIHT) navigation:self.navigationController];
    mScrollPageView.navigationController = self.navigationController;
    mScrollPageView.delegate = self;
    [mScrollPageView setContentOfTables:titleArray nav:self.navigationController];
    [mainContentView addSubview:mScrollPageView];
    //初始化选择
    [mScrollPageView moveScrollowViewAthIndex:_index];
    [menuHorizontalView changeButtonStateAtIndex:_index];
    [self.view addSubview:mainContentView];
}

#pragma mark - 其他辅助功能
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)index{
    _index = (int)index;
    [mScrollPageView moveScrollowViewAthIndex:index];
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)page{
    _index = (int)page;
    [menuHorizontalView changeButtonStateAtIndex:page];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
