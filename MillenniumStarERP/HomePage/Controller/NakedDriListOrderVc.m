//
//  NakedDriListOrderVc.m
//  MillenniumStarERP
//
//  Created by yjq on 17/5/31.
//  Copyright © 2017年 com.millenniumStar. All rights reserved.
//

#import "NakedDriListOrderVc.h"
#import "UserManagerMenuHrizontal.h"
#import "UserManagerScrollPageView.h"
#import "SearchOrderVc.h"
#define MENUHEIHT 40
@interface NakedDriListOrderVc ()<UserManagerMenuHrizontalDelegate,UserManagerScrollPageViewDelegate>{
    NSArray*titleArray;
    UserManagerScrollPageView*mScrollPageView;
    UserManagerMenuHrizontal*menuHorizontalView;
}

@end

@implementation NakedDriListOrderVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"裸钻库所有订单";
    titleArray = @[@{@"title":@"待付款",@"netUrl":@"stoneWaitPayOrderList",@"proId":@"10"},
                   @{@"title":@"已付款",@"netUrl":@"stoneAlreadyPayOrderList",@"proId":@"20"},
                   @{@"title":@"已发货",@"netUrl":@"stoneAlreadyDeliverGoodsOrderList",
                     @"proId":@"30"},
                   @{@"title":@"已完成",@"netUrl":@"stoneAlreadyFinishOrderList",
                     @"proId":@"40"}];
    [self initCustomView];
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
    mScrollPageView.delegate = self;
    [mScrollPageView setContentOfTables:titleArray table:@"NakedDriOrderListView"];
    [mainContentView addSubview:mScrollPageView];
    //初始化选择
    [mScrollPageView moveScrollowViewAthIndex:_index];
    [menuHorizontalView changeButtonStateAtIndex:_index];
    [self.view addSubview:mainContentView];
}

#pragma mark - 其他辅助功能
- (void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)index{
    _index = (int)index;
    [mScrollPageView moveScrollowViewAthIndex:index];
}

#pragma mark ScrollPageViewDelegate
- (void)didScrollPageViewChangedPage:(NSInteger)page{
    _index = (int)page;
    [menuHorizontalView changeButtonStateAtIndex:page];
}

@end
